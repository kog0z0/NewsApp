
import { CommonConstants } from '../common/CommonConstants';


@Component
export struct EmptyPagePathStack {
  @Consume('appPathStack') appPathStack: NavPathStack;

  build() {
    NavDestination() {
      Column() {
        TopNavigationView({
          title: "详情页",
          onBackClick: () => {
            this.appPathStack.pop();
          }
        })
       Image($r("app.media.realImageGen_travel_0"))
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Center)
      .width(CommonConstants.FULL_PERCENT)
      .height(CommonConstants.FULL_PERCENT)
    }
    .hideTitleBar(true)
  }
}

@Builder
export function EmptyPagePathStackBuilder() {
  EmptyPagePathStack()
}

@Component
struct TopNavigationView {
  title?: ResourceStr;
  onBackClick?: Function;

  build() {
    Row() {
      if (this.onBackClick) {
        Image($r('app.media.ic_back'))
          .width("40vp")
          .height("40vp")
          .margin({ right: "16vp" })
          .onClick(() => this.onBackClick?.())
      }

      Text(this.title)
        .fontSize("20fp")
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)
        .layoutWeight(1)
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .width(CommonConstants.FULL_PERCENT)
    .height("56vp")
    .padding({
      left: "24vp",
      right: "24vp"
    })
  }
}
