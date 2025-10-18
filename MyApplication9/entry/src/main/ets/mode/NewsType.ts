export class NewsType {
  id: number;
  name: string;
  mdesc: string;
  constructor(id:number,name: string, mdesc: string) {
    this.id = id;
    this.name = name;
    this.mdesc = mdesc;
  }
}