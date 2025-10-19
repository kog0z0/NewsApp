export class Users {
  id: number;
  account: string;
  password: string;
  constructor(id:number,account: string, password: string) {
    this.id = id;
    this.account = account;
    this.password = password;
  }
}