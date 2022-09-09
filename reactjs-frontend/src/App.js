import './App.css';

import React, { useEffect, useState } from "react";

const release = {
   ACCOUNT_ID: process.env.REACT_APP_RELEASE_ACCOUNT_ID || '<missing env var>',
   APP_NAME: process.env.REACT_APP_RELEASE_APP_NAME || '<missing env var>',
   BRANCH_NAME: process.env.REACT_APP_RELEASE_BRANCH_NAME || '<missing env var>',
   ENV_ID: process.env.REACT_APP_RELEASE_ENV_ID || '<missing env var>'
}

import axios from "axios";
const API_BASE_URL = process.env.REACT_APP_API_BASE_URL || "https://fudhnkqmn4.execute-api.us-west-2.amazonaws.com/";
const client = axios.create({
	baseURL: API_BASE_URL
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
    try {
      setLoaded(false);
      let response = await client.get(`${API_BASE_URL}`);

      console.log(`Received: ${JSON.stringify(data,null,2)}`);
      setData(response.data);
    } catch (e) {
      console.log(`Error: ${JSON.stringify(e,null,2)}`);
      setError(e);
    } finally {
      console.log(`Done loading.`);
      setLoaded(true);
    }
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
        <b>Account:</b> {release.ACCOUNT_ID}<br/>
        <b>Application:</b> {release.APP_NAME}<br/>
        <b>Branch:</b> {release.BRANCH_NAME}<br/>
        <b>Environment ID:</b> {release.ENV_ID}
      </p>
      <br/>
      <p>
        <b>API Gateway Results:</b><br/>
          <ApiResults/>
      </p>
    </div>
  );
}

export default App;