# 第 10 周：锁与死锁

## Day 1-3：InnoDB 锁类型

### 行锁（Record Lock）
- 锁住索引记录
- 必须在索引字段上才会生效
- 不通过索引条件更新 → 表锁

```sql
-- 走索引，锁行
SELECT * FROM products WHERE id = 1 FOR UPDATE;

-- 不走索引，锁表（很危险）
SELECT * FROM products WHERE name = 'iphone' FOR UPDATE;
-- name 没有索引时，InnoDB 需要扫全表，锁全表记录
```

### 间隙锁（Gap Lock）
- 锁住两个索引记录之间的间隙
- 防止幻读
- 只在 REPEATABLE READ 级别存在

```sql
-- 间隙锁示例
-- session A
BEGIN;
SELECT * FROM products WHERE price BETWEEN 100 AND 200 FOR UPDATE;

-- session B（被阻塞）
INSERT INTO products(price) VALUES(150);
-- 间隙锁阻止了在 (100, 200) 范围内插入新行
```

### 临键锁（Next-Key Lock）
- 行锁 + 间隙锁 = 临键锁
- InnoDB REPEATABLE READ 级别的默认锁机制

### 意向锁
- 表级标记："有人要锁行"
- 意向共享锁(IS) + 意向排他锁(IX)
- 作用：快速判断表上是否有行锁

---

## Day 4-6：死锁分析

### 死锁产生的四个条件
1. 互斥：资源一次只能被一个事务占用
2. 请求与保持：事务持有锁，同时请求其他锁
3. 不可剥夺：锁只能由持有者释放
4. 循环等待：两个事务互相等待对方的锁

### 故意制造死锁
```sql
-- session A
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
-- 别提交
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- session B（同时执行）
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 2;
-- 别提交
UPDATE accounts SET balance = balance + 100 WHERE id = 1;
-- 死锁！
```

### 排查死锁
```sql
SHOW ENGINE INNODB STATUS\G
-- 看 LATEST DETECTED DEADLOCK 部分
-- 关注：哪个事务被回滚了、什么锁冲突了
```

### 如何避免死锁
1. **固定访问顺序**：所有事务按相同顺序更新表
2. **缩短事务**：事务里只做必要的操作
3. **降低隔离级别**：READ COMMITTED 没有间隙锁
4. **合理设置超时**：`innodb_lock_wait_timeout = 5`

---

## Day 7：事务最佳实践

```sql
-- 好的做法
BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  -- 只做数据库操作
COMMIT;

-- 坏的做法
BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  -- 调用外部 HTTP API（网络延迟 = 事务过长）
  -- 等待用户输入（用户去吃饭了 = 锁一直不释放）
COMMIT;
```

### 练习
1. 制造死锁场景，记录 SHOW ENGINE INNODB STATUS 输出
2. 分析输出，找出哪个事务被回滚
3. 写一份死锁分析报告到 `exercises/deadlock_report.md`

## 检查清单
- [ ] 理解行锁、间隙锁、临键锁的区别
- [ ] 知道为什么 WHERE 条件不走索引会导致锁表
- [ ] 能主动制造死锁并分析
- [ ] 知道防止死锁的常见方法