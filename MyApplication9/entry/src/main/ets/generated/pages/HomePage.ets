import { HorizontalTabNavModule } from '../view/HorizontalTabNavModule';
import { NewsListModule } from '../view/NewsListModule';
import { SearchInputModule } from '../view/SearchInputModule';

@Component
export struct HomePage {
  private scroller: Scroller = new Scroller();

  build() {
    Flex({ direction: FlexDirection.Column }) {

      Scroll(this.scroller) {
        Column() {
          //搜索框
          SearchInputModule()

          HorizontalTabNavModule()
					NewsListModule()
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
