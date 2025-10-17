import LazyDataSource from '../util/LazyDataSource';

export class DataSource {
  private static instance: DataSource;
  lazyDataSource: LazyDataSource<DataSourceStyleAStyleA> = new LazyDataSource();
  static readonly IMAGES: Resource[] = [$r('app.media.background'),$r('app.media.background')];
  static readonly TITLES: string[] = ['新闻阅读', '操作按钮'];
  static readonly CONTENTS: string[] = ['底部操作按钮模块，包含‘完成’和‘恢复默认’两个按钮', '用于保存修改或重置频道列表'];
  static readonly PAGES: string[] = ['EmptyPagePathStack', 'EmptyPagePathStack'];

  constructor() {
  }

  public static getInstance(): DataSource {
    if (!DataSource.instance) {
      DataSource.instance =
        new DataSource();
    }
    return DataSource.instance;
  }

  getResources(): Promise<void> {

    return new Promise((resolve: Function) => {
      const modelList: Array<DataSourceStyleAStyleA> = [];
      for (let index = 0; index < DataSource.IMAGES.length;
        index++) {
        modelList.push(new DataSourceStyleAStyleA(
          DataSource.IMAGES[index],
          DataSource.TITLES[index],
          DataSource.CONTENTS[index],
          DataSource.PAGES[index])
          );
      }
      this.lazyDataSource.pushArrayData(modelList);
      resolve();
    });
  }
}

export class DataSourceStyleAStyleA {
  private image: Resource;
  private title: string;
  private content: string;
  private page: string;

  constructor(image: Resource, title: string, content: string, page: string) {
    this.image = image;
    this.title = title;
    this.content = content;
    this.page = page;
  }

  getImage(): Resource {
    return this.image;
  }

  getTitle(): string {
    return this.title;
  }

  getContent(): string {
    return this.content;
  }

  getPage(): string {
    return this.page;
  }
}