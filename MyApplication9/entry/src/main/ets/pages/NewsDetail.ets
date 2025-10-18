import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import RdbUtils from '../common/RdbUtils';
import { Comment } from '../mode/Comment';
import { CommentItemStyle, Title } from '../mode/CommonStyle';
import { NewsBean } from '../mode/NewsBean';
import { CollectBean } from '../mode/CollectBean';

interface RouterParams{
  data?: NewsBean;
}

@Entry
@Component
struct NewsDetail {
  // 通过router接收上一个页面传递的参数
  @State bean: NewsBean = this.getRouterData();
  private scroller: Scroller = new Scroller()
  @Provide account: string = '';
  @State login:boolean = false;
  @State isCollect:boolean = false;
  @State content: string = '';//评论内容
  @Provide  commentList: Array<Comment> = new Array<Comment>();
  private getRouterData(): NewsBean {
    try {
      const params = router.getParams() as RouterParams;
      if (params.data) {
        return params.data;
      }
    } catch (error) {
      console.error('Failed to get router params: ' + error);
    }
    return {
      id: 0,
      title: '',
      time: '',
      mdesc: '',
      image: '',
      type: 0
    } as NewsBean;
  }
  async aboutToAppear() {
    try {
      let that = this;
      if (!RdbUtils.dataPreferences) {
        console.error("dataPreferences is not initialized");
        return;
      }
      await RdbUtils.dataPreferences.get('account', '', (err, val) => {
        if (err) {
          console.error("Failed to get value of 'account'. code =" + err.code + ", message =" + err.message);
          return;
        }
        console.info("Succeeded in getting value of 'account'. val： " + val);
        if (val) {
          that.account = val.toString();
          that.login = true;
        }
      })
      //查询评论列表
      await RdbUtils.queryCommentByNewsID(this.bean.id).then((list: Array<Comment>) => {
        this.commentList = list;
      }).catch((error:Error) => {
        console.log("评论获取数据失败：" + error)
      })
      //查看是否被收藏
      await RdbUtils.checkCollect(this.account,this.bean.id).then((list: Array<CollectBean>) => {
        if(list.length > 0)
        {
          this.isCollect = true
        }
      }).catch((error:Error) => {
        console.log("收藏获取数据失败：" + error)
      })
    } catch (err) {
      console.error("Failed to get value of 'account'. code =" + err.code + ", message =" + err.message);
    }
  }
  build() {
    Column() {
      Title({text:'新闻详细'})
        Scroll(this.scroller) {
          Flex({ direction: FlexDirection.Column }) {
            Text(this.bean.title)
              .fontSize(25)
              .fontWeight(FontWeight.Bold)
              .margin({ left: 20,right:10,top:10})
            Row(){
              Text(this.bean.time + ".澎湃新闻")
                .fontSize(15)
                .padding(20)
                .width('80%')
                .textAlign(TextAlign.Start)
              Image(this.isCollect ? $r('app.media.ic_sc_y') : $r('app.media.ic_sc_n'))
                .width('32')
                .height('32')
                .margin({left:20})
                .onClick(() => {
                  if(!this.login) {
                    promptAction.showToast({
                      message: "请先登录",
                      duration: 3000
                    })
                    return
                  }

                  //如果已经收藏再点击则取消收藏
                  if(this.isCollect) {
                    RdbUtils.deleteCollect(this.account, this.bean.id).then((updateNumber) => {
                      this.isCollect = false
                      promptAction.showToast({
                        message: "取消成功",
                        duration: 3000
                      })
                    }).catch((error:Error) => {
                      console.error('取消收藏失败:', error)
                    })
                  } else {
                    //如果未收藏点击则收藏
                    RdbUtils.insertOne("COLLECT", {
                      username: this.account,
                      nid: this.bean.id,
                      time: '2024-06-22 23:12'
                    }).then((updateNumber) => {
                      this.isCollect = true
                      promptAction.showToast({
                        message: "收藏成功",
                        duration: 3000
                      })
                    }).catch((error:Error) => {
                      console.error('收藏失败:', error)
                    })
                  }
                })
            }.width('100%')
            Text(this.bean.mdesc)
              .fontSize(20)
              .margin({ left: 20,right:10,top:10})
            Text('评论 '+this.commentList.length)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .padding(20)
              .width('100%')
              .textAlign(TextAlign.Start)
            Row(){
              Image($r('app.media.ic_user_head'))
                .width('32')
                .height('32')
                .margin({left:20})
              Text("请先登录再发表评论")
                .fontSize(15)
                .height(50)
                .width('75%')
                .backgroundColor($r('app.color.newsdetail_nologin_bg'))
                .borderRadius(10)
                .textAlign(TextAlign.Center)
                .margin({left:20,right:20}).visibility(this.login? Visibility.None : Visibility.Visible)
              TextInput({
                placeholder: '请输入评论内容'
                })
                .fontSize(15)
                .height(50)
                .width('60%')
                .backgroundColor($r('app.color.newsdetail_nologin_bg'))
                .borderRadius(10)
                .textAlign(TextAlign.Center)
                .onChange((val: string) => this.content = val)
                .margin({left:20,right:20})
                .visibility(!this.login? Visibility.None : Visibility.Visible)
              Button('发表', { type: ButtonType.Capsule, stateEffect: true })
                .backgroundColor('#fff32828')
                .width(65)
                .visibility(!this.login? Visibility.None : Visibility.Visible)
                .onClick(() =>{
                  const now = new Date();
                  const year = now.getFullYear();
                  const month = String(now.getMonth() + 1).padStart(2, '0'); // 月份从0开始，所以要+1
                  const day = String(now.getDate()).padStart(2, '0');
                  const hours = String(now.getHours()).padStart(2, '0');
                  const minutes = String(now.getMinutes()).padStart(2, '0');
                  const currentTime = `${year}-${month}-${day} ${hours}:${minutes}`;
                RdbUtils.insertOne("COMMENT",{
                  username:this.account,
                  mdesc:this.content,
                  head:'ic_default_head.png',
                  nid:this.bean.id,
                  time: currentTime
                }) .then((updateNumber) => {
                  promptAction.showToast({
                    message: "评论成功",
                    duration: 3000
                  })
                  //评论成功再查表
                  RdbUtils.queryCommentByNewsID(this.bean.id).then((list: Array<Comment>) => {
                    this.commentList = list;
                  }).catch((error:Error) => {
                    console.log("评论获取数据失败：" + error)
                  })
                }).catch((error:Error) => {
                  console.log('评论数据插入失败:' + error)
                  promptAction.showToast({
                    message: "评论失败",
                    duration: 3000
                  })
                })
              })
            }.width('100%')
            .height(100)
            List({ space: 10, initialIndex: 0 }) {
              ForEach(this.commentList, (bean:Comment,index:number) => {
                ListItem() {
                  CommentItemStyle({
                    cid:bean.id,
                    head:bean.head,
                    m_desc:bean.mdesc,
                    username:bean.username,
                    nid:bean.nid,
                    time:bean.time
                  })
                }
              }, (bean: NewsBean) => bean.id.toString())
            }
            .listDirection(Axis.Vertical) // 排列方向
            .divider({ strokeWidth: 2, color: 0xFFFFFF, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
            .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
            .chainAnimation(false) // 联动特效关闭
            .onScrollIndex((firstIndex: number, lastIndex: number) => {
              console.info('first' + firstIndex)
              console.info('last' + lastIndex)
            })
          }
        }
        .scrollBar(BarState.Off)
        .scrollable(ScrollDirection.Vertical)
        ScrollBar({ scroller: this.scroller, direction: ScrollBarDirection.Vertical,state: BarState.Auto }) {
          Text()
            .width(1)
            .height(100)
            .borderRadius(10)
            .backgroundColor('#C0C0C0')
        }.width(30).backgroundColor('#ededed')
    }
  }
}
