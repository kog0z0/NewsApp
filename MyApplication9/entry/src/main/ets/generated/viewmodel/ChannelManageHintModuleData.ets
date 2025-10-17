
import LazyDataSource from '../util/LazyDataSource';

export class Data {
  private static instance: Data;
  lazyDataSource: LazyDataSource<DataSource> = new LazyDataSource();
    static readonly IMAGES: Resource[] = [$r(('app.media.realImageGen_news_4'))];
  static readonly MAIN_TEXT: string[] = ['新闻阅读'];
  static readonly SUB_TEXT: string[] = ['频道管理'];
  static readonly DESCRIPTION_TEXT: string[] = ['拖动可排序，点击可删除'];

  constructor() {
  }

  public static getInstance(): Data {
    if (!Data.instance) {
      Data.instance =
        new Data();
    }
    return Data.instance;
  }

  getResources(): Promise<void> {

    return new Promise((resolve: Function) => {
      const modelList: Array<DataSource> = [];
      for (let index = 0; index < Data.IMAGES.length;
        index++) {
        modelList.push(new DataSource(
                    Data.IMAGES[index],
          Data.MAIN_TEXT[index],
          Data.SUB_TEXT[index],
          Data.DESCRIPTION_TEXT[index]));
      }
      this.lazyDataSource.pushArrayData(modelList);
      resolve();
    });
  }
}

export class DataSource {
  private image: Resource;
  private mainText: string;
  private subText: string;
  private descriptionText: string;

  constructor(image: Resource, mainText: string, subText: string, descriptionText: string) {
    this.image = image;
    this.mainText = mainText;
    this.subText = subText;
    this.descriptionText = descriptionText;
  }

  getImage(): Resource {
    return this.image;
  }

  getMainText(): string {
    return this.mainText;
  }

  getSubText(): string {
    return this.subText;
  }

  getDescriptionText(): string {
    return this.descriptionText;
  }
}