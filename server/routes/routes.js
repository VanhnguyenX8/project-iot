import express from 'express';
import * as authController from '../controllers/controllers.js';
const router = express.Router();
router.get('/users', authController.users);
router.get('/all_product', authController.allProduct);
router.post('/import_product', authController.importProduct);
// router.get('/', (req, res) => {
//     return res.json({Status: "success"});
// });

export default router;