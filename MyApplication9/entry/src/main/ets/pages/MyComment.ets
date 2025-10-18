import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import RdbUtils from '../common/RdbUtils';
import { CommentItemStyle, MyCommentItemStyle, NewsItemStyle, Title } from '../mode/CommonStyle';
import { NewsBean } from '../mode/NewsBean';
import { CollectBean } from '../mode/CollectBean';
import { Comment } from '../mode/Comment';
import { CommentItem } from '../mode/CommentItem';

@Entry
@Component
struct MyComment {

  @State account: string = '';
  @State itemList: Array<CommentItem> = [];
  @State isLoading: boolean = true;
  @State errorMessage: string = '';

  async aboutToAppear() {
    await this.loadComments();
  }

  private async loadComments() {
    try {
      this.isLoading = true;
      this.errorMessage = '';

      // 获取账户信息
      if (!RdbUtils.dataPreferences) {
        this.errorMessage = "数据存储未初始化";
        console.error("dataPreferences is not initialized");
        this.isLoading = false;
        return;
      }

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

      // 查询评论列表
      console.info("开始查询评论数据，账户: " + this.account);
      const list = await RdbUtils.queryCommentByAccount(this.account);
      console.info("查询到评论数量: " + list.length);
      this.itemList = list;

    } catch (error) {
      this.errorMessage = "加载评论失败: " + error;
      console.error("评论获取数据失败：" + error);
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      Title({text: '我的评论'})

      if (this.isLoading) {
        // 加载中状态
        Column() {

          Text('加载中...')
            .margin({ top: 10 })
            .fontSize(16)
        }
        .width('100%')
        .height(200)
        .justifyContent(FlexAlign.Center)
      } else if (this.errorMessage) {
        // 错误状态
        Column() {
          Text(this.errorMessage)
            .margin({ top: 10 })
            .fontSize(16)
            .textAlign(TextAlign.Center)
          Button('重试')
            .margin({ top: 20 })
            .onClick(() => {
              this.loadComments();
            })
        }
        .width('100%')
        .height(300)
        .justifyContent(FlexAlign.Center)
      } else {
        // 正常显示评论列表
        List({ space: 10, initialIndex: 0 }) {
          ForEach(this.itemList, (bean: CommentItem, index: number) => {
            ListItem() {
              MyCommentItemStyle({
                cid: bean.id,
                head: bean.head,
                username: bean.username,
                m_desc: bean.mdesc,
                nid: bean.nid,
                time: bean.time,
                img: bean.img
              })
            }
          }, (item: CommentItem) => item.id.toString())
        }
        .listDirection(Axis.Vertical)
        .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 })
        .edgeEffect(EdgeEffect.None)
        .chainAnimation(false)
        .margin({ bottom: 60, top: 10 })
        .onScrollIndex((firstIndex: number, lastIndex: number) => {
          console.info('first: ' + firstIndex + ', last: ' + lastIndex)
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}