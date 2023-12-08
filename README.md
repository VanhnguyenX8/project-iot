## HỆ THỐNG IOT
# Mô tả
nhận diện và thống kê sản phẩm lỗi khi đi qua cảm biến màu
# Cách chạy
- đối với server : cd vào thư mục server => chạy: npm start
- đối với mobile : cd vào thư mục notifitions => chạy: flutter run
- đối với web:
- đối với andruino: 
## SQL
CREATE TABLE iot (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(50),
    time_present DATETIME,
    is_error BOOLEAN
);