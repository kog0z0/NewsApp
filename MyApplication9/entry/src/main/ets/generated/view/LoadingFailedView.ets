
import { CommonConstants } from '../common/CommonConstants'

@Builder
export function LoadingFailedView(handleReload?: () => void) {
  Row() {
    Column() {
      Image($r('app.media.ic_failure'))
        .width("120vp")
        .height("120vp")
      Text("Failed to load the network")
        .fontColor($r('sys.color.mask_secondary'))
        .fontFamily(CommonConstants.HARMONY_HEI_TI_FONT_FAMILY)
        .fontSize("14fp")
        .margin({ top: "8vp" })
      Row() {
        Text("Reload")
          .fontColor("#FF3E50")
          .fontFamily(CommonConstants.HARMONY_HEI_TI_FONT_FAMILY)
          .fontSize("12fp")
          .width(CommonConstants.FULL_PERCENT)
          .textAlign(TextAlign.Center)
      }
      .height("32vp")
      .width("80vp")
      .margin({ top: "8vp" })
      .borderRadius($r('sys.float.corner_radius_level6'))
      .onClick(() => handleReload?.())
    }
  }
  .justifyContent(FlexAlign.Center)
  .layoutWeight(1)
}