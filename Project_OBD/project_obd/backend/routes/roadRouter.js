const express = require('express');
const router = express.Router();

//YOLOv8 감지 결과를 받아서 처리하는 엔드포인트
router.post('/detection',(req,res)=>{
    const io = req.app.get('io');
    const detection = req.body.detection;

    // 도로 표시 인식 처리
    const roadSigns = detection.filter(det => // filter : 조건에 맞는 요소만 선택!
        det.class === 'traffic_sign' ||
        det.class === 'pedestrian_crossing'
    );

    // 우회전 보행자 감지
    const pedestrians = detection.filter(det=>
        det.class === 'person'
    );

    // 클라이언트에 실시간으로 데이터 전송
    io.emit('road_detection',{ // socket.io의 기능 : 실시간으로 클라이언트에게 전송
        roadSigns : roadSigns,
        pedestrians: pedestrians,
        timestamp : new Date().toISOString()
    });

    res.json({statues:'success'});
});

// 시스템 상태 확인 엔드포인트
router.get('/statues', (req,res)=>{
    res.json({statues: 'Road detection system running'});
});

module.exports = router;
