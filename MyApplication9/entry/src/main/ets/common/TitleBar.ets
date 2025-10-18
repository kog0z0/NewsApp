

@Component
export default struct TitleBar {
  private title: Resource = $r('app.string.EntryAbility_label')

  build() {
    Row() {
      Text(this.title)
        .fontColor(Color.White)
        .fontSize(28)
    }
    .width('100%')
    .height('8%')
    .constraintSize({ minHeight: 70 })
    .padding({ left: 10, right: 10 })
    .backgroundColor('#0D9FFB')
  }
}