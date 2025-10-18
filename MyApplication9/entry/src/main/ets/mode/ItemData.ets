export default class ItemData {

  index:string;
  title: Resource|string;
  img: Resource;
  others?: Resource|string;

  constructor(index:string,title: Resource|string, img: Resource, others?: Resource|string) {
    this.index = index;
    this.title = title;
    this.img = img;
    this.others = others;
  }
}