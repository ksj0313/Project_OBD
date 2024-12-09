import React, { useState, useEffect } from "react";
import volumeIcon from "../assets/volume-icon.png";
import volumeMuteIcon from "../assets/volume-mute-icon.png";
import brightnessIcon from "../assets/brightness-icon.png";
import brightnessDarkIcon from "../assets/brightness-dark-icon.png";
import { useNavigate } from "react-router-dom";
import { MdArrowBack } from "react-icons/md";

const SettingsPage = () => {
const [volume, setVolume] = useState(50);
const [brightness, setBrightness] = useState(50);
const navigate = useNavigate();

const iconSize = 60; // 아이콘 크기
const sliderStyle = {
    width: "1700px", // 슬라이더 길이
    height: "20px",
    marginLeft: "10px",
};

useEffect(() => {
    console.log("Volume:", volume);
}, [volume]);

useEffect(() => {
    console.log("Brightness:", brightness);
}, [brightness]);

const handleVolumeChange = (e) => {
    setVolume(Number(e.target.value));
};

const handleBrightnessChange = (e) => {
    setBrightness(Number(e.target.value));
};

return (
    <div
    style={{
        padding: "20px",
        paddingLeft: "40px",
        backgroundColor: "black",
        height: "100vh",
        color: "white",
    }}
    >
    <header
        style={{ display: "flex", alignItems: "center", marginBottom: "65px" }}
    >
        <button
        onClick={() => navigate("/home")} // 홈 화면으로 이동
        style={{ background: "none", border: "none", cursor: "pointer" }}
        >
        <MdArrowBack size={iconSize} color="white" />
        </button>
        <h1 style={{ marginLeft: "10px" }}>소리와 밝기 조절</h1>
    </header>
    {/* 볼륨 조절 섹션 */}
    <div
        className="control-container"
        style={{ display: "flex", alignItems: "center", marginBottom: "60px" }}
    >
        {/* 볼륨 상태에 따라 아이콘 변경 */}
        <img
        src={volume === 0 ? volumeMuteIcon : volumeIcon}
        alt="Volume Icon"
        style={{ width: "60px", height: "60px" }}
        />
        <input
        type="range"
        min="0"
        max="100"
        value={volume}
        onChange={handleVolumeChange}
        style={sliderStyle}
        />
        <span style={{ marginLeft: "10px", fontSize: "18px" }}>{volume}</span>
    </div>
    {/* 밝기 조절 섹션 */}
    <div
        className="control-container"
        style={{ display: "flex", alignItems: "center" }}
    >
        {/* 밝기 상태에 따라 아이콘 변경 */}
        <img
        src={brightness === 0 ? brightnessDarkIcon : brightnessIcon}
        alt="Brightness Icon"
        style={{ width: "60px", height: "60px" }}
        />
        <input
        type="range"
        min="0"
        max="100"
        value={brightness}
        onChange={handleBrightnessChange}
        style={sliderStyle}
        />
        <span style={{ marginLeft: "10px", fontSize: "18px" }}>
        {brightness}
        </span>
    </div>
    </div>
);
}

export default SettingsPage;
