import { useState } from "react";
import {Link} from "react-router-dom"
import Glasses from "./Glasses.tsx"
import { Chart, BarElement, BarController, CategoryScale, Decimation, Filler, Legend, Title, Tooltip, LinearScale} from 'chart.js';
import { Bar } from "react-chartjs-2";
import axios from "axios";
import { useGlassesContext } from "../context.ts";
import React from "react";
import { useEffect } from "react";
import { Client } from '@stomp/stompjs';
import SockJS from "sockjs-client";

function ListGroup() {
    Chart.register(BarElement, BarController, CategoryScale, Decimation, Filler, Legend, Title, Tooltip,LinearScale);
3
  const [pagenr, setPagenr] = useState(0);
  const glasses =useGlassesContext();

  const [items, setItems] = useState(glasses);

  useEffect(() => {
    const client = new Client({
      webSocketFactory: () => new SockJS('http://localhost:9191/websocket'),
      debug: function (str:any) {
        console.log(str);
      },
      reconnectDelay: 5000,
      heartbeatIncoming: 4000,
      heartbeatOutgoing: 4000,
    });

    client.onConnect = function (frame:any) {
      console.log('WebSocket connected');
      client.subscribe('/topic/newPerson', function (message:any) {
        const newPerson = JSON.parse(message.body);
        console.log('Received new person:', newPerson);

        setItems(prevPeople => [...prevPeople, newPerson]);
      });
    };

    client.activate();

    return () => {
      client.deactivate(); // Clean up WebSocket connection on component unmount
    }
  }, []);
  


  const handleRemove = (id: number) => {
    axios.delete("http://localhost:9191/delete/" + id.toString());
    setItems(items.filter(item => item.id != id)) ;
  }
  const filterList = () =>{
    
    let newList = items.filter(item => item.count > 0);
  setItems(newList);
  
  }
  const getUniqueColors = () =>{
    let found;
    const newList:Glasses[] = [];
    items.forEach(element => {
      found = false
      newList.forEach(nlel => {
        if(nlel.color == element.color)
          {nlel.count+=element.count
          found = true}
      });
      if(!found)
        newList.push(new Glasses(element.id,element.count,element.color,element.shape,element.supplier,element.quality))
    });
    return newList
  }


  return (
    <>
      <h1>Glasses List</h1>
      <table className="table">
        <thead>
        <tr>
          <th scope="col">Color</th>
          <th scope="col">Shape</th>
          <th scope="col">Count</th>
        </tr>
        </thead>
        <tbody>
        {items.slice(pagenr*5,Math.min((pagenr*5)+5,items.length)).map((item) => (
          <tr key={item.id}>
          <td>{item.color}</td>
          <td>{item.shape}</td>
          <td>{item.count}</td>
          <td>
            <button onClick={() => handleRemove(item.id)} className="m-1 btn btn-danger" >Delete</button>
            </td>
          <td><Link className="m-1 btn btn-warning"
                to= {"/update/" + item.id}
                state =  {{ item: item }}>
                Update
                </Link></td>
          <td><Link className="m-1 btn btn-success"
                to= {"/details/" + item.id}
                state =  {{ itemid: item.id }}>
                Details
                </Link>
                </td>
          </tr>
        ))}
        </tbody>
      </table>
  <ul className="pagination">
    <li className={`page-item ${pagenr <= 0 && 'disabled'}`}>
      <button className="page-link" onClick={() => { setPagenr(pagenr-1); }}>Previous</button>
    </li>
    <li className="page-item"><span className="page-link">{pagenr}</span></li>
    <li className={`page-item ${((pagenr + 1) * 5 >= items.length) && 'disabled'}`}>
      <button className="page-link" onClick={() => { setPagenr(pagenr+1); }}>Next</button>
    </li>
  </ul>
      <br/>

      
      <button onClick={() => filterList()} className="m-1 btn btn-warning" >Filter Available</button>
      <Link className="m-1 btn btn-primary"
                to= {"/update/"}
                state =  {{ item: new Glasses(-1,0,"","","",0) }}>
                Add
                </Link>
      <div className="chart">
                <Bar
                    data={{
                        labels: getUniqueColors().map((entity) => entity.color),
                        datasets: [
                            {
                                label: 'Count',
                                data: getUniqueColors().map((entity:Glasses) => entity.count),
                                backgroundColor: getUniqueColors().map((entity:Glasses) => entity.color),
                            },
                        ]
                    }}
                />
            </div>
      
    </>
  );
}



export default ListGroup;
