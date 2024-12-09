import React from "react";
import "../style/LoadingScreen.css";
import { useState } from "react";
const LoadingScreen = () => {
  return (
    <div className="loading-screen">
      <div className="road">
        <div className="car">
          🚗
        </div>
      </div>
      <div className="loading-text">
        <span>L</span>
        <span>O</span>
        <span>A</span>
        <span>D</span>
        <span>I</span>
        <span>N</span>
        <span>G</span>
      </div>
    </div>
  );
};

export default LoadingScreen;