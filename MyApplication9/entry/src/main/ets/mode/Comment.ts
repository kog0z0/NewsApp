export class Comment {
  id: number;
  head: string;
  username:string;
  mdesc: string;
  nid:number;
  time: string;

  constructor(id:number,head: string, username: string, mdesc: string, nid:number,time: string) {
    this.id = id;
    this.head = head;
    this.username = username;
    this.mdesc = mdesc;
    this.nid = nid;
    this.time = time;
  }
}