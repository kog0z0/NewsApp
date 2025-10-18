import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import RdbUtils from '../common/RdbUtils';
import { CommentItemStyle, NewsItemStyle, Title } from '../mode/CommonStyle';
import { NewsBean } from '../mode/NewsBean';
import { CollectBean } from '../mode/CollectBean';

@Entry
@Component
struct MyCollect {

  @State account: string = '';
  @State newsList: Array<NewsBean> = [];
  @State isLoading: boolean = true;
  @State errorMessage: string = '';

  async aboutToAppear() {
    await this.loadCollectData();
  }

  private async loadCollectData() {
    try {
      this.isLoading = true;
      this.errorMessage = '';

      // 检查数据存储是否初始化
      if (!RdbUtils.dataPreferences) {
        this.errorMessage = "数据存储未初始化";
        console.error("dataPreferences is not initialized");
        this.isLoading = false;
        return;
      }

      // 获取账户信息 - 使用 Promise 方式
      const accountResult = await RdbUtils.dataPreferences.get('account', '');
      if (accountResult) {
        this.account = accountResult.toString();
        console.info("当前账户: " + this.account);
      } else {
        this.errorMessage = "未找到用户账户信息";
        console.info("未找到用户账户信息");
        this.isLoading = false;
        return;
      }

      // 查询收藏列表
      console.info("开始查询收藏数据，账户: " + this.account);
      const collectList: Array<CollectBean> = await RdbUtils.queryCollectByAccount(this.account);
      console.info("查询到收藏记录数量: " + collectList.length);

      if (collectList.length === 0) {
        this.newsList = [];
        this.isLoading = false;
        return;
      }

      // 获取所有收藏的新闻详情
      const newsPromises = collectList.map(collectBean =>
      RdbUtils.queryNewsByID(collectBean.nid)
      );

      const newsResults = await Promise.all(newsPromises);
      this.newsList = newsResults.filter(news => news != null);

      console.info("最终新闻列表数量: " + this.newsList.length);

    } catch (error) {
      this.errorMessage = "加载收藏失败: " + error;
      console.error("收藏获取数据失败：" + error);
    } finally {
      this.isLoading = false;
    }
  }


  build() {
    Column() {
      Title({text:'我的收藏'})
      List({ space: 10, initialIndex: 0 }) {
        ForEach(this.newsList, (bean:NewsBean,index:number) => {
          ListItem() {
            NewsItemStyle({
              news_id:bean.id,
              image:bean.image,
              title:bean.title,
              m_desc:bean.mdesc,
              type:bean.type,
              time:bean.time
            })
          }
        }, (item:NewsBean) => item.id.toString())
      }
      .listDirection(Axis.Vertical) // 排列方向
      .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
      .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
      .chainAnimation(false) // 联动特效关闭
      .margin({bottom:60,top:10})
      .onScrollIndex((firstIndex: number, lastIndex: number) => {
        console.info('first' + firstIndex)
        console.info('last' + lastIndex)
      })
    }
  }
}
