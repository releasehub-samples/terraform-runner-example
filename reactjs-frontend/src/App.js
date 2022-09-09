//import logo from './logo.svg';
import './App.css';

//import React, { useEffect, useState } from "react";
import React from "react";
// import the react-json-view component
//import JSONViewer from 'react-json-viewer';

//import axios from "axios";

const API_BASE_URL = process.env.API_BASE_URL || "Environment variable API_BASE_URL not set."

function App() {

  console.log(API_BASE_URL);
  
  return (
    <div className="App">
      <div>
      <h1 style={{"font-size": '70px'}}>
          Hello, world.
          <br/>
          API Base URL: ${API_BASE_URL}
      </h1>
      </div>
    </div>
  );
}

export default App;
