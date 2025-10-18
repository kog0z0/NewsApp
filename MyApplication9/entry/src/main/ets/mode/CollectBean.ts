export class CollectBean {
  id: number;
  username: string;
  nid:number;
  time: string;

  constructor(id:number,username: string, nid:number,time: string) {
    this.id = id;
    this.username = username;
    this.nid = nid;
    this.time = time;
  }
}