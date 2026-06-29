-- 员工部门表 - 初始化
-- 用于第 1 周 SQL 基础练习

CREATE DATABASE IF NOT EXISTS sql_practice DEFAULT CHARSET utf8mb4;
USE sql_practice;

-- 部门表
DROP TABLE IF EXISTS emp;
DROP TABLE IF EXISTS dept;

CREATE TABLE dept (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL COMMENT '部门名称',
    location VARCHAR(100) COMMENT '办公地点'
) ENGINE=InnoDB;

-- 员工表
CREATE TABLE emp (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL COMMENT '员工姓名',
    dept_id INT COMMENT '部门ID',
    salary DECIMAL(10, 2) COMMENT '工资',
    hire_date DATE COMMENT '入职日期',
    manager_id INT COMMENT '上级ID',
    FOREIGN KEY (dept_id) REFERENCES dept(id),
    FOREIGN KEY (manager_id) REFERENCES emp(id)
) ENGINE=InnoDB;

-- 插入部门数据
INSERT INTO dept (id, name, location) VALUES
(1, '技术部', '北京'),
(2, '市场部', '上海'),
(3, '财务部', '北京'),
(4, '人事部', '广州'),
(5, '客服部', '深圳');

-- 插入员工数据
INSERT INTO emp (id, name, dept_id, salary, hire_date, manager_id) VALUES
(1, '张三', 1, 25000, '2020-03-15', NULL),
(2, '李四', 1, 18000, '2021-06-01', 1),
(3, '王五', 2, 15000, '2022-01-10', NULL),
(4, '赵六', 2, 12000, '2022-08-20', 3),
(5, '钱七', 3, 20000, '2021-04-12', NULL),
(6, '孙八', 1, 9000,  '2023-02-28', 2),
(7, '周九', 4, 11000, '2022-11-05', NULL),
(8, '吴十', 5, 8000,  '2023-07-15', NULL),
(9, '郑大', 5, 7500,  '2024-01-20', 8),
(10, '冯二', 3, 9500,  '2023-09-01', 5),
(11, '陈三', NULL, 6000, '2024-06-10', NULL),
(12, '刘四', 4, 13000, '2021-12-01', 7);

-- 验证数据
SELECT 'dept' as tbl, COUNT(*) as cnt FROM dept
UNION ALL
SELECT 'emp', COUNT(*) FROM emp;
