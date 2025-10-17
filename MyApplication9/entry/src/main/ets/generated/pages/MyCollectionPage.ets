import { UserProfileModule } from '../view/UserProfileModule';
import { FavoriteNewsModule } from '../view/FavoriteNewsModule';

@Component
export struct MyCollectionPage {
  private scroller: Scroller = new Scroller();

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Scroll(this.scroller) {
        Column() {
          // UserProfileModule()
					FavoriteNewsModule()
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
