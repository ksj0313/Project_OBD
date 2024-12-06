const express = require('express');
const router = express.Router();
const path = require('path')
const conn = require('../config/db')

router.post('/example',(req,res)=>{
    let {id,erum,birth,gender,join_dt} = req.body;
    console.log(req.body)

    let sql = 'insert into tb_driver values(?,?,?,?,?)'
    conn.query(sql,[id,erum,birth,gender,join_dt],(err,rows)=>{
        console.log('rows',rows);
        console.log('err',err);
        if(rows){
            res.redirect('/')
        }else{
            res.send('<script>alert("데이터 입력 실패!")</script>')
        }
    })

})
module.exports = router;