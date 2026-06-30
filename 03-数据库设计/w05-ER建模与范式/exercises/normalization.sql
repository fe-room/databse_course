-- 第 5 周练习：识别范式级别
-- 判断以下表设计违反了第几范式，并写出改进方案

-- 练习 1：找出问题
CREATE TABLE orders_bad (
    id INT PRIMARY KEY,
    customer_info VARCHAR(200),        -- 存 "张三,北京市朝阳区,13800138000"
    products VARCHAR(500),             -- 存 "iPhone(2部),iPad(1部)"
    created_at DATETIME
);
-- 问题：________________________________
-- 改进：________________________________


-- 练习 2：拆解到 3NF
CREATE TABLE student_courses (
    id INT PRIMARY KEY,
    student_name VARCHAR(50),
    course_name VARCHAR(50),
    teacher_name VARCHAR(50),
    teacher_phone VARCHAR(20)
);
-- 问题：________________________________
-- 改进：________________________________


-- 练习 3：设计一个简单的博客系统 ER 表
-- 需求：用户可以发文、收藏文章、关注其他用户
-- 画出 ER 图并在下方写出核心表结构