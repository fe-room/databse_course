# 第 6 周：电商系统设计

## 需求描述

设计一个电商下单系统的数据库。

**业务规则：**
- 用户可以在平台浏览商品
- 用户可以将商品加入购物车
- 用户可以下单，一个订单包含多个商品
- 下单时需要扣减库存
- 支付后更新订单状态
- 不能超卖（多人同时买同一商品）

---

## Day 1-3：数据库设计

### 需要设计的表

| 表名 | 说明 | 核心字段 |
|------|------|---------|
| users | 用户 | id, username, email |
| products | 商品 | id, name, price, category_id |
| product_stock | 库存 | product_id, quantity, version |
| carts | 购物车 | id, user_id, created_at |
| cart_items | 购物车项 | cart_id, product_id, quantity |
| orders | 订单 | id, user_id, status, total_amount, created_at |
| order_items | 订单项 | order_id, product_id, quantity, price |
| payments | 支付记录 | id, order_id, amount, status, paid_at |

### 要求
1. 画 ER 图
2. 写出完整 DDL（含索引、约束、默认值）

---

## Day 4-7：核心难点 — 高并发库存扣减

### 三种方案实现

**方案 A：事务 + SELECT FOR UPDATE**
```sql
BEGIN;
SELECT quantity FROM product_stock WHERE product_id = 1 FOR UPDATE;
-- 检查 quantity > 0
UPDATE product_stock SET quantity = quantity - 1 WHERE product_id = 1;
INSERT INTO order_items(order_id, product_id, quantity, price) VALUES (...);
COMMIT;
```

**方案 B：乐观锁（version 字段）**
```sql
UPDATE product_stock SET quantity = quantity - 1, version = version + 1
WHERE product_id = 1 AND version = ?;
-- 如果影响行数为 0，说明并发冲突，重试
```

**方案 C：Redis 原子操作**
```python
# 库存存在 Redis
decr_result = redis.decr('stock:1')
if decr_result < 0:
    redis.incr('stock:1')  # 回滚
    return "库存不足"
# 再异步同步到 MySQL
```

### 练习
三种方案都写 SQL/代码实现，对比优缺点。

### 产出
完整电商数据库设计文档 + DDL 保存到 `exercises/ecommerce.sql`

## 检查清单
- [ ] 完成 ER 图 + DDL
- [ ] 实现库存扣减的三种方案
- [ ] 理解 FOR UPDATE 和乐观锁的区别
- [ ] 知道分布式场景下 Redis 扣库存的方案
