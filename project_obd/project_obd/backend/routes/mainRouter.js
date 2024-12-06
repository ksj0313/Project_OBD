express = require('express');
router = express.Router();
const path = require('path');

router.get('/',(req,res)=>{
    console.log("서버 연결");
    res.render('main');
})

router.get('/example',(req,res)=>{
    res.render('example')
})

module.exports = router;