import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import '../css/mainpage_riding.css';

const MainPage_riding = ({ setIsPedalPressed, setIsPersonDetected }) => {
  
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [showImage, setShowImage] = useState(false);
  const [brake, setBrake] = useState(false);
  const [accelerator, setAccelerator] = useState(false);

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  const handlePedestrianDetection = () => {
    setShowImage(true);
    setTimeout(() => {
      setShowImage(false); 
    }, 5000);
  };  
  
  
  
  
  useEffect(() => {
    const handleKeyDown = (event) => {
      if (event.key === 'b') setBrake(true);
      if (event.key === 'a') setAccelerator(true);
    };

    const handleKeyUp = (event) => {
      if (event.key === 'b') setBrake(false);
      if (event.key === 'a') setAccelerator(false);
    };

    // 예시로 전후방 카메라 데이터 수신
    const checkPersonDetection = () => {
      // 가상의 감지 로직 (카메라 입력 시 데이터를 업데이트해야 함)
      const detected = Math.random() < 0.5; // 랜덤 값 (실제 카메라 API 대체 필요)
      //setIsPersonDetected(detected);
    };

    window.addEventListener('keydown', handleKeyDown);
    window.addEventListener('keyup', handleKeyUp);
    const cameraInterval = setInterval(checkPersonDetection, 2000); // 2초마다 감지 확인

    return () => {
      window.removeEventListener('keydown', handleKeyDown);
      window.removeEventListener('keyup', handleKeyUp);
      clearInterval(cameraInterval);
    };
  }, [setIsPedalPressed, setIsPersonDetected]);

  return (
    <div className="main-page">
      <div className="hamburger-menu" onClick={toggleMenu}>
        <div className={`hamburger-icon${isMenuOpen ? ' open' : ''}`}>
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>

       {/* 메뉴 항목 */}
       {isMenuOpen && (
        <div className="menu-items">
          <Link to="/settings" className="menu-item">환경설정탭</Link>
          <br/>
          <Link to="/vehicle-check" className="menu-item">차량관리탭</Link>
          <br/>
          <Link to="/vehicle-check" className="menu-item">광주정비소</Link>
          <br/>
          <Link to="/vehicle-check" className="menu-item">고라니게임</Link>
        </div>
      )}

      <div className="center-container">
        {showImage ? (
          <img src="4f500e8f88.gif" alt="Pedestrian Detected" className="pedestrian-image" />
        ) : (
          <button onClick={handlePedestrianDetection} className="detect-button">
            시뮬레이션
          </button>
        )}
      </div>

      <div className="right-corner">
        {brake && <img src="/break.jpg" alt="Break Animation" />}
        {accelerator && <img src="/accel.jpg" alt="Foot Animation" />}
      </div>

      <div className="instructions">
        <p>Press 'b' for brake, 'a' for accelerator</p>
      </div>
    </div>
  );
};


export default MainPage_riding;
