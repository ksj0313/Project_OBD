import React, { useEffect } from 'react';
import LogoImage from '../img/logo.png'

const LogoAnimation = ({ onAnimationEnd }) => {
    useEffect(() => {
        const timer = setTimeout(onAnimationEnd, 1500);
        return () => clearTimeout(timer);
    }, [onAnimationEnd]);

    return (
        <div className="logo-animation">
            <img src={LogoImage} alt="Logo" id="logo" />
        </div>
    );
};

export default LogoAnimation;