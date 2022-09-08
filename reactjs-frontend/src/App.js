//import logo from './logo.svg';
import './App.css';

import React, { useEffect, useState } from "react";
// import the react-json-view component
import JSONViewer from 'react-json-viewer';

import axios from "axios";

const API_HOST = process.env.API_HOST || "api";
const API_PORT = process.env.API_PORT || "7001";
const API_BASE_URL = `http://${API_HOST}:${API_PORT}`

function App() {

  // Adapted API call logic from https://betterprogramming.pub/clean-api-call-with-react-hooks-3bd6438a375a
  const [country, setCountry] = useState({});
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    handleCountry();
  }, []);

  const handleCountry = async () => {
    setLoading(true);
    try {

      let countryId = 'USA';
      let API_URL =  `${API_BASE_URL}/countries/${countryId}`;
      console.log(`API_URL = ${API_URL}`);
      const result = await axios.get(
        API_URL
      );
      setCountry(result.data);
    } catch (err) {
      setError(err.message || "Unexpected Error!");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="App">
      <div>
      <h1 style={{"font-size": '70px'}}>
          Hello, Coveros!
      </h1>
      </div>
    </div>
  );
}

export default App;
