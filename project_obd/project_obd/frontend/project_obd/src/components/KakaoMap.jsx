// KakaoMap.jsx
import React, { useState, useEffect } from 'react';
import { Map, MapMarker, Circle } from 'react-kakao-maps-sdk';
import axios from 'axios';

const KakaoMap = ({ address }) => {
    const [markers, setMarkers] = useState([]);
    const [map, setMap] = useState(null);
    const [selectedShop, setSelectedShop] = useState(null);
    const [shopInfo, setShopInfo] = useState(null);
    const [center, setCenter] = useState({ lat: 33.450701, lng: 126.570667 });
    const [selectedMarker, setSelectedMarker] = useState(null);

    useEffect(() => {
        if (!map) return;
        const ps = new window.kakao.maps.services.Places();
        ps.keywordSearch(address, (data, status) => {
            if (status === window.kakao.maps.services.Status.OK) {
                const bounds = new window.kakao.maps.LatLngBounds();
                const newMarkers = data.map(item => ({
                    position: { lat: item.y, lng: item.x },
                    content: item.place_name,
                }));
                setMarkers(newMarkers);
                newMarkers.forEach(marker => bounds.extend(
                    new window.kakao.maps.LatLng(marker.position.lat, marker.position.lng)
                ));
                map.setBounds(bounds);
                setCenter({ 
                    lat: newMarkers[0].position.lat, 
                    lng: newMarkers[0].position.lng 
                });
            }
        });
    }, [map, address]);

    const handleShopClick = async (shopName, position, index) => {
        setSelectedShop(shopName);
        setCenter(position);
        setSelectedMarker(index);
        try {
            const response = await axios.post('http://localhost:3001/api/shop', { name: shopName });
            setShopInfo(response.data);
        } catch (error) {
            console.error("Error fetching shop data:", error);
        }
    };

    return (
        <div style={styles.container}>
            <Map center={center} style={styles.map} level={3} onCreate={setMap}>
                {markers.map((marker, index) => (
                    <MapMarker 
                        key={`marker-${index}`}
                        position={marker.position}
                        image={{
                            src: selectedMarker === index 
                                ? "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png" 
                                : "https://t1.daumcdn.net/mapjsapi/images/2x/marker.png",
                            size: { width: 24, height: 35 },
                        }}
                    >
                        <div style={styles.markerContent}>{marker.content}</div>
                    </MapMarker>
                ))}
                {selectedShop && (
                    <Circle 
                        center={center}
                        radius={50}
                        strokeWeight={3}
                        strokeColor="#75B8FA"
                        strokeOpacity={0.8}
                        strokeStyle="solid"
                        fillColor="#CFE7FF"
                        fillOpacity={0.7}
                    />
                )}
            </Map>
            <div style={styles.buttonContainer}>
                {markers.map((marker, index) => (
                    <button
                        key={`button-${index}`}
                        onClick={() => handleShopClick(marker.content, marker.position, index)}
                        style={{
                            ...styles.button,
                            backgroundColor: selectedShop === marker.content ? '#4CAF50' : '#f1f1f1',
                            color: selectedShop === marker.content ? 'white' : 'black',
                        }}
                    >
                        {marker.content}
                    </button>
                ))}
            </div>
            {shopInfo && (
                <div style={styles.infoContainer}>
                    <h3 style={styles.infoHeader}>정비소 정보</h3>
                    <p style={styles.infoText}>이름: {shopInfo.name}</p>
                    <p style={styles.infoText}>주소: {shopInfo.address}</p>
                    <p style={styles.infoText}>전화번호: {shopInfo.phone}</p>
                </div>
            )}
        </div>
    );
};

const styles = {
    container: {
        display: 'flex',
        flexDirection: 'column',
        height: '100vh',
        padding: '20px',
    },
    map: {
        width: "100%",
        height: "60vh",
    },
    markerContent: {
        padding: '10px',
        fontSize: '16px',
        color: '#000',
    },
    buttonContainer: {
        display: 'flex',
        flexWrap: 'wrap',
        justifyContent: 'center',
        marginTop: '20px',
    },
    button: {
        margin: '10px',
        padding: '15px 20px',
        fontSize: '24px',
        fontWeight: 'bold',
        border: 'none',
        borderRadius: '10px',
        cursor: 'pointer',
        transition: 'all 0.3s ease',
    },
    infoContainer: {
        marginTop: '20px',
        padding: '20px',
        backgroundColor: '#f0f0f0',
        borderRadius: '10px',
    },
    infoHeader: {
        fontSize: '28px',
        marginBottom: '15px',
    },
    infoText: {
        fontSize: '20px',
        marginBottom: '10px',
    },
};

export default KakaoMap;