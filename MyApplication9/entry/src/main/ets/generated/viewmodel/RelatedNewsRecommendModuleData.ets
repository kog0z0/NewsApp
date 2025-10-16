import LazyDataSource from '../util/LazyDataSource';

export class Data {
  private static instance: Data;
  lazyDataSource: LazyDataSource<DataSource> = new LazyDataSource();
  static readonly IMAGES: Resource[] = [$r(('app.media.realImageGen_news_2')),$r(('app.media.realImageGen_news_3'))];
  static readonly MAIN_TEXT: string[] = ['新闻阅读', '相关新闻推荐', '同主题新闻'];
  static readonly DESCRIPTION_TEXT: string[] = ['位于页面最底部，显示3-5篇同主题新闻', '采用左图右文布局，图片占比30%'];
  static readonly TAG_TEXTS_LIST: string[][] =
    [['999+万人已读', '都市', '已完结'], ['999+万人已读', '都市', '已完结'],
      ['999+万人已读', '都市', '已完结'], ['999+万人已读', '都市', '已完结'],
      ['999+万人已读', '都市', '已完结'], ['999+万人已读', '都市', '已完结']];
  static readonly TAG_TEXT_COLORS_LIST: Color[][] =
    [[Color.Brown, Color.Green, Color.Gray], [Color.Brown, Color.Green, Color.Gray],
      [Color.Brown, Color.Green, Color.Gray], [Color.Brown, Color.Green, Color.Gray],
      [Color.Brown, Color.Green, Color.Gray], [Color.Brown, Color.Green, Color.Gray]];

  constructor() {
  }

  public static getInstance(): Data {
    if (!Data.instance) {
      Data.instance =
        new Data();
    }
    return Data.instance;
  }

  /**
   * Data loaded on current view converts network data into rendering data
   */
  getResources(): Promise<void> {

    /**
     * use your web request here
     */
    return new Promise((resolve: Function) => {
      const modelList: Array<DataSource> = [];
      for (let index = 0; index < Data.IMAGES.length;
        index++) {
        modelList.push(new DataSource(
          Data.IMAGES[index],
          Data.MAIN_TEXT[index],
          Data.DESCRIPTION_TEXT[index],
          Data.TAG_TEXTS_LIST[index],
          Data.TAG_TEXT_COLORS_LIST[index]));
      }
      this.lazyDataSource.pushArrayData(modelList);
      resolve();
    });
  }
}

export class DataSource {
  private image: Resource;
  private mainText: string;
  private descriptionText: string;
  private tagTextList: string[];
  private tagTextColorList: Color[];

  constructor(image: Resource, mainText: string,
    descriptionText: string, tagTextList: string[], tagTextColorList: Color[]) {
    this.image = image;
    this.mainText = mainText;
    this.descriptionText = descriptionText;
    this.tagTextList = tagTextList;
    this.tagTextColorList = tagTextColorList;
  }

  getImage(): Resource {
    return this.image;
  }

  getMainText(): string {
    return this.mainText;
  }


  getDescriptionText(): string {
    return this.descriptionText;
  }

  getTagTextList(): string[] {
    return this.tagTextList;
  }

  getTagTextColorList(): Color[] {
    return this.tagTextColorList;
  }
}