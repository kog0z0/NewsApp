
import { curves } from '@kit.ArkUI';
import { CommonConstants } from '../common/CommonConstants';

@Builder
export function SearchModuleWithButtonPageBuilder() {
  SearchModuleWithButtonPage()
}

@Component
export default struct SearchModuleWithButtonPage {
  private pageInfos: NavPathStack = new NavPathStack();

  private onArrowClicked(): void {
    this.pageInfos.pop(false);
  }

  build() {
    NavDestination() {
      Row() {
        Search({ placeholder: '搜索交通/酒店/景点等' })
          .searchButton('搜索')
          .enableKeyboardOnFocus(false)
          .placeholderColor(Color.Black)
          .placeholderFont({
            family: "HarmonyHeiTi",
            size: 16,
            weight: 400
          })
          .borderColor($r('sys.color.font_primary'))
          .searchIcon({ color: Color.Black })
          .backgroundColor(Color.White)
          .defaultFocus(true)
          .focusOnTouch(true)
          .fontColor(Color.Black)
          .width('85%')
          .padding({
            left: "24vp",
            right: "24vp"
          })
      }
      .width(CommonConstants.FULL_PERCENT)
      .height(50)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: '10vp' })
    }
    .transition(TransitionEffect.OPACITY)
    .hideTitleBar(true)
    .backgroundColor('#F1F3F5')
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
    .onBackPressed(() => {
      animateTo({
        curve: curves.interpolatingSpring(0, 1, 342, 38),
      }, () => {
        this.pageInfos.pop(false);
      })
      return true;
    })
  }
}