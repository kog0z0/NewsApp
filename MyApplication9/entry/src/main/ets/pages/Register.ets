import router from '@ohos.router'
import RdbUtils from '../common/RdbUtils'
import { Users } from '../mode/Users'
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Register {
  @State account: string = ''
  @State password: string = ''

  build() {
    Column({ space: 10 }) {
      Image($r('app.media.ic_logo'))
        .width('100vp')
        .margin({ top: 120 })

      TextInput({
        placeholder: '请输入注册账号'
      })
        .width(300)
        .onChange((val: string) => this.account = val)

      TextInput({
        placeholder: '请输入注册密码'
      })
        .width(300)
        .onChange((val: string) => this.password = val)
        .type(InputType.Password)

      // 注册按钮
      Button('注册')
        .width("80%")
        .backgroundColor('#ff1c1b1b') // 使用不同的颜色区分
        .margin({top:50})
        .onClick(() => {
          this.handleRegister()
        })

      Button('返回')
        .width("80%")
        .backgroundColor('#fff53030') // 使用不同的颜色区分
        .margin({top:20})
        .onClick(() => {
          router.pushUrl({url:'pages/Login'})
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#ffffc8c8')
  }

  // 注册处理逻辑
  private handleRegister() {
    if (!this.validateInput()) {
      return;
    }

    RdbUtils.queryUserByAccount(this.account).then((users: Users) => {
      if (users != null) {
        promptAction.showToast({
          message: "账号已存在，请直接登录",
          duration: 3000
        })
      } else {
        RdbUtils.insertOne("USERS", {
          account: this.account,
          password: this.password
        }).then((updateNumber) => {
          promptAction.showToast({
            message: "注册成功，请登录",
            duration: 3000
          })
          // 注册成功后清空输入框，方便用户重新输入登录
          this.account = ''
          this.password = ''
        }).catch((error: Error) => {
          console.log('插入失败:' + error)
          promptAction.showToast({
            message: "注册失败，请重试",
            duration: 3000
          })
        })
      }
    }).catch((error: Error) => {
      console.log("用户查询失败：" + error)
      promptAction.showToast({
        message: "注册失败，请重试",
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