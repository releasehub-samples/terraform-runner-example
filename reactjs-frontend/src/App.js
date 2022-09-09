//import logo from './logo.svg';
import './App.css';

//import React, { useEffect, useState } from "react";
import React from "react";
// import the react-json-view component
//import JSONViewer from 'react-json-viewer';

//import axios from "axios";

const REACT_APP_API_BASE_URL = process.env.REACT_APP_API_BASE_URL || "Failed to retrieve REACT_APP_API_BASE_URL at build time.";

function App() {

  console.log('API_BASE_URL: ' + REACT_APP_API_BASE_URL.toString());
  
  return (
    <div className="App">
      <div>
        <h1 style={{"font-size": '70px'}}>
            Hello, world.
        </h1>
      </div>
      <br/>
      <p>
      ${REACT_APP_API_BASE_URL.toString()}
      </p>
      </div>
  );
}

export default App();