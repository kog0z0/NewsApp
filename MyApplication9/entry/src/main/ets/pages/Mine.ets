import router from '@ohos.router';
import RdbUtils from '../common/RdbUtils';
import ItemData from '../mode/ItemData';
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import promptAction from '@ohos.promptAction';

@Entry
@Component
export struct Mine {
  scroller: Scroller = new Scroller();
  @Provide account: string = '';
  @State login: boolean = false;
  @State avatarUri: string = ''; // 头像文件路径
  @State selectedAvatar: string = ''; // 新选择的头像
  @State useDefaultAvatar: boolean = true; // 添加这个缺失的状态变量

  async aboutToAppear() {
    try {
      let that = this;
      if (!RdbUtils.dataPreferences) {
        console.error("dataPreferences is not initialized");
        return;
      }

      // 获取账号信息
      await RdbUtils.dataPreferences.get('account', '', (err, val) => {
        if (err) {
          console.error("Failed to get value of 'account'. code =" + err.code + ", message =" + err.message);
          return;
        }
        console.info("Succeeded in getting value of 'account'. val： " + val);
        if (val) {
          that.account = val.toString();
          that.login = true;

          // 获取用户头像
          that.loadUserAvatar();
        } else {
          // 未登录，使用默认头像
          that.useDefaultAvatar = true;
        }
      });
    } catch (err) {
      console.error("Failed to get value of 'account'. code =" + err.code + ", message =" + err.message);
    }
  }

  // 加载用户头像
  async loadUserAvatar() {
    try {
      // 先从缓存获取头像路径
      if (RdbUtils.dataPreferences) {
        RdbUtils.dataPreferences.get('avatar', '', async (err, avatarVal) => {
          if (!err && avatarVal && avatarVal.toString().length > 0) {
            const avatarPath = avatarVal.toString();
            // 检查文件是否存在
            try {
              await fs.access(avatarPath);
              this.avatarUri = avatarPath;
              this.useDefaultAvatar = false;
            } catch (fileErr) {
              console.error("头像文件不存在，使用默认头像");
              this.useDefaultAvatar = true;
            }
          } else {
            // 从数据库获取头像
            await this.getAvatarFromDatabase();
          }
        });
      }
    } catch (err) {
      console.error("加载用户头像失败: " + JSON.stringify(err));
      this.useDefaultAvatar = true;
    }
  }

  // 从数据库获取头像
  async getAvatarFromDatabase() {
    try {
      const userAvatar = await RdbUtils.getUserAvatar(this.account);
      if (userAvatar && userAvatar.length > 0) {
        // 检查文件是否存在
        try {
          await fs.access(userAvatar);
          this.avatarUri = userAvatar;
          this.useDefaultAvatar = false;
          // 更新缓存
          if (RdbUtils.dataPreferences) {
            RdbUtils.saveCache('avatar', userAvatar);
          }
        } catch (fileErr) {
          console.error("数据库中的头像文件不存在");
          this.useDefaultAvatar = true;
        }
      } else {
        this.useDefaultAvatar = true;
      }
    } catch (err) {
      console.error("从数据库获取头像失败: " + JSON.stringify(err));
      this.useDefaultAvatar = true;
    }
  }

  // 获取当前显示的头像
  getCurrentAvatar(): Resource | string {
    if (this.useDefaultAvatar || !this.avatarUri) {
      return $r('app.media.user_photo'); // 返回 Resource 类型
    } else {
      return this.avatarUri; // 返回 string 类型（文件路径）
    }
  }

  // 选择头像
  private async selectAvatar() {
    if (!this.login) {
      promptAction.showToast({
        message: "请先登录",
        duration: 2000
      });
      return;
    }

    try {
      const photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1;

      const photoPicker = new picker.PhotoViewPicker();
      const photoSelectResult = await photoPicker.select(photoSelectOptions);

      if (photoSelectResult && photoSelectResult.photoUris.length > 0) {
        const selectedImageUri = photoSelectResult.photoUris[0];
        this.selectedAvatar = selectedImageUri;

        const savedPath = await this.saveAvatarToLocal();
        if (savedPath) {
          this.avatarUri = savedPath;
          this.useDefaultAvatar = false;
          await this.updateUserAvatar(savedPath);

          promptAction.showToast({
            message: "头像更新成功",
            duration: 2000
          });
        }
      }
    } catch (err) {
      console.error("选择头像失败: " + JSON.stringify(err));
      promptAction.showToast({
        message: "选择头像失败",
        duration: 3000
      });
    }
  }

  // 保存头像到应用文件目录
  private async saveAvatarToLocal(): Promise<string> {
    if (!this.selectedAvatar) {
      return '';
    }

    try {
      const context = getContext(this) as common.UIAbilityContext;
      const filesDir = context.filesDir;
      const avatarFileName = `avatar_${this.account}_${new Date().getTime()}.jpg`;
      const destPath = `${filesDir}/${avatarFileName}`;

      const sourceFile = await fs.open(this.selectedAvatar, fs.OpenMode.READ_ONLY);
      const destFile = await fs.open(destPath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);

      await fs.copyFile(sourceFile.fd, destFile.fd);
      await fs.close(sourceFile.fd);
      await fs.close(destFile.fd);

      return destPath;
    } catch (err) {
      console.error("保存头像失败: " + JSON.stringify(err));
      return '';
    }
  }

  // 更新用户头像到数据库
  private async updateUserAvatar(avatarPath: string) {
    try {
      await RdbUtils.updateUserAvatar(this.account, avatarPath);
      if (RdbUtils.dataPreferences) {
        RdbUtils.saveCache('avatar', avatarPath);
      }
    } catch (err) {
      console.error("更新用户头像到数据库失败: " + JSON.stringify(err));
      throw new Error(JSON.stringify(err));
    }
  }

  // 退出登录方法
  private async logout() {
    try {
      this.login = false;
      this.useDefaultAvatar = true;
      this.avatarUri = '';

      if (!RdbUtils.dataPreferences) {
        console.error("dataPreferences is not initialized");
        router.pushUrl({url:'pages/Login'});
        return;
      }

      // 删除账号和头像
      await this.deletePreference('account');
      await this.deletePreference('avatar');

      router.pushUrl({url:'pages/Login'});
    } catch (err) {
      console.error("退出登录失败: " + JSON.stringify(err));
      router.pushUrl({url:'pages/Login'});
    }
  }

  // 辅助方法：删除偏好设置
  private deletePreference(key: string): Promise<void> {
    return new Promise((resolve) => {
      if (RdbUtils.dataPreferences) {
        RdbUtils.dataPreferences.delete(key, (err) => {
          if (err) {
            console.error(`Failed to delete ${key}: ` + JSON.stringify(err));
          }
          resolve();
        });
      } else {
        resolve();
      }
    });
  }

  @Builder MineCell(item: ItemData) {
    Row() {
      Row({ space: 12 }) {
        Image(item.img)
          .width(22)
          .height(22)
        Text(item.title)
          .fontSize(16)
      }
      // 可以进入下一级页面
      Image($r('app.media.ic_arrows'))
        .width(24)
        .height(24)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .borderRadius(10)
    .margin({ left: 10, right: 10 })
    .height(50)
    .backgroundColor(Color.White)
    .onClick(() => {
      if('0' == item.index)
      {
        router.pushUrl({url:'pages/MyCollect'})
      }
      if('1' == item.index)
      {
        router.pushUrl({url:'pages/MyComment'})
      }
      if('2' == item.index)
      {
        router.pushUrl({url:'pages/ModifyPwd'})
      }
      if('4' == item.index)
      {
        router.pushUrl({url:'pages/AboutPage'})
      }
    })
    .padding({
      left: 8,
      right: 22
    })
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Flex({ direction: FlexDirection.Column }) {
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Column({ space: 10 }) {
            // 使用 getCurrentAvatar() 方法获取正确的头像
            Image(this.getCurrentAvatar())
              .width(64)
              .height(64)
              .borderRadius(32)
              .border({ width: 2, color: Color.White })
            Text(!this.login ? '立即登录' : this.account)
              .fontColor(Color.White)
              .fontSize(16)
          }
          .onClick(() => {
            if (!this.login) {
              router.pushUrl({ url: 'pages/Login' })
            } else {
              this.selectAvatar();
            }
          })
        }
        .width('100%')
        .height(150)
        .backgroundColor(Color.Red)

        Flex({ direction: FlexDirection.Column }) {
          Scroll(this.scroller) {
            Column({ space: 10 }) {
              if(this.login)
              {
                this.MineCell(new ItemData('0','我的收藏', $r('app.media.ic_my_save') ))
                this.MineCell(new ItemData('1','我的评论', $r('app.media.ic_my_comment') ))
                this.MineCell(new ItemData('2','修改密码', $r('app.media.ic_my_updatepwd')))
              }
              this.MineCell(new ItemData('3','关于我们', $r('app.media.ic_my_about'), undefined))
              Button('退出登录', { type: ButtonType.Capsule, stateEffect: true })
                .backgroundColor($r('app.color.logout_btn_background'))
                .width(290)
                .margin({ top: 120 })
                .visibility(!this.login? Visibility.Hidden : Visibility.Visible)
                .onClick(() => {
                  this.logout();
                })
            }
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.On)
          .scrollBarColor(Color.Gray)
          .scrollBarWidth(5)
          .margin({ top: 15 })
          .edgeEffect(EdgeEffect.Spring)
        }
        .width('100%')
        .flexGrow(1)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xededed)
  }
}