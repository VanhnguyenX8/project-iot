import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';
import express from 'express';
import cors from 'cors';
import http from 'http';
import admin from 'firebase-admin';
import authRoutes from './routes/routes.js';
import serviceAccount from '../server/notication-firebase-adminsdk-ewzzv-3cd6feafba.json' assert { type: 'json' };

// const serviceAccount = require('../server/notication-firebase-adminsdk-ewzzv-3cd6feafba.json');

// Khởi tạo ứng dụng Express
const app = express();
app.use(express.json());

// Thiết lập CORS
app.use(cors({
  origin: "*",
  methods: ["GET", "POST", "DELETE", "UPDATE", "PUT", "PATCH"],
}));
const server = http.createServer(app);
// Thiết lập Content-Type cho response
app.use(function (req, res, next) {
  res.setHeader("Content-Type", "application/json");
  next();
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
    token: "cSwStbQQTJSTSmZLsWFrC9:APA91bHsmXwkp8suS56yTbXoanwnZ5C14qXUoLt-CjKPIJxoRY7nEMhDnO9iMP_1xzCApRtItwA7UceO5OBEXFq5itOW6LdbH70cJPWyM75XW5i1ENzfhRaWZOCBo0fKRXD4OZQ2CfpX",
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

//start server
app.listen(3000, function () {
  console.log("Server started on port 3000");
});
