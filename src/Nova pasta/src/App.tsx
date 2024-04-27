import ListGroup from "./Components/ListGroup";
import {BrowserRouter,Route,Routes} from "react-router-dom";
import Details from "./Components/Description";
import UpdateForm from "./Components/Update";
import { GlassesContext } from "./context";
import Glasses from "./Components/Glasses";
import axios from "axios";
import { useEffect,useState } from "react";
import ErrorPage from "./Components/ErrorPage";

const App = () => {
  const [items, setItems] = useState<Glasses[]>([]);
  const [loading, setLoading] = useState(true);
  const [err, setErr] = useState(false);

  

  useEffect(() => {
    axios.get("http://localhost:9191/products")
      .then((response) => {
        const posts : Glasses[] = response.data;
          const newItems = posts.map((g) => {
            return new Glasses(
              g.id,
              g.count,
              g.color,
              g.shape,
              g.supplier,
              g.quality
            );
          });
          setItems(newItems);
          setLoading(false);
      })
      .catch(() => {
        setErr(true);
      });
  }, []);
  if(err){
    return(<div>Server Error</div>)
  }
if(!loading){
  return (<div>
    <GlassesContext.Provider value = {items}>
    <BrowserRouter>
    <Routes>
      <Route index element ={<ListGroup />}></Route>
      <Route path="/details/*" element={<Details />}></Route>
      <Route path="/update/*" element={<UpdateForm />}></Route>
      <Route path="/add" element={<UpdateForm />}></Route>
    </Routes>
    </BrowserRouter>
    </GlassesContext.Provider>
    </div>)
}
}
export default App;