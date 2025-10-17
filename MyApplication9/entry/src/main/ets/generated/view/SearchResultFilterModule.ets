
import { CommonConstants } from '../common/CommonConstants';

@Component
export struct SearchResultFilterModule {
  @State titles: string[] = ['全部'];
  @State currentIndex: number = 0;

  @Builder
  TabBuilder(index: number, title: string) {
    Column() {
      Text(title)
        .width(CommonConstants.FULL_PERCENT)
        .height('95%')
        .fontSize($r('app.integer.subtitle_text_S'))
        .fontColor(this.currentIndex === index ? $r('app.color.font_primary') : $r('app.color.font_secondary'))
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Medium)
        .backgroundColor(this.currentIndex === index ? $r('app.color.comp_background_primary_trans') :
        $r('app.color.comp_background_primary_trans'))
        .textAlign(TextAlign.Center)
      if (this.currentIndex === index) {
        Line()
          .width('20%')
          .height(2)
          .backgroundColor($r('app.color.font_primary'))
      }
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('app.color.comp_background_primary_trans'))
  }

  build() {
    Column() {
      Tabs() {
        ForEach(this.titles, (item: string, index: number) => {
          TabContent() {
          }

        })
      }
      .width('auto')
      .height('auto')
      .scrollable(true)
      .barPosition(BarPosition.Start)
      .vertical(false)
      .barWidth(CommonConstants.FULL_PERCENT)
      .barHeight(40)
      .barBackgroundColor(Color.White)
      .onChange((index: number) => {
        this.currentIndex = index
      })
    }
    .width('100%')
  }
}