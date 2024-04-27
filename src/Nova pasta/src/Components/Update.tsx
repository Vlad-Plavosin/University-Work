import React, { useState, ChangeEvent } from 'react';
import { useLocation } from 'react-router-dom';
import { Link } from 'react-router-dom';
import Glasses from './Glasses';
import axios from 'axios';

interface Item {
  id: number;
  count: string;
  color: string;
  shape: string;
  quality: string;
  supplier: string;
}

const UpdateForm: React.FC = () => {
  const location = useLocation();
  const data = (location.state as { item: Item })?.item;

  const [count, setCount] = useState<string>(data ? data.count : '');
  const [color, setColor] = useState<string>(data ? data.color : '');
  const [shape, setShape] = useState<string>(data ? data.shape : '');
  const [quality, setQuality] = useState<string>(data ? data.quality : '');
  const [supplier, setSupplier] = useState<string>(data ? data.supplier : '');

  function handleUpdate(){
    if(data.id == -1)
    {
      const newData={
        shape:shape,
        supplier:supplier,
        color:color,
        count: count,
        quality:quality
      }
      console.log(newData);
    axios.post("http://localhost:9191/addProduct", newData).then(function (response) {
      console.log(response);
    })
    }
    else
    {
      axios.put("http://localhost:9191/update", new Glasses(data.id,parseInt(count),color,shape,supplier,parseInt(quality)));
      console.log("up");
    }
    }

  const handleQuantityChange = (event: ChangeEvent<HTMLInputElement>) => {
    setCount(event.target.value);
  };

  const handleColorChange = (event: ChangeEvent<HTMLInputElement>) => {
    setColor(event.target.value);
  };

  const handleShapeChange = (event: ChangeEvent<HTMLInputElement>) => {
    setShape(event.target.value);
  };

  const handleQualityChange = (event: ChangeEvent<HTMLInputElement>) => {
    setQuality(event.target.value);
  };

  const handleSupplierChange = (event: ChangeEvent<HTMLInputElement>) => {
    setSupplier(event.target.value);
  };

  return (
    <form>
      <div className="form-group">
        <label>Quantity</label>
        <input
          value={count}
          onChange={handleQuantityChange}
          className="form-control"
          id="qt"
          aria-describedby="emailHelp"
          placeholder="Enter quantity"
        />
      </div>
      <div className="form-group">
        <label>Color</label>
        <input
          value={color}
          onChange={handleColorChange}
          className="form-control"
          id="co"
          placeholder="Enter color"
        />
      </div>
      <div className="form-group">
        <label>Shape</label>
        <input
          value={shape}
          onChange={handleShapeChange}
          className="form-control"
          id="sh"
          placeholder="Enter shape"
        />
      </div>
      <div className="form-group">
        <label>Quality</label>
        <input
          value={quality}
          onChange={handleQualityChange}
          className="form-control"
          id="ql"
          placeholder="Enter quality"
        />
      </div>
      <div className="form-group">
        <label>Supplier</label>
        <input
          value={supplier}
          onChange={handleSupplierChange}
          className="form-control"
          id="su"
          placeholder="Enter supplier"
        />
      </div>
      <Link onClick={() => handleUpdate()} className="m-1 btn btn-primary"
                to= "/">
                Submit
                </Link>
    </form>
  );
};

export default UpdateForm;
