import { UserProfileModuleStyleA } from '../view/UserProfileModuleStyleA';
import { ContentAssetsModule } from '../view/ContentAssetsModule';
import { ServiceSettingModule } from '../view/ServiceSettingModule';

@Component
export struct PersonalCenterPage {
  private scroller: Scroller = new Scroller();

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Scroll(this.scroller) {
        Column() {
          UserProfileModuleStyleA()
					ContentAssetsModule()
					ServiceSettingModule()
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .width('100%')
    }
    .backgroundColor($r('app.color.page_bg_color'))
  }
}
