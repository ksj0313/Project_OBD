
import React from "react";
import { Link } from "react-router-dom";
import carImage from "../img/mainback.gif";
import { FaHome, FaCog, FaCar, FaGamepad, FaMapMarkerAlt } from "react-icons/fa";
import '../css/mainpage_stop.css';

const MainPage_stop = () => {
  // 버튼 스타일을 위한 변수들
  const buttonSize = "150px"; // 버튼 크기 (배경 이미지에 비례하여 조정)
  const buttonColor = "rgba(255, 255, 255, 0.5)"; // 버튼 색상

  const buttonStyle = {
    width: buttonSize,
    height: buttonSize,
    borderRadius: "50%", // 원형 버튼
    backgroundColor: buttonColor,
    display: "flex",
    flexDirection: "column", // 수직 방향으로 정렬
    justifyContent: "center", // 중앙 정렬
    alignItems: "center", // 중앙 정렬
    margin: "20px", // 버튼 간의 여백 조정
    color: "black",
    textDecoration: "none",
    fontSize: "25px",
    fontWeight: "bold",
    position: "relative",
    overflow: "hidden", // 자식 요소가 부모 요소를 넘치지 않도록 설정
    border: "2px solid rgba(255, 255, 255, 0.3)", // 테두리 추가
    transition: "all 0.3s ease" // 호버 효과를 위한 트랜지션
  };

  return (
    <div
      style={{
        backgroundImage: `url(${carImage})`,
        backgroundSize: "cover", // 배경 이미지 크기를 605x454 픽셀로 설정
        backgroundPosition: "center", // 이미지 위치 조정
        backgroundRepeat: "no-repeat", // 반복하지 않도록 설정
        width: "100vw",
        height: "100vh", // 최소 높이를 화면 높이로 설정
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        padding: "0px",
      }}
    >
      <div style={{ position: "absolute", top: 10, left: 20 }}>
        <Link
          to="/home"
          style={{
            display: "inline-flex",
            alignItems: "center",
            color: "#FFFFFF",
            textDecoration: "none",
          }}
        >
          <FaHome size={40} />
          <span style={{ marginLeft: "10px", fontSize:"25px" }}>홈 화면</span>
        </Link>
      </div>

      <div
        style={{
          position: "absolute",
          bottom: "100px",
          left: "50%", // 중앙 정렬을 위해 left를 50%로 설정
          transform: "translateX(-50%)", // 중앙 정렬을 위한 변환 적용
          display: "flex",
          flexWrap: "nowrap",
          justifyContent: "center",
          gap: "10px", // 버튼 간격 조정
        }}
      >
        <Link to="/settings" style={buttonStyle} className="glow-button">
          <FaCog size={35} />
          <span style={{ marginTop: "5px", textAlign: "center" }}>
            환경설정
          </span>
        </Link>
        <Link to="/vehicle_state" style={buttonStyle} className="glow-button">
          <FaCar size={35} />
          <span style={{ marginTop: "5px", textAlign: "center" }}>
            차량관리
          </span>
        </Link>
        <Link to="/deergame" style={buttonStyle} className="glow-button">
          <FaGamepad size={37} />
          <span style={{ marginTop: "5px", textAlign: "center" }}>
            운전게임
          </span>
        </Link>
        <Link to="/kakao-map" style={buttonStyle} className="glow-button">
          <FaMapMarkerAlt size={35} />
          <span style={{ marginTop: "5px", textAlign: "center" }}>
            정비소위치
          </span>
        </Link>
      </div>
    </div>
  );
};

export default MainPage_stop;