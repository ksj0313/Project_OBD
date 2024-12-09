import React, { useEffect } from 'react';

const XLeftImage = ({ onTimeout }) => {
  useEffect(() => {
    const timer = setTimeout(onTimeout, 3000); // 3초 후에 onTimeout 콜백 호출
    return () => clearTimeout(timer);
  }, [onTimeout]);

  return (
    <div className="xleft-image">
      <img src={require('../img/xleft.png').default} alt="X Left" />
    </div>
  );
};

export default XLeftImage;
