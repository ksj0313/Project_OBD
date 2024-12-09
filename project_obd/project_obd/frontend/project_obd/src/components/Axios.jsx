// Axios.jsx
import axios from 'axios'

const instance = axios.create({
    baseURL: 'http://192.168.219.179:5000/'
})

export default instance