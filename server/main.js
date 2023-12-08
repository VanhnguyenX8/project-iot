import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';
import express from 'express';
import cors from 'cors';
import http from 'http';
import admin from 'firebase-admin';
import authRoutes from './routes/routes.js';
import serviceAccount from '../server/notication-firebase-adminsdk-ewzzv-3cd6feafba.json' assert { type: 'json' };
import mqtt from 'mqtt';
import redis from 'redis';
import db from './config/dbConfig.js';
import websocket from 'ws';
// const serviceAccount = require('../server/notication-firebase-adminsdk-ewzzv-3cd6feafba.json');

// Khởi tạo ứng dụng Express
const app = express();
app.use(express.json());

// Thiết lập CORS
app.use(cors({
  origin: "*",
  methods: ["GET", "POST", "DELETE", "UPDATE", "PUT", "PATCH"],
  credentials: true
}));
const redisClient = redis.createClient();
const wss = new websocket.Server({ port: 8080});
redisClient.subscribe('newData');
redisClient.on('message', (channel, message) => {
  if (channel === 'newData') {
    // Gửi dữ liệu mới cho tất cả clients đang kết nối qua WebSocket
    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(message);
      }
    });
  }
});
wss.on('connection', function connection(ws) {
  console.log("connect thanh cong")
  ws.on('message', function incoming(message) {
    console.log("in ra mes" + message);
    if (message === 'getData') {
      console.log("da vao day!");
      db.query('SELECT * FROM iot', (err, results) => {
        if (err) {
          throw err;
        }
        ws.send(JSON.stringify(results));
      });
    }
  });
  db.query('SELECT * FROM iot', (err, results) => {
    if (err) {
      throw err;
    }
    ws.send(JSON.stringify(results));
  })
});
// const server = http.createServer(app);
// Thiết lập Content-Type cho response
app.use(function (req, res, next) {
  res.setHeader("Content-Type", "application/json");
  next();
});
// Kết nối tới MQTT Broker sử dụng Paho MQTT
const mqttClient = mqtt.connect("ws://192.168.45.150:1883");
// lang nghe ket noi mqtt
mqttClient.on("connect", () => {
  mqttClient.log("Connected to MQTT Broker");
  mqttClient.subscribe("led1");
  mqttClient.subscribe("led2");
  mqttClient.subscribe("temperature");
  mqttClient.subscribe("humidity");
  mqttClient.subscribe("light");
});
// path
app.use(authRoutes);
// Khởi tạo Firebase Admin SDK
initializeApp({
  credential: applicationDefault(),
  projectId: 'notication',
  credential: admin.credential.cert(serviceAccount),
});

// Endpoint để gửi thông báo mobile
app.post("/send", function (req, res) {
  const receivedToken = req.body.fcmToken;

  const message = {
    notification: {
      title: "Cảnh báo!",
      body: 'Số lượng vật phẩm lỗi đã quá giới hạn cho phép.'
    },
    // token vs5
    token: "cSwStbQQTJSTSmZLsWFrC9:APA91bHsmXwkp8suS56yTbXoanwnZ5C14qXUoLt-CjKPIJxoRY7nEMhDnO9iMP_1xzCApRtItwA7UceO5OBEXFq5itOW6LdbH70cJPWyM75XW5i1ENzfhRaWZOCBo0fKRXD4OZQ2CfpX",
    // token mobile start5
    // token: "dQu21wVlT7eXFjh0Q-cjfu:APA91bE9c9j6_Nlnfi1wPpNV1TYEqzc25rroB21AkcEMqZMdxZB2hQYu1mw1-EjZtgQHG0NmG8k-4D2twQqm4km2O7DvpKg5POXrS5PUciGh1gpzj2wmy1tjeP8flVs3RzfzRESr7sb9",
  };

  // Gửi thông báo
  getMessaging()
    .send(message)
    .then((response) => {
      res.status(200).json({
        message: "Successfully sent message",
        token: receivedToken,
      });
      console.log("Successfully sent message:", response);
    })
    .catch((error) => {
      res.status(400);
      res.send(error);
      console.log("Error sending message:", error);
    });
});
// webSocket 
// connect and send
// wss.on('connection', function connection(ws) {
//   const interval = setInterval(() => {
//     const message = JSON.stringify({
//       ten: 'Đối tượng 1',
//       ngayGui: new Date().toISOString(),
//       trangThai: Math.random() < 0.5 ? 'dungMau' : 'saiMau'
//     });
//     ws.send(message);
//   }, 1000);

//   ws.on('close', function close() {
//     clearInterval(interval);
//   });
// });
//start server
app.listen(3000, function () {
  console.log("Server started on port 3000");
});
