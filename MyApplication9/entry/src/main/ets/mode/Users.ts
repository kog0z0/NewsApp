export class Users {
  id: number;
  account: string;
  password: string;
  avatar: string = '';
  constructor(id:number,account: string, password: string, avatar: string) {
    this.id = id;
    this.account = account;
    this.password = password;
    this.avatar = avatar;
  }
}