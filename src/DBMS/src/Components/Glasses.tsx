class Glasses {
    id: number;
      count: number;
      color: string;
      shape: string;
      supplier: string;
      quality: number;
      userId: number;
    constructor(id:number,count:number,color:string,shape:string,supplier: string,quality: number,userId:number) {
      this.id = id;
      this.count = count;
      this.color = color;
      this.shape = shape;
      this.supplier = supplier;
      this.quality = quality;
      this.userId = userId;
    }
  }

  export default Glasses;