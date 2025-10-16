import { NewsContentDisplayModule } from '../view/NewsContentDisplayModule';
import { RelatedNewsRecommendModule } from '../view/RelatedNewsRecommendModule';

@Component
export struct NewsDetailPage {
  private scroller: Scroller = new Scroller();

  build() {
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
}
