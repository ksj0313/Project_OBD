const express = require('express');
const router = express.Router();

// OBD2 데이터 수신 엔드포인트
router.post('/data',(req,res)=>{
    const io = req.app.get('io');
    const obdData = req.body;

    // 데이터 검증 및 처리
    const processedData = {
        engineTemp: obdData.engineTemp, // 엔진 온도
        engineOil:obdData.engineOil, // 엔진 오일 잔량
        brakeOil: obdData.brakeOil, // 브레이크 오일 잔량
        fuelLevel:obdData.fuelLevel, // 연료 함량
        range: obdData.range, // 주행 가능 거리
        timestamp: new Date().toISOString()
    };
    // 점검 필요 여부 확인 
    const diagnosticInfo = checkDiagnosticStatus(processedData);

    // 소켓을 통해 클라이언트에게 상태 페이지 데이터 전송 
    io.emit('Status_info',{
        statusdata:diagnosticInfo.status,
        needsMaintenence : diagnosticInfo.needsMaintenence,
        warnings : diagnosticInfo.warnings
    });

    // 소켓을 통해 클라이언트에게 진단 페이지 데이터 전송
    io.emit('Diagnostic_info',{
        detailedInfo: diagnosticInfo.detailedInfo,
        timestamp: diagnosticInfo.timestamp
    });

    res.json({ status:'success'});

});

// 상태 및 진단 정보 확인 함수
function checkDiagnosticStatus(data) {
        const status = {
            engineTemp: { status: '정상', message: '' },
            engineOil: { status: '정상', message: '' },
            brakeOil: { status: '정상', message: '' },
            fuelLevel: { status: '정상', message: '' },
        };
        
        const detailedInfo = {
            engineTemp: {
                value: data.engineTemp, unit: '°C', normalRange:'80°C~105°C'
            },
            engineOil: {
                value: data.engineOil, unit: '%', normalRange:'20%이상'
            },
            brakeOil: {
                value: data.brakeOil, unit: '%', normalRange:'30% 이상'
            },
            fuelLevel: {
                value: data.fuelLevel, unit: '%', normalRange:'15% 이상'
            },
            range: {
                value: data.range, unit: 'km'
            },
            // fuelEfficiency: {
            //     value: data.fuelEfficiency,
            //     unit: 'km/L'
            // }
        }
        let needsMaintenance = false;
        const warnings = [];

        // 엔진 온도 체크
        if (data.engineTemp > 105) {
            status.engineTemp.status = '비정상';
            status.engineTemp.message = '엔진 과열 (고온)';
            warnings.push('엔진 과열 상태입니다. 점검이 필요합니다.');
            needsMaintenance = true;
        } else if (data.engineTemp < 80) {
            status.engineTemp.status = '비정상';
            status.engineTemp.message = '엔진 온도 부족 (저온)';
            warnings.push('엔진 과열 상태입니다. 예열이 필요합니다.');
            needsMaintenance = true;
        }

        // 엔진 오일 상태 체크
        if (data.engineOil < 20) {
            status.engineOil.status = '비정상';
            status.engineOil.message = '엔진 오일 부족(20% 미만)';
            warnings.push('엔진 오일이 부족합니다. 보충이 필요합니다.');
            needsMaintenance = true;
        }

        // 브레이크 오일 레벨 체크
        if (data.brakeOil < 30) {
            status.brakeOil.status = '비정상';
            status.brakeOil.message = '브레이크 오일 부족 (30% 미만)';
            warnings.push('브레이크 오일이 부족합니다. 보충이 필요합니다.');
            needsMaintenance = true;
        }

        // 연료량 체크
        if (data.fuelLevel < 15) {
            status.fuelLevel.status = '비정상';
            status.fuelLevel.message = '연료 부족 (15% 미만)';
            warnings.push('연료가 부족합니다. 주유가 필요합니다.');
            needsMaintenance = true;
        }
        // 주행가능거리 경고
        // if (data.range < 50) {  // 주행가능거리가 50km 미만일 때
        //     status.range.status = '비정상';
        //     status.range.message = '주행가능거리 부족';
        //     warnings.push('주행가능거리가 50km 미만입니다. 주유가 필요합니다.');
        // }

        return {
            needsMaintenance,
            status,
            detailedInfo,
            warnings,
            timestamp: new Date().toISOString()
        };
}



module.exports = router;