import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from "react-router-dom";
import { MdArrowBack } from "react-icons/md";



const DeerBrakePractice = ({ onGameComplete }) => {
  const [deerVisible, setDeerVisible] = useState(false);
  const [startTime, setStartTime] = useState(null);
  const [responseTime, setResponseTime] = useState(null);
  const [message, setMessage] = useState('');
  const timerRef = useRef(null);
  const timeoutRef = useRef(null);
  const navigate = useNavigate();
  const iconSize = 60;

  useEffect(() => {
    // 랜덤한 시간 후에 고라니가 나타나도록 설정
    const randomTime = Math.floor(Math.random() * 5000) + 2000; // 2초에서 7초 사이
    timerRef.current = setTimeout(() => {
      setDeerVisible(true);
      setStartTime(Date.now()); 
      
      // 10초 제한시간 설정
      timeoutRef.current = setTimeout(() => {
        if (deerVisible) {
          setMessage('실패! 너무 늦게 반응했습니다.');
          setDeerVisible(false);
        }
      }, 10000);
    }, randomTime);

    return () => {
      clearTimeout(timerRef.current);
      clearTimeout(timeoutRef.current);
    };
}, []); 

  const handleKeyDown = (e) => {
    if (deerVisible && e.key === ' ') {
      const endTime = Date.now();
      setResponseTime(endTime - startTime);
      setMessage('성공! 반응 속도: ' + (endTime - startTime)/1000 + '초');
      setDeerVisible(false);

      // 게임이 끝나면 2초 후 onGameComplete 호출
      setTimeout(() => {
        if (onGameComplete) onGameComplete();
      }, 2000);
    } else if (!deerVisible && e.key === ' ') {
      setMessage('실패! 고라니가 없는데 브레이크를 밟았습니다.');
    } else if (deerVisible && e.key === 'ArrowUp') {
      setMessage('실패! 고라니가 있는데 엑셀을 밟았습니다.');
      setDeerVisible(false);
    } else if (deerVisible && e.key !== ' ') {
      setMessage('실패! 고라니가 있는데 잘못된 키를 눌렀습니다.');
      setDeerVisible(false);
    }
  };

  useEffect(() => {
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [deerVisible, startTime]);

  return (
    <div style={{ 
        backgroundColor: "black",
        height: "60vh",  // calc 제거하고 전체 높이로 설정
        width: "65vw",   // 전체 너비로 설정
        position: "fixed", // relative에서 fixed로 변경
        top: "50%",
        left: "50%",
        transform: "translate(-50%, -50%)", // 중앙 정렬
        color: "white",
        zIndex: 2,        // z-index 추가
        padding: 0,
        flexDirection: "column",
        overflow: "hidden", // 내용이 넘치지 않도록
        borderRadius: "10px", // 모서리 둥글게
        pointerEvents: "auto"
      }}>
      <header style={{ 
        display: "flex", alignItems: "center", backgroundColor: "#2196F3",
        margin: "0", padding: "20px", width: "100%", boxSizing: "border-box",
        minHeight: "80px", // 최소 높이 추가
        justifyContent: "flex-start" // 왼쪽 정렬 확실히
      }}>
        <button
          onClick={() => navigate("/")}
          style={{ background: "none", border: "none", cursor: "pointer", 
            marginRight: "110px", position: "relative", zIndex: 3}} // 아이콘과 텍스트 간격:marginRight
        >
          <MdArrowBack size={iconSize} color="white" />
        </button>
        <h1 style={{marginLeft: "10px",
    fontSize: "40px", // 글자 크기 조정
    whiteSpace: "nowrap", // 텍스트 줄바꿈 방지
    overflow: "visible" // 텍스트 잘림 방지
     }}>급제동 연습 게임</h1>
      </header>
      <div style={{ textAlign: 'center', marginTop: '50px', marginBottom: "50px",
        color:'white', paddingBottom: '100px'}}> {/* 하단 버튼과의 간격 확보  */}
        <h1 style={{ margin: "0 0 20px 0" }}>⚠️주의!! 고라니 등장!!⚠️</h1>
        <p>고라니가 나타나면 스페이스바를 눌러 브레이크를 밟으세요.</p>
        <div style={{ fontSize: '50px', margin: '20px' }}>
          {deerVisible ? '🦌' : ''}
        </div>
        <p>{message}</p>
      </div>
    </div>
  );
};

export default DeerBrakePractice;
