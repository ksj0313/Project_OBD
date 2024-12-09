import React from 'react';

const MaintenancePage = ({ onTouch }) => {
    return (
        <div className="maintenance-page" onClick={onTouch}>
            <h1>브레이크 오일의 점검이 필요합니다</h1>
            <p>화면을 터치하면 메인화면으로 넘어갑니다</p>
        </div>
    );
};

export default MaintenancePage;