import { Comment } from './Comment';
export class CommentItem extends Comment {
  img: string;
  constructor(id:number,head: string, username: string, mdesc: string, nid:number,time: string,img:string) {
    super(id,head,username,mdesc,nid,time)
    this.img=img;
  }
}