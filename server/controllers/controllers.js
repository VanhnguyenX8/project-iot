import db from '../config/dbConfig.js';
export const users = (req, res) => {
    const sql = "SELECT id, name, email FROM login";
    db.query(sql, (err, data) => {
        if (err) return res.status(404).json({ Error: "loi lenh query" });
        if (data.length > 0) {
            return res.status(200).json(data);

        } else {
            return res.status(404).json({ Error: "Khong co user nao" });
        }
    })
};
export const allProduct = (req, res) => {
    const sql = "SELECT * FROM iot";
    db.query(sql, (err, data) => {
        if (err) return res.status(404).json({ Error: "SQL eror" });
        if (data.length > 0) {
            return res.status(200).json(data);

        } else {
            return res.status(404).json({ Error: "Data empty" });
        }
    })
};
const currentTime = new Date(); // Lấy thời gian hiện tại

const year = currentTime.getFullYear();
const month = String(currentTime.getMonth() + 1).padStart(2, '0');
const day = String(currentTime.getDate()).padStart(2, '0');
const hours = String(currentTime.getHours()).padStart(2, '0');
const minutes = String(currentTime.getMinutes()).padStart(2, '0');
const seconds = String(currentTime.getSeconds()).padStart(2, '0');
export const importProduct = (req, res) => {
    const formattedTime = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    const values = [
        req.body.userName,
        // formattedTime,
        // Boolean(req.body.is_error),
    ]
    console.log('\n' +   req.body.user_name)
    const query = 'INSERT INTO iot (user_name) VALUES (?)';
    db.query(query, [values], (err, result) => {
        if (err) return res.status(500).json({ Error: "loi khi dang ky" });
        return res.status(200).json({ Status: "Success" });
    })
};