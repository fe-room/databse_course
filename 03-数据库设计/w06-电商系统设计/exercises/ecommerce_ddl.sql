-- 第 6 周实战：电商系统建表
-- 完成所有 DDL 定义

-- ============================================
-- 注意：
--   1. 先思考每张表需要什么索引
--   2. 思考外键的级联策略（CASCADE / SET NULL / RESTRICT）
--   3. DECIMAL 用于金额，不要用 FLOAT
-- ============================================

-- 用户表
CREATE TABLE users (
    -- 完善
);

-- 商品表
CREATE TABLE products (
    -- 完善
);

-- 商品库存表（含 version 做乐观锁）
CREATE TABLE product_stock (
    -- 完善
);

-- 购物车表
CREATE TABLE carts (
    -- 完善
);

-- 购物车项表
CREATE TABLE cart_items (
    -- 完善
);

-- 订单表
CREATE TABLE orders (
    -- 完善
);

-- 订单项表
CREATE TABLE order_items (
    -- 完善
);

-- 支付记录表
CREATE TABLE payments (
    -- 完善
);

-- ============================================
-- 高并发库存扣减

-- 方案 A：FOR UPDATE
-- BEGIN;
-- SELECT quantity FROM product_stock WHERE product_id = ? FOR UPDATE;
-- UPDATE product_stock SET quantity = quantity - ? WHERE product_id = ?;
-- INSERT INTO order_items(...) VALUES (...);
-- COMMIT;

-- 方案 B：乐观锁
-- UPDATE product_stock SET quantity = quantity - ?, version = version + 1
-- WHERE product_id = ? AND quantity >= ? AND version = ?;
