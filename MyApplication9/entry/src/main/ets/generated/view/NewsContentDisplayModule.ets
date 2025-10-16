import { DataSource, DataSourceStyleAStyleA, DataSourceStyleBStyleB, DataSourceStyleCStyleC } from '../viewmodel/NewsContentDisplayModuleData';

@Component
struct RankNumber {
  @Prop rank: number;

  build() {
    Text(this.rank.toString())
      .fontSize(18)
      .fontWeight(FontWeight.Bold)
      .fontColor(this.getColorByRank())
  }

  private getColorByRank(): string {
    switch(this.rank) {
      case 1: return '#FF4500';
      case 2: return '#FF8C00';
      case 3: return '#FFA500';
      default: return '#999999';
    }
  }
}

@Component
struct NewsImage {
  @Prop mediaType: DataSourceStyleCStyleC;
  @Prop cover: Resource;

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Image(this.cover)
        .width(100)
        .height(70)
        .borderRadius(4)
        .objectFit(ImageFit.Cover)

      if (this.mediaType === DataSourceStyleCStyleC.VIDEO) {
        Stack({ alignContent: Alignment.Center }){
          Circle()
            .width(32)
            .height(32)
            .fill('#33000000')

          Image($r('app.media.play'))
            .width(20)
            .height(20)
        }
      }
    }
    .width(100)
    .height(70)
  }
}

@Component
struct HotCommentTag {
  @Prop comment: DataSourceStyleBStyleB;

  build() {
    Row() {
      Text('热评')
        .fontSize(12)
        .fontColor('#ffff8100')
        .backgroundColor('#ffffd3a8')
        .borderRadius(4)
        .padding({ left: 6, right: 6, top: 2, bottom: 2 })

      Text(`${this.comment.getUser()}: ${this.comment.getContent()}`)
        .fontSize(12)
        .fontColor('#666666')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ left: 8 })
        .width('86%')
    }
    .width('100%')
    .padding(4)
    .borderRadius(8)
    .backgroundColor(Color.White)
  }
}

@Component
struct NewsCard {
  @Prop news: DataSourceStyleAStyleA;
  @Consume('appPathStack') appPathStack: NavPathStack;

  jump(): void {
    this.appPathStack.pushPathByName('EmptyPagePathStack', null);
  }

  build() {
    Column() {
      Row() {
        RankNumber({ rank: this.news.getRank() })
          .margin({ right: 10 })

        Column() {
          Text(this.news.getTitle())
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width('100%')
            .margin({bottom:8})

          Row() {
            Image($r('app.media.ic_public_comments'))
              .width(14)
              .height(14)
              .margin({ right: 4 })

            Text(this.news.getCommentCountText())
              .fontSize(12)
              .fontColor('#999999')

            Text(this.news.getSource())
              .fontSize(12)
              .fontColor('#999999')
              .margin({ left: 8 })
          }
          .margin({ top: 8 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)

        NewsImage({ mediaType: this.news.getMediaType(), cover: this.news.getCover() })
          .margin({ left: 10 })
      }
      .width('100%')
      .padding({ top: 16, bottom: 16 })
      .alignItems(VerticalAlign.Top)

      if (this.news.hasHotComment() && this.news.getHotComment()) {
        HotCommentTag({ comment: this.news.getHotComment()! })
          .margin({ left:16,bottom: 16 })
      }

      Divider()
        .strokeWidth(0.5)
        .color('#EEEEEE')
    }
    .width('100%')
    .padding({ left: 16, right: 16 })
    .onClick(() => {
      this.jump()
    })
  }
}

@Component
export struct NewsContentDisplayModule {
  @State model: DataSource = new DataSource();
  @Consume('appPathStack') appPathStack: NavPathStack;

  jump(): void {
    this.appPathStack.pushPathByName('EmptyPagePathStack', null);
  }

  build() {
    Column() {
      List() {
        ForEach(this.model.getNewsList(), (newsItem: DataSourceStyleAStyleA) => {
          ListItem() {
            NewsCard({ news: newsItem })
          }

        }, (newsItem: DataSourceStyleAStyleA) => newsItem.getId())
      }
      .width('100%')
      .divider({ strokeWidth: 0 })
    }
    .width('100%')
    .backgroundColor($r('app.color.page_bg_color'))
  }
}
