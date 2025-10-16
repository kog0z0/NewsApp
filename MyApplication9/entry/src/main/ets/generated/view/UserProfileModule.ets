@Component
export struct UserProfileModule {
  @State userName: string = "新闻阅读用户";
  @State userIcon: Resource = $r('app.media.user_photo');
  @State subtitle: string[] = ['粉丝', '关注'];
  @State counts: string[] = ['1000', '500'];

  build() {
      Row() {
        Image(this.userIcon).width("20%").objectFit(ImageFit.Cover)
          .margin({left: 4, right: 16})
        Column() {
          Text(this.userName).fontSize(18).fontWeight(FontWeight.Bold)
          .height("50%")
          .width("80%")
          Row() {
            ForEach(this.subtitle, (title: string, index: number) => {
              Row() {
                Text(title).fontColor('#D3D3D3')
                Text(this.counts[index]).fontSize(16).fontWeight(FontWeight.Medium).margin({ left: 6 })
              }
            })
          }.height("50%").width('80%').alignItems(VerticalAlign.Center).justifyContent(FlexAlign.SpaceBetween)
        }.width("80%").alignItems(HorizontalAlign.Start)
      }
      .width('92%')
      .height(80)
      .margin({bottom: 8})
      .backgroundColor(Color.White)
      .borderRadius(20)
  }
}
        