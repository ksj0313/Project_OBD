const express = require('express');
const cors = require('cors');
const app = express();
const port = 3001;

app.use(cors());
app.use(express.json());

app.post('/api/shop', (req, res) => {
  const { name } = req.body;
  // 여기서 실제로는 데이터베이스 조회 등의 작업을 수행합니다.
  // 이 예제에서는 간단히 하드코딩된 데이터를 반환합니다.
  const shopInfo = {
    name: name,
    address: '서울시 강남구 테헤란로 123',
    phone: '02-1234-5678'
  };
  res.json(shopInfo);
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});