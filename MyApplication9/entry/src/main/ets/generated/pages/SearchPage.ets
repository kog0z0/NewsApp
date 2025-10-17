import { router } from '@kit.ArkUI';
import { SearchResultFilterModule } from '../view/SearchResultFilterModule';

@Component
export struct SearchPage {
  private scroller: Scroller = new Scroller();
  @Consume('appPathStack') appPathStack: NavPathStack;
  @State receivedKeyword: string = '';
  aboutToAppear() {
    const params = router.getParams() as Record<string, Object>;
    if (params && params['keyword']) {
      this.receivedKeyword = params['keyword'] as string;
      console.log('接收到搜索关键词:', this.receivedKeyword);
    }
  }
  build() {
    Flex({ direction: FlexDirection.Column }) {

      Scroll(this.scroller) {
        Column() {
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
