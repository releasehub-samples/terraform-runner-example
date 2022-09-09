//import logo from './logo.svg';
import './App.css';

//import React, { useEffect, useState } from "react";
import React from "react";
// import the react-json-view component
//import JSONViewer from 'react-json-viewer';

//import axios from "axios";

const API_BASE_URL = process.env.API_BASE_URL || false

function App() {

  console.log(API_BASE_URL);
  
  return (
    <div className="App">
      <div>
      <h1 style={{"font-size": '70px'}}>
          Hello, world.
      </h1>
      <br/>
          ${API_BASE_URL 
            ? 
            <p>
              **API_BASE_URL** environment variable successfully retrieved at build time for this static site.<br/>
              **Value:** ${API_BASE_URL}<br/>
              
            <p/>
            :
            <p>
              Error: Unable to retrieve <b>API_BASE_URL</b> from environment variables. Check static build logs and make sure you are exporting REACT_APP_API_BASE_URL in your build script.
            </p>
            }
      </div>
    </div>
  );
}

export default App;
