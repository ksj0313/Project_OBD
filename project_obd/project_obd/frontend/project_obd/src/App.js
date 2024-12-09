import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import './App.css';
import LogoAnimation from './components/LogoAnimation';
import MaintenancePage from './components/MaintenancePage';
import MainPage_stop from './components/MainPage_stop'; // 추가된 메인페이지 1
import MainPage_riding from './components/MainPage_riding'; // 기존의 메인페이지
import DeerBrakePractice from './components/DeerBrakePractice';
import SettingsPage from './components/SettingsPage';
import VehicleStatePage from './components/VehicleState';
// import KakaoMap from './components/KakaoMap';
import './css/mainpage_riding.css';

const App = () => {
  const [currentPage, setCurrentPage] = useState('logo'); // 'logo', 'maintenance', 'deerGame', 'main_stop', 'main_riding'
  const [isPedalPressed, setIsPedalPressed] = useState(false);
  const [isPersonDetected, setIsPersonDetected] = useState(false);

  // 로고 애니메이션 종료 시 차량 점검 화면으로 이동
  const handleAnimationEnd = () => {
    setCurrentPage('maintenance');
  };

  // 차량 점검 안내 화면에서 화면 터치 시 고라니 게임 실행
  const handleTouch = () => {
    setCurrentPage('deerGame');
  };

  // 고라니 게임 완료 시 메인 페이지 1로 이동
  const handleDeerGameComplete = () => {
    setCurrentPage('main_stop');
  };

  // 키 입력 감지 함수
  const handleKeyDown = (e) => {
    if (currentPage === 'main_stop' && (e.key === 'a' || e.key === 'b')) {
      setCurrentPage('main_riding');
    }
  };

  // 키 입력 감지 이벤트 리스너 추가 및 제거
  useEffect(() => {
    window.addEventListener('keydown', handleKeyDown);
    return () => {
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [currentPage]);

  // 페달 상태 및 카메라 감지 상태에 따라 메인 페이지 전환
  useEffect(() => {
    if (currentPage === 'main_stop' && (isPedalPressed || isPersonDetected)) {
      setCurrentPage('main_riding'); // 메인페이지2로 전환
    } else if (currentPage === 'main_riding' && !isPedalPressed && !isPersonDetected) {
      setTimeout(() => {
        // 5초간 아무 조작 없으면 메인페이지1로 복귀
        if (!isPedalPressed && !isPersonDetected) {
          setCurrentPage('main_stop');
        }
      }, 5000); // 5000ms = 5sec
    }
  }, [isPedalPressed, isPersonDetected, currentPage]);

  return (
      <div className="app">
        {currentPage === 'logo' && <LogoAnimation onAnimationEnd={handleAnimationEnd} />}
        {currentPage === 'maintenance' && <MaintenancePage onTouch={handleTouch} />}
        {currentPage === 'main_stop' && <MainPage_stop />}
        {currentPage === 'vehicle_state' && <VehicleStatePage/>}
        {currentPage === 'deerGame' && <DeerBrakePractice onGameComplete={handleDeerGameComplete} />}
        {/* {currentPage === 'kakao_map' && <KakaoMap />} */}
        {currentPage === 'main_riding' && <MainPage_riding setIsPedalPressed={setIsPedalPressed} setIsPersonDetected={setIsPersonDetected} />}

        {/* 앱의 라우트 */}
        <Routes>
          <Route path="/settings" element={ <div style={{
      position: "fixed", top: 200, left: 0, width: "100vw",
      height: "100vh", zIndex: 2, display: "flex", 
      justifyContent: "center", alignItems: "center"
    }}><SettingsPage /></div>} />
          <Route path="/vehicle_state" element={<div style={{
      position: "fixed", top: 100, left: 0, width: "100vw",
      height: "100vh", zIndex: 2, display: "flex", 
      justifyContent: "center", alignItems: "center"
    }}><VehicleStatePage /></div>} />
          <Route path="/deerGame" element={<div style={{
      position: "fixed", top: 0, left: 0, width: "100vw",
      height: "100vh", zIndex: 2, display: "flex", 
      justifyContent: "center", alignItems: "center"
    }}><DeerBrakePractice onGameComplete={handleDeerGameComplete} /></div>} />
          {/* <Route path="/kakao-map" element={<div style={{
      position: "fixed", top: 200, left: 0, width: "100vw",
      height: "100vh", zIndex: 2, display: "flex", 
      justifyContent: "center", alignItems: "center"
    }}>< KaKaoMap/></div>} /> */}
        </Routes>
      </div>
  );
};

export default App;
