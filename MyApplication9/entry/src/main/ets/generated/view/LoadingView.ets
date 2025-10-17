
import { CommonConstants } from '../common/CommonConstants'

@Component
export struct LoadingView {
  build() {
    Column() {
      Row() {
        LoadingProgress()
      }
      .margin({ top: "260vp" })
      .width("72vp")
      .height("72vp")
    }
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
  }
}