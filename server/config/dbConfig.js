import mysql from 'mysql';

const db = mysql.createConnection({
    // host: process.env.DB_HOST,
    // user: process.env.DB_USER,
    // password: process.env.DB_PASSWORD,
    // database: process.env.DB_NAME,
    host: "localhost",
    user: "root",
    password: "Vietanh.237",
    database: "login",
});

export default db;