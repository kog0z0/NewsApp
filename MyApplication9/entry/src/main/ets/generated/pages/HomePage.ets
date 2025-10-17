
import { SearchInputModule } from '../view/SearchInputModule';
import { NewsContentDisplayModule } from '../view/NewsContentDisplayModule';
import { RelatedNewsRecommendModule } from '../view/RelatedNewsRecommendModule';

@Component
export struct HomePage {
  private scroller: Scroller = new Scroller();

  build() {
    Flex({ direction: FlexDirection.Column }) {

      Scroll(this.scroller) {
        Column() {
          SearchInputModule()

          Flex({ direction: FlexDirection.Column }) {
            Scroll(this.scroller) {
              Column() {
                NewsContentDisplayModule()
                RelatedNewsRecommendModule()
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
