USE master;
GO
ALTER DATABASE SalesCo SET MULTI_USER WITH ROLLBACK IMMEDIATE;
GO
USE SalesCo;
GO
DROP TABLE IF EXISTS LINE;
DROP TABLE IF EXISTS PRODUCT;
DROP TABLE IF EXISTS VENDOR;
DROP TABLE IF EXISTS INVOICE;
DROP TABLE IF EXISTS CUSTOMER;
DROP TABLE IF EXISTS CUSTOMER2;
CREATE TABLE CUSTOMER (
    Cus_code VARCHAR(10),
    Cust_LName VARCHAR(20),
    Cust_FName VARCHAR(20),
    Cust_initial VARCHAR(5),
    Cus_AreaCode VARCHAR(5),
    Cus_phone VARCHAR(15),
    Cus_Balance DECIMAL(10,2)
);
CREATE TABLE INVOICE (
    Inv_number VARCHAR(10),
    Cus_code VARCHAR(10),
    Inv_Date DATE
);
CREATE TABLE VENDOR (
    V_Code VARCHAR(10),
    V_Name VARCHAR(50),
    V_Contact VARCHAR(50),
    V_AreaCode VARCHAR(5),
    V_Phone VARCHAR(15),
    V_State VARCHAR(5),
    V_order CHAR(1)
);
CREATE TABLE PRODUCT (
    P_Code VARCHAR(10),
    P_Descript VARCHAR(50),
    P_InDate DATE,
    P_QOH INT,
    P_MIN INT,
    P_Price DECIMAL(10,2),
    P_Discount DECIMAL(5,2),
    V_Code VARCHAR(10)
);

CREATE TABLE LINE (
    Inv_number VARCHAR(10),
    Line_number INT,
    P_Code VARCHAR(10),
    Line_Units INT,
    Line_Price DECIMAL(10,2)
);

CREATE TABLE CUSTOMER2 (
    CUS_CODE VARCHAR(10),
    CUS_LNAME VARCHAR(20),
    CUS_FNAME VARCHAR(20),
    CUS_INITIAL VARCHAR(5),
    CUS_AREACODE VARCHAR(5),
    CUS_PHONE VARCHAR(15),
    CUS_BALANCE DECIMAL(10,2)
);
INSERT INTO CUSTOMER VALUES
('C001','Sharma','Rahul','K','011','12345678',150.75),
('C002','Patel','Neha','R','022','87654321',0.00),
('C003','Reddy','Arjun',NULL,'080','11223344',200.50);
INSERT INTO INVOICE VALUES
('I001','C001','2024-05-01'),
('I002','C002','2024-05-02'),
('I003','C003','2024-05-03');
INSERT INTO VENDOR VALUES
('V001','TechSolutions','Amit Verma','011','5551111','DL','Y'),
('V002','OfficeMart','Priya Nair','022','5552222','MH','Y'),
('V003','Global Traders','Rajesh Kumar','080','5553333','KA','N');
INSERT INTO PRODUCT VALUES
('P001','Laptop','2024-01-10',10,2,800.00,0.10,'V001'),
('P002','Mouse','2024-02-15',50,10,25.00,0.05,'V002'),
('P003','Keyboard','2024-03-01',30,5,45.00,0.07,'V002'),
('P004','Monitor','2024-01-20',20,3,200.00,0.08,'V001');
INSERT INTO LINE VALUES
('I001',1,'P001',1,800.00),
('I001',2,'P002',2,25.00),
('I002',1,'P003',1,45.00),
('I003',1,'P002',3,25.00),
('I003',2,'P004',2,200.00);
INSERT INTO CUSTOMER2 VALUES
('10010','Ramas','Alfred','A','615','844-2573',0.00),
('10011','Dunne','Leona','K','713','894-1238',0.00),
('10012','Smith','Kathy','W','615','894-2285',345.86),
('10013','Olowski','Paul','F','615','894-2180',536.75),
('10014','Orlando','Myron',NULL,'615','222-1672',0.00),
('10015','O''Brian','Amy','B','713','442-3381',0.00),
('10016','Brown','James','G','615','297-1228',221.19),
('10017','Williams','George',NULL,'615','290-2556',768.93);
SELECT * FROM CUSTOMER;
SELECT * FROM INVOICE;
SELECT * FROM VENDOR;
SELECT * FROM PRODUCT;
SELECT * FROM LINE;
SELECT * FROM CUSTOMER2;
SELECT Inv_number, Cus_code, Inv_Date FROM INVOICE WHERE 1=0;
SELECT V_Code, V_Name, V_Contact, V_AreaCode, V_Phone, V_State, V_order
FROM VENDOR WHERE 1=0;
SELECT P_Code, P_Descript, P_InDate, P_QOH, P_MIN, P_Price, P_Discount, V_Code
FROM PRODUCT WHERE 1=0;
SELECT Inv_number, Line_number, P_Code, Line_Units, Line_Price
FROM LINE WHERE 1=0;

SELECT Inv_number,
       SUM(Line_Units * Line_Price) AS TotalAmount
FROM LINE
GROUP BY Inv_number;

SELECT COUNT(*) AS NumOfCustomers
FROM CUSTOMER
WHERE Cus_Balance > 500;

SELECT p.P_Code, p.P_Descript, p.P_Price
FROM PRODUCT p
JOIN VENDOR v ON p.V_Code = v.V_Code
WHERE v.V_State = 'FL';

SELECT Cus_code,
       Cust_FName + ' ' + Cust_LName AS FullName
FROM CUSTOMER
WHERE Cus_Balance = 0;

SELECT c.Cus_code,
       SUM(l.Line_Units * l.Line_Price) AS TotalPurchase
FROM CUSTOMER c
JOIN INVOICE i ON c.Cus_code = i.Cus_code
JOIN LINE l ON i.Inv_number = l.Inv_number
GROUP BY c.Cus_code;

SELECT P_Code, P_Descript
FROM PRODUCT
WHERE P_Discount > 0;

SELECT i.Cus_code,
       i.Inv_number,
       p.P_Descript,
       l.Line_Units AS [Units Bought],
       l.Line_Price AS [Unit Price],
       (l.Line_Units * l.Line_Price) AS Subtotal
FROM INVOICE i
JOIN LINE l ON i.Inv_number = l.Inv_number
JOIN PRODUCT p ON l.P_Code = p.P_Code
ORDER BY i.Cus_code, i.Inv_number;

SELECT DISTINCT p.*
FROM PRODUCT p
JOIN LINE l ON p.P_Code = l.P_Code
JOIN INVOICE i ON l.Inv_number = i.Inv_number
WHERE YEAR(i.Inv_Date) = 2015;

SELECT Cus_code,
       Cust_FName + ' ' + Cust_LName AS FullName,
       Cus_phone
FROM CUSTOMER
WHERE Cus_AreaCode = '615';