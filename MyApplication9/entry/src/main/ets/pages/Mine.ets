import router from '@ohos.router';
import RdbUtils from '../common/RdbUtils';
import ItemData from '../mode/ItemData';

@Entry
@Component
export struct Mine {
  scroller: Scroller = new Scroller();
  @Provide account: string = '';
  @State login:boolean = false;
  async aboutToAppear() {
    try {
      let that = this;
      if (!RdbUtils.dataPreferences) {
        console.error("dataPreferences is not initialized");
        return;
      }
     await RdbUtils.dataPreferences.get('account', '', (err, val) => {
       if (err) {
         console.error("Failed to get value of 'account'. code =" + err.code + ", message =" + err.message);
         return;
       }
       console.info("Succeeded in getting value of 'account'. val： " + val);
       if (val) {
         that.account = val.toString();
         that.login = true;
       }
     })
    } catch (err) {
      console.error("Failed to get value of 'account'. code =" + err.code + ", message =" + err.message);
    }
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
      //可以进入下一级页面
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
            Image($r('app.media.user_photo'))
              .width(64)
              .height(64)
            Text(!this.login ? '立即登录' : this.account).fontColor(Color.White)
          }.onClick(() => {
            if (!this.login) {
              router.pushUrl({ url: 'pages/Login' })
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
                  try {
                    this.login=false
                    if (!RdbUtils.dataPreferences) {
                      console.error("dataPreferences is not initialized");
                      return;
                    }
                    RdbUtils.dataPreferences.delete('account', (err) => {
                      router.pushUrl({url:'pages/Login'})
                    })
                  } catch (err) {
                  }
                })
            }
          }
          .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
          .scrollBar(BarState.On) // 滚动条常驻显示
          .scrollBarColor(Color.Gray) // 滚动条颜色
          .scrollBarWidth(5) // 滚动条宽度
          .margin({ top: 15 })
          .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹
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
