
import React, { useState, useEffect } from 'react';
import { useNavigate } from "react-router-dom";
import { MdArrowBack } from "react-icons/md";
import img1 from '../img/sportage.png';

const VehicleState = () => {

        const navigate = useNavigate();
        const iconSize = 60;
        
        const [vehicleData, setVehicleData] = useState({
            engineTemp: { value: 90, status: '정상' },
            engineOil: { value: '80%', status: '정상' },
            brakeOil: { value: '30%', status: '정상' },
            fuelLevel: { value: '10%', status: '비정상' },
            battery: {
                SOH: { value: '95%', status: '정상' },
                SOC: { value: '80%', status: '정상' },
                DOD: { value: '20%', status: '정상' },
                SOP: { value: '100%', status: '정상' },
            },
            mileage: 45000,
        });

        useEffect(() => {
            const interval = setInterval(() => {
                setVehicleData(prevData => ({
                    ...prevData,
                    engineTemp: {
                        value: Math.floor(Math.random() * (95 - 85) + 85),
                        status: Math.random() > 0.9 ? '비정상' : '정상'
                    },
                    battery: {
                        ...prevData.battery,
                        SOC: {
                            value: `${Math.floor(Math.random() * (100 - 60) + 60)}%`,
                            status: Math.random() > 0.9 ? '비정상' : '정상'
                        }
                    }
                }));
            }, 5000);
            return () => clearInterval(interval);
        }, []);

        return (
            <div style={{
                padding: "20px",
                paddingLeft: "40px",
                backgroundColor: "black",
                height: "100vh",
                color: "white",
            }}>
                <header style={{ 
                     display: "flex", 
                     alignItems: "center", 
                     marginBottom: "65px",
                     backgroundColor: "#2196F3", // 파란색 배경 추가
                     margin: "-20px -20px 20px -20px", // 여백 제거
                     padding: "20px 40px", // 내부 여백 추가
                }}>
                    <button
                        onClick={() => navigate("/home")}
                        style={{ background: "none", border: "none", cursor: "pointer" }}
                    >
                        <MdArrowBack size={iconSize} color="white" />
                    </button>
                    <h1 style={{ marginLeft: "10px" }}>차량 상태 점검</h1>
                </header>
        
                <div style={{ 
                    display: "flex",
                    height: "calc(100vh - 120px)",
                    padding: "20px",
                    gap: "40px"
                }}>
                    <div style={{ 
                        width: "40%",
                        display: "flex",
                        flexDirection: "column",
                        alignItems: "center",
                        justifyContent: "center", // 세로 중앙 정렬 추가
                    }}>
                        <img 
                            src={img1} 
                            alt="Vehicle" 
                            style={{ 
                                width: "100%",
                                height: "auto",
                                maxHeight: "70%",
                                objectFit: "contain"
                            }} 
                        />
                        <h2 style={{ 
                            marginTop: "20px",
                            fontSize: "32px",
                            color: "white"
                        }}>KIA Sportage 2023</h2>
                    </div>
        
                    <div style={{ 
                        width: "60%",
                        backgroundColor: "rgba(255, 255, 255, 0.1)",
                        borderRadius: "10px",
                        padding: "20px",
                        overflowY: "auto"
                    }}>
                    <div style={styles.gridContainer}>
                        <InfoItem label="엔진 온도" value={`${vehicleData.engineTemp.value}°C`} status={vehicleData.engineTemp.status} />
                        <InfoItem label="엔진 오일 상태" value={vehicleData.engineOil.value} status={vehicleData.engineOil.status} />
                        <InfoItem label="브레이크 오일 레벨" value={vehicleData.brakeOil.value} status={vehicleData.brakeOil.status} />
                        <InfoItem label="현재 연료량" value={vehicleData.fuelLevel.value} status={vehicleData.fuelLevel.status} />
                    </div>
                    <div style={styles.batterySection}>
                        <h3 style={styles.subHeader}>차량 배터리 상태</h3>
                        <div style={styles.batteryGrid}>
                            <BatteryInfo label="SOH" value={vehicleData.battery.SOH.value} status={vehicleData.battery.SOH.status} />
                            <BatteryInfo label="SOC" value={vehicleData.battery.SOC.value} status={vehicleData.battery.SOC.status} />
                            <BatteryInfo label="DOD" value={vehicleData.battery.DOD.value} status={vehicleData.battery.DOD.status} />
                            <BatteryInfo label="SOP" value={vehicleData.battery.SOP.value} status={vehicleData.battery.SOP.status} />
                            </div>
                    </div>
                </div>
            </div>
        </div>
        );
    }
    const InfoItem = ({ label, value, status }) => (
        <div style={styles.infoItem}>
            <span style={styles.label}>{label}:</span>
            <span style={styles.value}>{value}</span>
            <span style={status === '정상' ? styles.statusNormal : styles.statusAbnormal}>{status}</span>
        </div>
    );

    const BatteryInfo = ({ label, value, status }) => (
        <div style={styles.batteryInfo}>
            <span style={styles.batteryLabel}>{label}</span>
            <span style={styles.batteryValue}>{value}</span>
            <span style={status === '정상' ? styles.statusNormal : styles.statusAbnormal}>{status}</span>
        </div>
    );

    const styles = {
        container: {
            display: 'flex',
            justifyContent: 'space-between',
            padding: '40px',
            width: '100%',
            height: '100vh',
            margin: 'auto',
            fontFamily: 'Arial, sans-serif',
            boxSizing: 'border-box',
        },
        imageSection: {
            flex: 1,
            padding: '20px',
            textAlign: 'center',
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'center',
        },
        detailsSection: {
            flex: 2,
            padding: '40px',
            backgroundColor: '#f8f9fa',
            borderRadius: '20px',
            boxShadow: '0 8px 16px rgba(0, 0, 0, 0.1)',
        },
        vehicleImage: {
            width: '100%',
            maxWidth: '500px',
            height: 'auto',
            borderRadius: '15px',
            boxShadow: '0 8px 12px rgba(0, 0, 0, 0.1)',
            marginBottom: '30px',
        },
        vehicleName: {
            fontSize: '50px',
            fontWeight: 'bold',
            marginTop: '20px',
        },
        header: {
            fontSize: '48px',
            fontWeight: 'bold',
            marginBottom: '30px',
            color: '#333',
        },
        subHeader: {
            fontSize: '36px',
            fontWeight: 'bold',
            marginBottom: '25px',
            color: '#444',
        },
        gridContainer: {
            display: 'grid',
            gridTemplateColumns: 'repeat(2, 1fr)',
            gap: '25px',
            marginBottom: '40px',
        },
        infoItem: {
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            padding: '20px',
            backgroundColor: '#fff',
            borderRadius: '10px',
            boxShadow: '0 4px 8px rgba(0, 0, 0, 0.05)',
            fontSize: '28px',
        },
        label: {
            fontWeight: 'bold',
            color: '#555',
        },
        value: {
            color: '#007bff',
            fontWeight: 'bold',
        },
        batterySection: {
            marginTop: '40px',
        },
        batteryGrid: {
            display: 'grid',
            gridTemplateColumns: 'repeat(2, 1fr)',
            gap: '25px',
        },
        batteryInfo: {
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            padding: '25px',
            backgroundColor: '#e9ecef',
            borderRadius: '15px',
            fontSize: '28px',
        },
        batteryLabel: {
            fontWeight: 'bold',
            marginBottom: '10px',
        },
        batteryValue: {
            color: '#28a745',
            fontWeight: 'bold',
            fontSize: '32px',
        },
        statusNormal: {
            color: '#28a745',
            fontWeight: 'bold',
        },
        statusAbnormal: {
            color: '#dc3545',
            fontWeight: 'bold',
        }
    };

export default VehicleState;