//import logo from './logo.svg';
import './App.css';

//import React, { useEffect, useState } from "react";
import React from "react";
// import the react-json-view component
//import JSONViewer from 'react-json-viewer';

//import axios from "axios";

const API_HOST = process.env.API_HOST || "api";
const API_PORT = process.env.API_PORT || "7001";
const API_BASE_URL = `http://${API_HOST}:${API_PORT}`

function App() {

  console.log(API_BASE_URL);
  
  return (
    <div className="App">
      <div>
      <h1 style={{"font-size": '70px'}}>
          Hello, world.
      </h1>
      </div>
    </div>
  );
}

export default App;
