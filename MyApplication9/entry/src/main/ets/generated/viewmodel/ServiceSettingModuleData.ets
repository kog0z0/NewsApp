import LazyDataSource from '../util/LazyDataSource';

export class Data {
  private static instance: Data;
  lazyDataSource: LazyDataSource<DataSource> = new LazyDataSource();
    static readonly ICONS: Resource[] = [$r('app.media.lib_icon_91'),$r('app.media.lib_icon_176'),$r('app.media.lib_icon_38'),$r('app.media.lib_icon_140')];
  static readonly TITLES: string[] = ['用户反馈', '系统设置', '清除缓存', '关于我们'];


  static readonly ROUTEICONS: Resource[] = [$r('app.media.ic_public_arrow_right'),$r('app.media.ic_public_arrow_right'),
$r('app.media.ic_public_arrow_right'),$r('app.media.ic_public_arrow_right')];

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
      for (let index = 0; index < Data.ICONS.length;
        index++) {
        modelList.push(new DataSource(
          Data.ICONS[index],
          Data.TITLES[index],
          Data.ROUTEICONS[index]));
      }
      this.lazyDataSource.pushArrayData(modelList);
      resolve();
    });
  }
}

export class DataSource {
  private icon: Resource;
  private title: string;
  private routeIcon: Resource;

  constructor(icon: Resource, title: string, routeIcon: Resource) {
    this.icon = icon;
    this.title = title;
    this.routeIcon = routeIcon;
  }

  getIcon(): Resource {
    return this.icon;
  }

  getTitle(): string {
    return this.title;
  }

  getRouteIcon(): Resource {
    return this.routeIcon;
  }
}