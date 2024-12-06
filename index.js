import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import reportWebVitals from './reportWebVitals';
import KakaoMap from './components/KakaoMap';
import State from './components/State';
import LoadingScreen from './components/LoadingScreen';
 


//state 상태페이지
//import App from './components/State';

//main 로딩페이지
//import App from './components/main';

//Map 정비업 페이지
//import App from './components/KakaoMap';




// 카카오 맵 정비소 위치

/*const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
  <KakaoMap address="광주광역시 정비소" />
  </React.StrictMode>
);*/
  

//차량 점검 상태 페이지

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
 <State />
  </React.StrictMode>
);
  
//로딩중페이지

/*const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
 <LoadingScreen/>
  </React.StrictMode>
);*/




reportWebVitals();