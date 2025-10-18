
@Entry
@Component
struct AboutPage {
  build() {
    Column() {
      Navigation()
        .title(this.NavigationTitle())
        .hideToolBar(true)
        .height(30)
        .width('100%')
    }
  }

  @Builder NavigationTitle() {
    Text("关于")
      .fontSize(15)
      .fontColor(Color.Black)
      .fontWeight(500)
  }
}