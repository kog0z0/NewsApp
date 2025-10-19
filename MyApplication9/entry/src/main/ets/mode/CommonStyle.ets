import router from '@ohos.router';
import RdbUtils from '../common/RdbUtils';
import { NewsBean } from './NewsBean';
@Component
export struct NewsItemStyle {
  news_id:number = 0;
  image:string = '';
  title: string = '';
  m_desc: string = '';
  type: number = 0;
  time: string = '';

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Image($rawfile(this.image)).width('90').height('90').margin({ left: '20px', right: "20px" }).borderRadius('10')
        Column() {
          Text(this.title).fontSize('12fp').width('620px').fontColor("#ff2d2a2d").maxLines(4)
        }.alignItems(HorizontalAlign.Start).flexGrow(1)
        Text(this.time).fontSize('12fp')
          .margin({ right: "50px" }).fontColor("#c2bec2")
      }
      .height('90')
      .width('100%')
      Row() {
        Text().width('190px').height('3px')
        Divider()
          .vertical(false)
          .color($r('app.color.items_background'))
          .strokeWidth('3px')
      }
      .height('3px')
      .width('100%')
    }.onClick(() => {
      router.pushUrl({url:'pages/NewsDetail',params:{data:new NewsBean(this.news_id,this.image,this.title,this.m_desc,this.type,this.time)}})
    })
  }
}

@Component
export struct CommentItemStyle {
  cid:number = 0;
  head:string = '';
  m_desc: string = '';
  username: string = '';
  nid:number = 0;
  time: string = '';

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
        Image($rawfile(this.head)).width('32').height('32').margin({ left:20, right: "20px" }).borderRadius('10')
        Column() {
          Text(this.username)
            .fontSize('15fp')
            .fontWeight(500)
          Text(this.m_desc)
            .fontSize('12fp')
            .width('620px')
            .margin({top:10})
            .fontColor("#ff2d2a2d")
            .maxLines(4)
          Text(this.time)
            .fontSize('12fp')
            .margin({ top: 10,bottom:10 })
            .fontColor("#c2bec2")
        }.alignItems(HorizontalAlign.Start).flexGrow(1)

      }
      .width('100%')
      Row() {
        Divider()
          .vertical(false)
          .color($r('app.color.items_background'))
          .strokeWidth('3px')
      }
      .height('3px')
      .width('100%')
      .margin({left:94})
    }
  }
}

@Component
export struct MyCommentItemStyle {
  cid:number = 0;
  head:string = '';
  m_desc: string = '';
  username: string = '';
  nid:number = 0;
  time: string = '';
  img:string = '';

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {
        Image($rawfile(this.head)).width('32').height('32').margin({ left:20, right: "20px" }).borderRadius('10')
        Column() {
          Text(this.username)
            .fontSize('15fp')
            .fontWeight(500)
          Text(this.m_desc)
            .fontSize('12fp')
            .width('620px')
            .margin({top:10})
            .fontColor("#ff2d2a2d")
            .maxLines(4)
          Text(this.time)
            .fontSize('12fp')
            .margin({ top: 10,bottom:10 })
            .fontColor("#c2bec2")

        }.alignItems(HorizontalAlign.Start).flexGrow(1)
        Image($rawfile(this.img)).width('90').height('90').margin({ left:20, right: "20px" }).borderRadius('10')
      }.width('100%')
      Row() {
        Divider()
          .vertical(false)
          .color($r('app.color.items_background'))
          .strokeWidth('3px')
      }
      .height('3px')
      .width('100%')
      .margin({left:94})
    }.onClick(() => {
      RdbUtils.queryNewsByID(this.nid).then((bean:NewsBean) =>{
        router.pushUrl({url:'pages/NewsDetail',params:{data:bean}})
      })
    })
  }
}

@Component
export struct HotItemStyle {
  news_id:number = 0;
  image:string = '';
  title: string = '';
  m_desc: string = '';
  type: number = 0;
  time: string = '';
  index:number = 0

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        if(this.index === 0)
        {
          Image($r('app.media.ic_hot_top')).width('24').height('24').margin({ left: '20px', right: "20px" })
        }
        if(this.index === 1)
        {
          Image($r('app.media.ic_hot_top1')).width('24').height('24').margin({ left: '20px', right: "20px" })
        }
        if(this.index === 2)
        {
          Image($r('app.media.ic_hot_top2')).width('24').height('24').margin({ left: '20px', right: "20px" })
        }
        if(this.index === 3)
        {
          Image($r('app.media.ic_hot_top3')).width('24').height('24').margin({ left: '20px', right: "20px" })
        }
        Column() {
          if(this.index > 3)
          {
            Text('  '+this.index+'  '+this.title).fontSize('12fp').width('820px').fontColor("#ff2d2a2d").maxLines(1)
          }else{
            Text(this.title).fontSize('12fp').width('820px').fontColor("#ff2d2a2d").maxLines(1)
          }
        }.alignItems(HorizontalAlign.Start).flexGrow(1)

      }
      .height('40')
      .width('100%')
      .borderRadius(10)
      .backgroundColor(this.index > 3 ?$r('app.color.items_background_nor'):$r('app.color.items_background_hot'))

    }

    .margin({left:15,right:15})
    .onClick(() => {
      router.pushUrl({url:'pages/NewsDetail',params:{data:new NewsBean(this.news_id,this.image,this.title,this.m_desc,this.type,this.time)}})
    })
  }
}

@Component
export struct Title {
  private text: string = '';

  build() {
      Row(){
        Image($r('app.media.ic_back'))
          .width('32')
          .height('32')
          .onClick(() => {
            router.back();
          })
        Text(this.text).fontSize('18fp').padding('20px').width('85%').textAlign(TextAlign.Center).margin({right:32}).height('100%')
      }.height(60)
      .backgroundColor($r('app.color.newsdetail_title_bg'))
    }
}

