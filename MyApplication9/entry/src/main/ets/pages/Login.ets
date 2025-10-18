import router from '@ohos.router'
import RdbUtils from '../common/RdbUtils'
import { Users } from '../mode/Users'
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Login {
  @State account: string = ''
  @State password: string = ''

  build() {
    Column({ space: 10 }) {
      Image($r('app.media.ic_logo'))
        .width('100vp')
        .margin({ top: 120 })

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

      // 注册按钮
      Button('注册')
        .width("80%")
        .backgroundColor('#fff53030') // 使用不同的颜色区分
        .margin({top:20})
        .onClick(() => {
          router.pushUrl({ url: 'pages/Register'})
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffc8c8')
  }

  // 登录处理逻辑
  private handleLogin() {
    if (!this.validateInput()) {
      return;
    }

    RdbUtils.queryUserByAccount(this.account).then((users: Users) => {
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
          // 将用户信息保存到缓存中
          RdbUtils.saveCache('account', this.account)
          RdbUtils.saveCache('password', this.password)
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
  }

  // 输入验证
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

    // 可以添加更多的验证规则，比如密码长度等
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