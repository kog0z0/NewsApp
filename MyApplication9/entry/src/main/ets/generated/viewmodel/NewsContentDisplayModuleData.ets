export enum DataSourceStyleCStyleC { NORMAL = 'normal', VIDEO = 'video'}

export class DataSourceStyleBStyleB {
  private id: string;
  private user: string;
  private content: string;

  constructor(id: string, user: string, content: string) {
    this.id = id;
    this.user = user;
    this.content = content;
  }

  getId(): string {
    return this.id;
  }

  getUser(): string {
    return this.user;
  }

  getContent(): string {
    return this.content;
  }
}

export class DataSourceStyleAStyleA {
  private id: string;
  private rank: number;
  private title: string;
  private source: string;
  private commentCount: number;
  private cover: Resource;
  private mediaType: DataSourceStyleCStyleC;
  private hotComment: DataSourceStyleBStyleB | null;

  constructor(id: string, rank: number, title: string, source: string, commentCount: number, cover: Resource,
    mediaType: DataSourceStyleCStyleC, hotComment: DataSourceStyleBStyleB | null) {
    this.id = id;
    this.rank = rank;
    this.title = title;
    this.source = source;
    this.commentCount = commentCount;
    this.cover = cover;
    this.mediaType = mediaType;
    this.hotComment = hotComment;
  }

  getId(): string {
    return this.id;
  }

  getRank(): number {
    return this.rank;
  }

  getTitle(): string {
    return this.title;
  }

  getSource(): string {
    return this.source;
  }

  getCommentCount(): number {
    return this.commentCount;
  }

  getCommentCountText(): string {
    if (this.commentCount >= 10000) {
      return `${(this.commentCount / 10000).toFixed(1)}万`;
    }
    return `${this.commentCount}`;
  }

  getCover(): Resource {
    return this.cover;
  }

  getMediaType(): DataSourceStyleCStyleC {
    return this.mediaType;
  }

  hasVideo(): boolean {
    return this.mediaType === DataSourceStyleCStyleC.VIDEO;
  }

  getHotComment(): DataSourceStyleBStyleB | null {
    return this.hotComment;
  }

  hasHotComment(): boolean {
    return this.hotComment !== null;
  }
}

export class DataSource {
  private newsList: DataSourceStyleAStyleA[] = [];
  static readonly NEWS_IDS: string[] = ['news001', 'news002'];
  static readonly NEWS_RANKS: number[] = [1, 2, 3, 4, 5];
  static readonly NEWS_TITLES: string[] = ['新闻标题1', '新闻标题2'];
  static readonly NEWS_SOURCES: string[] = ['来源1', '来源2'];
  static readonly NEWS_COMMENT_COUNTS: number[] = [14000, 5203, 2469, 45000, 320];
  static readonly NEWS_COVERS: Resource[] = [$r('app.media.news'),$r('app.media.news')];
  static readonly NEWS_MEDIA_TYPES: DataSourceStyleCStyleC[] =
    [DataSourceStyleCStyleC.NORMAL, DataSourceStyleCStyleC.NORMAL, DataSourceStyleCStyleC.NORMAL, DataSourceStyleCStyleC.NORMAL, DataSourceStyleCStyleC.NORMAL];
  static readonly HOT_COMMENT_USERS: string[] = ['用户A', '用户B'];
  static readonly HOT_COMMENT_CONTENTS: string[] = ['这条新闻很有价值！', '期待更多相关报道！'];

  constructor() {
    this.initNewsList();
  }

  private initNewsList(): void {
    for (let i = 0; i < DataSource.NEWS_IDS.length; i++) {
      const hotComment =
        new DataSourceStyleBStyleB(`c${i}`, DataSource.HOT_COMMENT_USERS[i], DataSource.HOT_COMMENT_CONTENTS[i]);
      this.newsList.push(new DataSourceStyleAStyleA(DataSource.NEWS_IDS[i], DataSource.NEWS_RANKS[i],
        DataSource.NEWS_TITLES[i], DataSource.NEWS_SOURCES[i], DataSource.NEWS_COMMENT_COUNTS[i],
        DataSource.NEWS_COVERS[i], DataSource.NEWS_MEDIA_TYPES[i], hotComment));
    }
  }

  getNewsList(): DataSourceStyleAStyleA[] {
    return this.newsList;
  }
}