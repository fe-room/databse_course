-- 参考答案：电商系统建表
CREATE DATABASE IF NOT EXISTS ecommerce DEFAULT CHARSET utf8mb4;
USE ecommerce;

-- 用户表
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 商品表
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) NOT NULL COMMENT '单价(分)',
    category_id INT DEFAULT NULL,
    status TINYINT NOT NULL DEFAULT 1 COMMENT '1=上架 0=下架',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category (category_id),
    INDEX idx_status (status)
) ENGINE=InnoDB;

-- 商品库存表
CREATE TABLE product_stock (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL UNIQUE,
    quantity INT NOT NULL DEFAULT 0 COMMENT '库存数量',
    version INT NOT NULL DEFAULT 0 COMMENT '乐观锁版本号',
    FOREIGN KEY (product_id) REFERENCES products(id)
) ENGINE=InnoDB;

-- 购物车表
CREATE TABLE carts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE COMMENT '一个用户只有一个购物车',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB;

-- 购物车项表
CREATE TABLE cart_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id),
    UNIQUE KEY uk_cart_product (cart_id, product_id)
) ENGINE=InnoDB;

-- 订单表
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    status TINYINT NOT NULL DEFAULT 0 COMMENT '0=待支付 1=已支付 2=已发货 3=已完成 4=已取消',
    total_amount DECIMAL(10, 2) NOT NULL COMMENT '总金额',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_user (user_id),
    INDEX idx_status (status)
) ENGINE=InnoDB;

-- 订单项表
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL COMMENT '下单时的单价',
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id),
    INDEX idx_order (order_id)
) ENGINE=InnoDB;

-- 支付记录表
CREATE TABLE payments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status TINYINT NOT NULL DEFAULT 0 COMMENT '0=未支付 1=支付成功 2=支付失败',
    paid_at DATETIME DEFAULT NULL COMMENT '支付时间',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    INDEX idx_order (order_id)
) ENGINE=InnoDB;

-- ============================================
-- 库存扣减 SQL

-- 方案 A：FOR UPDATE（悲观锁）
BEGIN;
SELECT quantity FROM product_stock WHERE product_id = 1 FOR UPDATE;
-- 检查 quantity > 需求数量
UPDATE product_stock SET quantity = quantity - 1 WHERE product_id = 1;
INSERT INTO order_items(order_id, product_id, quantity, price) VALUES (1, 1, 1, 100.00);
COMMIT;

-- 方案 B：乐观锁
UPDATE product_stock
SET quantity = quantity - 1, version = version + 1
WHERE product_id = 1 AND quantity >= 1 AND version = 0;
-- 检查受影响行数，为 0 表示版本冲突或库存不足，需重试
