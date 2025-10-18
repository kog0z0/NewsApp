import router from '@ohos.router';
import RdbUtils from '../common/RdbUtils';
import { HotItemStyle } from '../mode/CommonStyle';
import { NewsBean } from '../mode/NewsBean';
@Entry
@Component
export struct Hot {
  @State changeValue: string = '';
  @State submitValue: string = '';
  controller: SearchController = new SearchController();
  @Provide  newsList: Array<NewsBean> = new Array<NewsBean>();
  async aboutToAppear(){
    //查询热榜信息
    await RdbUtils.queryByType(9).then((list: Array<NewsBean>) => {
      this.newsList = list;
    }).catch((error:Error) => {
      console.log("热榜获取数据失败：" + error)
    })
  }
  build() {
    Column() {
      //顶部搜索栏开始
      Row() {
        Image($r('app.media.ic_logo'))
          .height(43)
          .width(43)
          .margin({ left: 20 })

        Search({ value: this.changeValue, placeholder: '输入你想搜的', controller: this.controller })
          .searchButton('搜索')
          .width('75%')
          .height(40)
          .backgroundColor("#FFF5A2A2")
          .placeholderColor('#fff3e6e6')
          .placeholderFont({ size: 16, weight: 400 })
          .textFont({ size: 16, weight: 400 })
          .onSubmit((value: string) => {
            this.submitValue = value;
            router.pushUrl({ url: 'pages/SearchPage', params: { data: value } })
          })
          .onChange((value: string) => {
            this.changeValue = value;
          })
          .margin(0)
      }
      .width('100%')
      .height(50)
      .backgroundColor($r('app.color.home_title_background'))
      //顶部搜索栏结束
      //热榜列表开始
      List({ space: 10, initialIndex: 0 }) {
        ForEach(this.newsList, (bean:NewsBean,index:number) => {
          ListItem() {
            HotItemStyle({
              news_id:bean.id,
              image:bean.image,
              title:bean.title,
              m_desc:bean.mdesc,
              type:bean.type,
              time:bean.time,
              index:index
            })
          }
        }, (item:NewsBean) => item.id.toString())
      }
      .listDirection(Axis.Vertical) // 排列方向
      .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
      .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
      .chainAnimation(false) // 联动特效关闭
      .margin({top:0})
      .onScrollIndex((firstIndex: number, lastIndex: number) => {
        console.info('first' + firstIndex)
        console.info('last' + lastIndex)
      })
      //热榜列表结束
    }.alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }
}