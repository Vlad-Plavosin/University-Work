import { useLocation } from "react-router-dom";
import { useGlassesContext } from "../context";
import Glasses from "./Glasses";
import React from "react";

const Details = () =>{
    const location = useLocation();
    const data = location.state?.itemid;
    const glasses = useGlassesContext();
    let selectedGlasses:Glasses =glasses[0];
    glasses.forEach(element => {
      if(element.id === data)
      {
        selectedGlasses = element;
      }
    });
    return(<><div className="card">
    <div className="card-header">
      Glasses Details
    </div>
    <ul className="list-group list-group-flush">
      <li className="list-group-item">Count: {selectedGlasses ? selectedGlasses.count : ""}</li>
      <li className="list-group-item">Color: {selectedGlasses ?selectedGlasses.color : ""}</li>
      <li className="list-group-item">Shape: {selectedGlasses ?selectedGlasses.shape : ""}</li>
      <li className="list-group-item">Quality: {selectedGlasses ?selectedGlasses.quality : ""}</li>
      <li className="list-group-item">Supplier: {selectedGlasses ?selectedGlasses.supplier : ""}</li>
    </ul>
  </div></>);
}
export default Details;