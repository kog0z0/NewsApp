import { EmptyPagePathStack } from './view/EmptyPagePathStack';
import { SecondPageSearch } from './view/SecondPageSearch';
import { BreakpointConstants } from './common/BreakpointConstants';
import { CommonConstants } from './common/CommonConstants';
import { HomePage } from './pages/HomePage';
import { MyCollectionPage } from './pages/MyCollectionPage';
import { SearchPage } from './pages/SearchPage';
import { PersonalCenterPage } from './pages/PersonalCenterPage';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();
  @Provide('appPathStack') appPathStack: NavPathStack = new NavPathStack();
  @StorageLink('currentWidthBreakpoint') currentWidthBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;

  @Builder
	PageMap(name: string) {
		if (name === 'SearchPage') {
			SecondPageSearch()
		} else {
			EmptyPagePathStack()
		}
	}

  @Builder
  tabBuilder(title: string, targetIndex: number, icon: Resource) {
    Column() {
      Image(icon)
        .width("24vp")
        .height("24vp")
        .objectFit(ImageFit.Contain)
        .fillColor(this.currentIndex === targetIndex ? ($r('app.color.app_icon_pressed_color')) : ($r('app.color.app_icon_color')))
      Text(title)
        .fontSize("10vp")
        .fontColor(this.currentIndex === targetIndex ? ($r('app.color.app_icon_pressed_color')) : ($r('app.color.app_icon_color')))
        .textAlign(TextAlign.Center)
        .lineHeight("14vp")
        .fontWeight(500)
    }
    .height(this.currentWidthBreakpoint === BreakpointConstants.BREAKPOINT_LG ? "100vp" : CommonConstants.FULL_PERCENT)
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(targetIndex);
    })
  }

  build() {
    Navigation(this.appPathStack) {
        Tabs({
          barPosition: this.currentWidthBreakpoint === BreakpointConstants.BREAKPOINT_LG ? BarPosition.Start : BarPosition.End,
          controller: this.tabsController
        }) {
          TabContent() {
          HomePage()
        }.tabBar(this.tabBuilder('首页', 0, $r("app.media.lib_icon_186")))
      TabContent() {
          MyCollectionPage()
        }.tabBar(this.tabBuilder('我的收藏', 1, $r("app.media.lib_icon_53")))
      TabContent() {
          SearchPage()
        }.tabBar(this.tabBuilder('搜索', 2, $r("app.media.lib_icon_103")))
      TabContent() {
          PersonalCenterPage()
        }.tabBar(this.tabBuilder('个人中心', 3, $r("app.media.lib_icon_8")))
        }
        .barWidth(this.currentWidthBreakpoint === BreakpointConstants.BREAKPOINT_LG ? "96vp" : CommonConstants.FULL_PERCENT)
        .barHeight(this.currentWidthBreakpoint === BreakpointConstants.BREAKPOINT_LG ? CommonConstants.FULL_PERCENT : "76vp")
        .barMode(this.currentWidthBreakpoint === BreakpointConstants.BREAKPOINT_LG ? BarMode.Scrollable : BarMode.Fixed, { nonScrollableLayoutStyle: LayoutStyle.ALWAYS_CENTER })
        .vertical(this.currentWidthBreakpoint === BreakpointConstants.BREAKPOINT_LG)
        .scrollable(false)
        .width('100%')
        .height('100%')
    }
    .backgroundColor($r('app.color.page_bg_color'))
    .navDestination(this.PageMap)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}