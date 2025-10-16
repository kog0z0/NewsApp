import { SubscribedChannelsModule } from '../view/SubscribedChannelsModule';
import { RecommendedChannelModule } from '../view/RecommendedChannelModule';
import { ChannelManageHintModule } from '../view/ChannelManageHintModule';
import { OperationButtonModule } from '../view/OperationButtonModule';

@Component
export struct ChannelManagementPage {
  private scroller: Scroller = new Scroller();

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Scroll(this.scroller) {
        Column() {
          SubscribedChannelsModule()
					RecommendedChannelModule()
					ChannelManageHintModule()
					OperationButtonModule()
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
