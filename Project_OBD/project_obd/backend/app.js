const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');
const mainRouter = require('./routes/mainRouter');
const roadRouter = require('./routes/roadRouter');
const obdRouter = require('./routes/obdRouter');

const app = express();
// http서버 열어주기!
const server = http.createServer(app);
const io = socketIo(server, {
    cors: {
        origin: " http://localhost:3000", // 프론트엔드의 url작성해주기!
        methods: ["GET","POST"]
    }
})

app.use(express.static('public'));
app.use(cors());
app.use(express.json())

// 소켓 인스턴스를 라우터에서 사용할 수 있도록 전달
app.set('io',io);

// 라우터 이용!
app.use('/',mainRouter);
app.use('/api/road', roadRouter);
app.use('api/check', obdRouter);


const PORT = 5000;
app.set('port', process.env.PORT || 5000);
app.listen(app.get('port'), ()=>{
    console.log(`Server is running on ${app.get('port')}`);
})
