import { SearchInputModule } from '../view/SearchInputModule';
import { SearchKeywordsAndHistoryModule } from '../view/SearchKeywordsAndHistoryModule';
import { SearchResultFilterModule } from '../view/SearchResultFilterModule';

@Component
export struct SearchPage {
  private scroller: Scroller = new Scroller();

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Scroll(this.scroller) {
        Column() {
          SearchInputModule()
					SearchKeywordsAndHistoryModule()
					SearchResultFilterModule()
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
