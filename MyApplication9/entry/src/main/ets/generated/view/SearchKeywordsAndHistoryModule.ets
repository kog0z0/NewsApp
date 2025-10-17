// import { Data, DataSource } from '../viewmodel/SearchKeywordsAndHistoryModuleData';
// import { LoadingStatus } from '../common/CommonEnums';
// import { LoadingFailedView } from '../view/LoadingFailedView';
//
// import { BreakpointConstants } from '../common/BreakpointConstants';
// import { BreakpointType } from '../util/BreakpointType';
// import LazyDataSource from '../util/LazyDataSource';
// import { CommonConstants } from '../common/CommonConstants';
// import { ModuleTitleComponent } from '../common/ModuleTitleComponent'
//
// @Component
// export struct SearchKeywordsAndHistoryModule {
//   @State itemModel: Data =
//     Data.getInstance();
//   @Prop listDirection: Axis = Axis.Horizontal
//   @State moduleTitle: string = "新闻阅读";
//   @State moduleRedirectContent: string = "查看更多";
//   @State loadingStatus: LoadingStatus = LoadingStatus.OFF;
//   @State lazyDataSource: LazyDataSource<DataSource> =
//     this.itemModel.lazyDataSource;
//   private spaceArray: string[] = ['12vp', '16vp', '20vp'];
//   @Consume('appPathStack') appPathStack: NavPathStack;
//   @StorageLink('currentWidthBreakpoint') currentWidthBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
//
//   jump(): void {
//     this.appPathStack.pushPathByName('EmptyPagePathStack', null);
//
//   }
//
//   aboutToAppear() {
//     this.loadResources();
//
//   }
//
//   loadResources(): void {
//     this.loadingStatus = LoadingStatus.LOADING;
//     this.itemModel.getResources().then(() => {
//       this.loadingStatus = LoadingStatus.SUCCESS;
//     }).catch(() => {
//       this.loadingStatus = LoadingStatus.FAILED;
//     });
//   }
//
//   build() {
//     Column() {
//       ModuleTitleComponent({ title: this.moduleTitle, moduleRedirectContent: this.moduleRedirectContent })
//         .width('92%')
//
//       if (this.loadingStatus === LoadingStatus.FAILED) {
//         LoadingFailedView(() => this.loadResources())
//       }
//       if (this.loadingStatus === LoadingStatus.SUCCESS) {
//         List({
//           space: new BreakpointType(this.spaceArray[0], this.spaceArray[1],
//             this.spaceArray[2]).getValue(this.currentWidthBreakpoint)
//         }) {
//           LazyForEach(this.lazyDataSource, (item: DataSource) => {
//             ListItem() {
//               PureTextItem({
//                 content: item.getContent()
//               })
//             }
//             .width('100vp')
//             .height('35vp')
//             .onClick(() => {
//               this.jump()
//             })
//           }, (item: DataSource, index: number) => index + JSON.stringify(item))
//         }
//         .width('92%')
//         .height('auto')
//         .listDirection(this.listDirection)
//         .scrollBar(BarState.Off)
//       }
//     }
//     .width('100%')
//     .alignItems(HorizontalAlign.Center)
//     .margin({bottom: 10})
//   }
// }
//
// @Component
// export struct PureTextItem {
//   @State content: string = '模块名';
//   @State isClicked: boolean = false;
//
//   build() {
//     Column() {
//       /**
//        * TODO:
//        * please modify it according to the actual situation.
//        * directly modify {@link Data#CONTENTS}
//        * or refactor method {@code getResources()} to implement your custom code logic.
//        * @see Data#getResources()
//        */
//       Text(this.content)
//         .fontColor(this.isClicked ? Color.White : Color.Gray)
//         .fontWeight(FontWeight.Medium)
//         .fontSize("14fp")
//         .textOverflow({ overflow: TextOverflow.Ellipsis })
//         .maxLines(1)
//     }
//     .width(CommonConstants.FULL_PERCENT)
//     .height(CommonConstants.FULL_PERCENT)
//     .borderRadius($r('sys.float.corner_radius_level8'))
//     .alignItems(HorizontalAlign.Center)
//     .justifyContent(FlexAlign.Center)
//     .backgroundColor(this.isClicked ? $r('app.color.interactive_active') : $r('app.color.comp_background_primary'))
//     .onClick(() => {
//       this.isClicked = this.isClicked ? false : true;
//     })
//   }
// }