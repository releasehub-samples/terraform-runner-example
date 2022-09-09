//import logo from './logo.svg';
import './App.css';

import React, { useEffect, useState } from "react";
//import React from "react";
// import the react-json-view component
//import JSONViewer from 'react-json-viewer';

import axios from "axios";

const API_BASE_URL = process.env.REACT_APP_API_BASE_URL || "Failed to retrieve REACT_APP_API_BASE_URL at build time.";

const client = axios.create({
	baseURL: process.env.REACT_APP_BACKEND_URL
});

function App() {

  console.log('API_BASE_URL: ' + API_BASE_URL.toString());
  
  const [data, setData] = useState({});
  const [error, setError] = useState("");
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    getApiResponse();
  }, []);

  async function getApiResponse() {
    ``;
    try {
      setLoaded(true);
      const data = await getHelloMessage();
      setData(data);
    } catch (e) {
      setError(e);
    } finally {
      setLoaded(false);
    }
  }

  async function getHelloMessage() {
    return await client.get(`${API_BASE_URL}/hello`);
  }

  function ApiResults() {
    if (error) {
      return `Failed to retrieve API GW Response: ${JSON.stringify(error,null,2)}`;
    } 
    return loaded ? data.message : "Loading...";
  }

  return (
    <div className="App">
      <div>
        <h1 style={{"fontSize": '70px'}}>
            Hello, world.
        </h1>
      </div>
      <br/>
      <p>
        <b>API Gateway Results:</b><br/>
          <ApiResults/>
      </p>
    </div>
  );
}

export default App;