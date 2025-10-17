
import { FavoriteNewsModule } from '../view/FavoriteNewsModule';

@Component
export struct MyCollectionPage {
  private scroller: Scroller = new Scroller();

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Scroll(this.scroller) {
        Column() {
<<<<<<< Updated upstream
          // UserProfileModule()
=======
>>>>>>> Stashed changes
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
