import { router } from '@kit.ArkUI';
@Component
export struct SearchInputModule {
  @State search_placeholder: string = "搜索新闻"
  @State buttonText: string = '搜索'
  @State searchText: string = '';
  @State translateY: number = 0;
  @State transitionEffect: TransitionEffect = TransitionEffect.IDENTITY;
  @Consume('appPathStack') appPathStack: NavPathStack;

  build() {
    Column() {
      Search({ placeholder: this.search_placeholder, value: this.searchText })
        .searchButton(this.buttonText)
        .width("92%")
        .enableKeyboardOnFocus(false)
        .placeholderColor($r('sys.color.font_secondary'))
        .placeholderFont({
          family: "HarmonyHeiTi",
          size: $r('sys.float.ohos_id_text_size_body1'),
          weight: 100
        })
        .borderColor($r('sys.color.font_primary'))
        .searchIcon({ src: $r('sys.symbol.search_things') })
        .fontColor($r('sys.color.font_primary'))
        .onClick(() => {
          router.pushUrl({
            url: 'pages/SearchPage',
            params: {
              fromPage: 'HomePage'
            }
          });
        })
        .onSubmit((value: string) => {
          router.pushUrl({
            url: 'pages/SearchPage',
            params: {
              keyword: value,
              fromPage: 'HomePage'
            }
          });
        })
    }
  }
}
