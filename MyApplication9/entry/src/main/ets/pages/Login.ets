import router from '@ohos.router'
import RdbUtils from '../common/RdbUtils'
import { Users } from '../mode/Users'
import promptAction from '@ohos.promptAction';
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct Login {
  @State account: string = ''
  @State password: string = ''
  @State avatarUri: Resource | string = $r('app.media.ic_logo') // 默认头像
  @State selectedAvatar: string = '' // 选择的头像文件路径

  build() {
    Column({ space: 10 }) {
      // 可点击的头像
      Image(this.avatarUri)
        .width(100)
        .height(100)
        .borderRadius(50) // 圆形头像
        .border({ width: 2, color: Color.White })
        .onClick(() => {
          this.selectAvatar()
        })
        .margin({ top: 80 })
      

      TextInput({
        placeholder: '请输入登录账号'
      })
        .width(300)
        .onChange((val: string) => this.account = val)

      TextInput({
        placeholder: '请输入登录密码'
      })
        .width(300)
        .onChange((val: string) => this.password = val)
        .type(InputType.Password)

      Button('登录')
        .width("80%")
        .backgroundColor('#ff080909')
        .margin({top:50})
        .onClick(() => {
          this.handleLogin()
        })

      Button('注册')
        .width("80%")
        .backgroundColor('#fff53030')
        .margin({top:20})
        .onClick(() => {
          router.pushUrl({ url: 'pages/Register'})
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffc8c8')
  }

  // 选择头像
  private async selectAvatar() {
    try {
      const photoSelectOptions = new picker.PhotoSelectOptions();
      photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 1; // 只能选择一张图片

      const photoPicker = new picker.PhotoViewPicker();
      const photoSelectResult = await photoPicker.select(photoSelectOptions);

      if (photoSelectResult && photoSelectResult.photoUris.length > 0) {
        const selectedImageUri = photoSelectResult.photoUris[0];
        this.selectedAvatar = selectedImageUri;
        this.avatarUri = selectedImageUri;

        promptAction.showToast({
          message: "头像选择成功",
          duration: 2000
        })
      }
    } catch (err) {
      console.error("选择头像失败: " + JSON.stringify(err));
      promptAction.showToast({
        message: "选择头像失败",
        duration: 3000
      })
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

      // 复制文件到应用目录
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

  // 修改登录处理逻辑
  private async handleLogin() {
    if (!this.validateInput()) {
      return;
    }

    try {
      // 如果有选择新头像，先保存
      let avatarPath = '';
      if (this.selectedAvatar) {
        avatarPath = await this.saveAvatarToLocal();
      }

      RdbUtils.queryUserByAccount(this.account).then(async (users: Users) => {
        if (users == null) {
          promptAction.showToast({
            message: "账号不存在，请先注册",
            duration: 3000
          })
        } else {
          if (this.password != users.password) {
            promptAction.showToast({
              message: "密码错误",
              duration: 3000
            })
          } else {
            // 如果有新头像，更新用户头像路径
            if (avatarPath) {
              // 这里需要添加更新用户头像的方法
              await RdbUtils.updateUserAvatar(this.account, avatarPath);
            }

            // 将用户信息保存到缓存中
            RdbUtils.saveCache('account', this.account)
            RdbUtils.saveCache('password', this.password)
            RdbUtils.saveCache('avatar', avatarPath || users.avatar || '') // 保存头像路径

            promptAction.showToast({
              message: "登录成功",
              duration: 2000
            })
            router.pushUrl({ url: 'pages/Index' })
          }
        }
      }).catch((error: Error) => {
        console.log("用户获取数据失败：" + error)
        promptAction.showToast({
          message: "登录失败，请重试",
          duration: 3000
        })
      })
    } catch (error) {
      console.error("登录过程出错: " + error);
      promptAction.showToast({
        message: "登录失败，请重试",
        duration: 3000
      })
    }
  }

  // 输入验证（保持不变）
  private validateInput(): boolean {
    if (!this.account || this.account.trim().length === 0) {
      promptAction.showToast({
        message: "请输入账号",
        duration: 2000
      })
      return false
    }

    if (!this.password || this.password.trim().length === 0) {
      promptAction.showToast({
        message: "请输入密码",
        duration: 2000
      })
      return false
    }

    if (this.password.length < 6) {
      promptAction.showToast({
        message: "密码长度至少6位",
        duration: 3000
      })
      return false
    }

    return true
  }
}