DROP DATABASE IF EXISTS De004;
CREATE DATABASE De004;
USE De004;

-- 1. Tạo 4 bảng Passengers , Routes , Buses, Tickets với đúng cấu trúc, kiểu dữ liệu, khóa chính, khóa ngoại 
CREATE TABLE Passengers (
	passenger_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    card_type VARCHAR(50) NOT NULL CHECK(card_type IN('Student', 'Elder', 'Normal', 'Prenium')),
    balance DECIMAL(10, 2) NOT NULL,
    join_date DATE NOT NULL
);
 
CREATE TABLE Routes (
	route_id VARCHAR(5) PRIMARY KEY,
    route_name VARCHAR(100) NOT NULL,
    start_point VARCHAR(100) NOT NULL,
    end_point VARCHAR(100) NOT NULL,
    distance DECIMAL(5, 2) NOT NULL CHECK(distance >= 0),
    base_fare DECIMAL(10, 2) NOT NULL CHECK(base_fare >= 0)
);

CREATE TABLE Buses (
	bus_id VARCHAR(5) PRIMARY KEY,
    plate_number VARCHAR(15) NOT NULL UNIQUE,
    route_id VARCHAR(5) NOT NULL,
    capacity INT NOT NULL CHECK(capacity >= 0),
    battery_level INT NOT NULL,
    FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);

-- 2. Thêm ràng buộc UNIQUE cho cặp (passenger_id, bus_id)
CREATE TABLE Tickets (
	ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    passenger_id VARCHAR(5) NOT NULL,
    bus_id VARCHAR(5) NOT NULL,
    tap_time DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL CHECK(status IN('Success', 'Failed', 'Pending')),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (bus_id) REFERENCES Buses(bus_id),
    UNIQUE(passenger_id, bus_id)
);

-- 3. Chèn dữ liệu 
INSERT INTO Passengers (passenger_id, full_name, phone, card_type, balance, join_date)
VALUES 
	('P01', 'Nguyễn Văn Hùng', '0911222333', 'Student', 50000, '2025-01-01'),
	('P02', 'Lê Thị Mai', '0988777666', 'Elder', 100000, '2025-02-10'),
	('P03', 'Trần Hoàng Long', '0905444333', 'Normal', 20000, '2025-03-05'),
	('P04', 'Phạm Thu Thảo', '0977111222', 'Student', 30000, '2025-04-15');

INSERT INTO Routes (route_id, route_name, start_point, end_point, distance, base_fare)
VALUES 
	('R01', 'Tuyến E01', 'Bến xe Mỹ Đình', 'Công viên Thống Nhất', 15.5, 7000),
	('R02', 'Tuyến E02', 'Hào Nam', 'Khu đô thị Ocean Park', 22.0, 9000),
	('R03', 'Tuyến E03', 'Sân bay Nội Bài', 'Cầu Giấy', 30.0, 15000);

INSERT INTO Buses (bus_id, plate_number, route_id, capacity, battery_level)
VALUES 
	('B01', '29E-001.01', 'R01', 45, 85),
	('B02', '29E-002.15', 'R02', 50, 40),
	('B03', '29E-003.09', 'R01', 45, 15);
	
 INSERT INTO Tickets (passenger_id, bus_id, tap_time, status)
 VALUES
	('P01', 'B01', '2025-11-10 07:15:00', 'Success'),
	('P02', 'B02', '2025-11-10 08:30:00', 'Success'),
	('P03', 'B01', '2025-11-11 17:45:00', 'Failed'),
	('P01', 'B03', '2025-11-12 06:00:00', 'Success');

-- 4. Tuyến 'R02' điều chỉnh giá vé cơ bản (base_fare) tăng thêm 10%
UPDATE Routes
SET base_fare = base_fare * 1.1
WHERE route_id = 'R02';

-- 5. Cập nhật card_type của hành khách 'P03' từ 'Normal' lên 'Premium' 
UPDATE Passengers 
SET card_type = 'Prenium'
WHERE passenger_id = 'P03';

-- 6. Xóa tất cả các giao dịch vé có trạng thái 'Failed'
DELETE FROM Tickets
WHERE status = 'Failed';

-- 7. Thêm ràng buộc cho cột battery_level: mức pin phải nằm trong khoảng từ 0 đến 100
ALTER TABLE Buses
MODIFY COLUMN battery_level INT NOT NULL CHECK(battery_level BETWEEN 0 AND 100);

-- 8. Thiết lập giá trị mặc định cho cột status trong bảng Tickets là 'Success'
ALTER TABLE Tickets
MODIFY COLUMN status VARCHAR(20) DEFAULT 'Success';

-- 9. Thêm cột gender (VARCHAR(10)) vào bảng Passengers sau khi tạo bảng
ALTER TABLE Passengers
ADD COLUMN gender VARCHAR(10) NOT NULL;

-- 10. Liệt kê tất cả các tuyến xe có khoảng cách (distance) lớn hơn 20km
SELECT * 
FROM Routes
WHERE distance > 20;

-- 11. Lấy thông tin full_name, phone của những hành khách có loại thẻ là 'Student'
SELECT full_name, phone 
FROM Passengers
WHERE card_type = 'Student';

-- 12. Hiển thị danh sách các xe buýt gồm bus_id, plate_number, battery_level, sắp xếp theo mức pin giảm dần.
SELECT bus_id, plate_number, battery_level
FROM Buses
ORDER BY battery_level DESC;

-- 13. Lấy ra 3 giao dịch vé (Tickets) mới nhất (dựa trên tap_time)
SELECT * 
FROM Tickets
ORDER BY tap_time DESC
LIMIT 3;

-- 14. Hiển thị route_name, base_fare từ bảng Routes, bỏ qua tuyến đầu tiên và lấy 2 tuyến tiếp theo
SELECT route_name, base_fare 
FROM Routes
LIMIT 2 OFFSET 1;

-- 15. Giảm 50% giá vé cơ bản (base_fare) cho tất cả các tuyến có điểm bắt đầu là 'Hào Nam'
UPDATE Routes
SET base_fare = base_fare * 0.5
WHERE start_point = 'Hào Nam';

-- 16. Chuyển đổi toàn bộ start_point và end_point trong bảng Routes thành chữ in hoa.
UPDATE Routes
SET 
	start_point = UPPER(start_point),
	end_point = UPPER(end_point);

-- 17. Xóa các xe buýt có mức pin bằng 0 (nếu có) và xử lý ràng buộc khóa ngoại
DELETE FROM Buses
WHERE battery_level = 0;

-- 18. Hiển thị ticket_id, full_name (hành khách), plate_number (xe buýt), route_name của các giao dịch vé thành công
SELECT t.ticket_id, p.full_name, b.plate_number, r.route_name
FROM Tickets AS t
INNER JOIN Passengers AS p
ON t.passenger_id = p.passenger_id
INNER JOIN Buses AS b
ON t.bus_id = b.bus_id 
INNER JOIN Routes AS r
ON b.route_id = r.route_id
WHERE t.status = 'Success';

-- 19. Liệt kê tất cả các tuyến đường (route_name) và số lượng xe buýt hiện đang chạy trên tuyến đó. Hiển thị cả những tuyến chưa có xe nào
SELECT r.route_name, COUNT(bus_id) AS Amount
FROM Routes AS r
LEFT JOIN Buses AS b
ON r.route_id = b.route_id
GROUP BY route_name;

-- 20. Tính tổng số tiền mà mỗi hành khách đã chi tiêu cho việc đi xe buýt (dựa trên base_fare của tuyến mà xe đó chạy)
-- SELECT full_name, (SELECT SUM(base_fare) FROM Routes) AS Amount
-- FROM Passengers 
-- GROUP BY full_name, Amount;

-- 21. Thống kê số lượt đi xe của mỗi hành khách. Chỉ hiển thị những hành khách đã đi từ 2 lượt trở lên
SELECT full_name, COUNT(ticket_id) AS Amount
FROM Passengers AS p
INNER JOIN Tickets AS t
ON p.passenger_id = t.passenger_id
GROUP BY full_name
HAVING Amount >= 2;

-- 22. Lấy thông tin các tuyến xe có giá vé cơ bản cao hơn mức giá vé trung bình của tất cả các tuyến
SELECT *
FROM Routes
WHERE base_fare > (
	SELECT AVG(base_fare) 
    FROM Routes
);

-- 23. Hiển thị danh sách hành khách (full_name) đã từng đi trên xe có biển số '29E-001.01'
SELECT full_name 
FROM Passengers AS p
INNER JOIN Tickets AS t
ON p.passenger_id = t.passenger_id
WHERE bus_id = (
	SELECT bus_id 
    FROM Buses 
    WHERE plate_number = '29E-001.01'
);

-- 24. Liệt kê các xe buýt có mức pin dưới 20% và tên tuyến tương ứng để yêu cầu sạc điện
SELECT bus_id, route_name
FROM Buses AS b
INNER JOIN Routes AS r
ON b.route_id = r.route_id
WHERE battery_level < 20;

-- 25. Tìm tuyến xe có lượt hành khách quẹt thẻ nhiều nhất
SELECT r.route_name, COUNT(t.ticket_id) AS Amount
FROM Routes r
JOIN Buses b ON r.route_id = b.route_id
JOIN Tickets t ON b.bus_id = t.bus_id
GROUP BY r.route_name
ORDER BY Amount DESC
LIMIT 1;