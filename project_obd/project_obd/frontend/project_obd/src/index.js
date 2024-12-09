import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import reportWebVitals from './reportWebVitals';
import './css/mainpage_riding.css';
import {BrowserRouter} from 'react-router-dom';

// 컴포넌트 import
import App from './App';
import SettingsPage from './components/SettingsPage';
import VehicleState from './components/VehicleState';
import DeerBrakePractice from './components/DeerBrakePractice';
//import KakaoMap from './components/KakaoMap';
import MainPage_riding from './components/MainPage_riding';
import XLeftImage from './components/XLeftImage';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
      {/* <SettingsPage /> */}
      {/* <VehicleState /> */}
      {/* <DeerBrakePractice /> */}
      {/* <KakaoMap /> */} 
      {/* <MainPage_riding /> */}
      {/* <XLeftImage /> */}
       
    </BrowserRouter>
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
