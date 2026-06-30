-- 第 5 周参考答案

-- 练习 1：
-- 问题：第一范式违反（customer_info 和 products 列不可分）
-- 改进：
CREATE TABLE orders_fixed (
    id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    customer_address VARCHAR(200),
    customer_phone VARCHAR(20),
    created_at DATETIME
);

CREATE TABLE order_products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_name VARCHAR(100),
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders_fixed(id)
);

-- 练习 2：
-- 问题：第二范式违反（teacher_name, teacher_phone 部分依赖 course_name，不依赖 student_name）
-- 改进：
CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    teacher_name VARCHAR(50),
    teacher_phone VARCHAR(20)
);

CREATE TABLE student_courses_fixed (
    student_id INT,
    course_id INT,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- 练习 3：
-- 核心表结构：
-- users(id, username)
-- posts(id, title, content, user_id, created_at)  FOREIGN KEY user_id
-- favorites(user_id, post_id)  PRIMARY KEY (user_id, post_id)
-- follows(follower_id, followee_id)  PRIMARY KEY (follower_id, followee_id)
--         CHECK (follower_id != followee_id)