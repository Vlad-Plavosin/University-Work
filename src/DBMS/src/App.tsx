import React, { useState,useEffect } from "react";
import ListGroup from "./Components/ListGroup";
import { BrowserRouter, Route, Routes, Navigate } from "react-router-dom";
import Details from "./Components/Description";
import UpdateForm from "./Components/Update";
import { GlassesContext } from "./context";
import Glasses from "./Components/Glasses";
import axios from "axios";
import { CommandContext } from "./commandContext";
import { UserContext } from "./UserContext";

const App = () => {
  const [items, setItems] = useState<Glasses[]>([]);
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [loggedIn, setLoggedIn] = useState(false);
  const [id, setId] = useState(0);

  const handleLogin = () => {
    const newData={
      username:username,
      password:password
    }
    console.log(newData);
  axios.post("http://localhost:9191/login", newData).then(function (response) {
    setId(response.data.token); 
    console.log(response.data.token); 
    setLoggedIn(true);
  })
      .catch((error) => {
        console.error("Login failed:", error);
      });
  };

  const handleRegister = () => {
    // Make POST request to register new user
    axios.post("http://localhost:9191/adduser", { username, password })
      .then(() => {
        console.log("Registration successful!");
      })
      .catch((error) => {
        console.error("Registration failed:", error);
      });
  };

  if (!loggedIn) {
    return (
      <div>
        <form>
          <input
            type="text"
            placeholder="Username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
          />
          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <button type="button" onClick={handleLogin}>Login</button>
          <button type="button" onClick={handleRegister}>Register</button>
        </form>
      </div>
    );
  }

  return (
    <div>
      <CommandContext.Provider value={[]}>
        <GlassesContext.Provider value={items}>
          <UserContext.Provider value = {id}>
          <BrowserRouter>
            <Routes>
              <Route index element={<ListGroup />} />
              <Route path="/details/*" element={<Details />} />
              <Route path="/update/*" element={<UpdateForm />} />
              <Route path="/add" element={<UpdateForm />} />
            </Routes>
          </BrowserRouter>
          </UserContext.Provider>
        </GlassesContext.Provider>
      </CommandContext.Provider>
    </div>
  );
};

export default App;
