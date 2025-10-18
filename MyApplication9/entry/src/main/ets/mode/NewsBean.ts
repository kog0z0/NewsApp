export class NewsBean {
  id: number;
  image: string;
  title: string;
  mdesc: string;
  type:number;
  time: string;

  constructor(id:number,image: string, title: string, mdesc: string, type:number,time: string) {
    this.id = id;
    this.image = image;
    this.title = title;
    this.mdesc = mdesc;
    this.type = type;
    this.time = time;
  }
}