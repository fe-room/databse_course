# 第 8 周：慢查询优化

## Day 1-3：慢查询分析

### 配置慢查询日志
```sql
SET GLOBAL slow_query_log = ON;
SET GLOBAL long_query_time = 0.5;       -- 超过 0.5 秒记录
SET GLOBAL log_queries_not_using_indexes = ON;
```

### 灌数据
用存储过程往博客表灌 10 万行数据：
```sql
DELIMITER $$
CREATE PROCEDURE insert_mock_posts()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100000 DO
    INSERT INTO posts(title, content, category_id, user_id, created_at)
    VALUES (CONCAT('Post ', i), REPEAT('content ', 20),
            FLOOR(1 + RAND()*10), FLOOR(1 + RAND()*100),
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*365) DAY));
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;
CALL insert_mock_posts();
```

### 分析工具
```bash
# 查看慢查询日志
mysqldumpslow /var/lib/mysql/*-slow.log

# performance_schema 查看等待事件
SELECT * FROM performance_schema.events_statements_summary_by_digest
ORDER BY SUM_TIMER_WAIT DESC LIMIT 10;
```

---

## Day 4-7：5 个优化案例

### 案例 1：分页偏移大
```sql
-- 慢：越往后翻越慢
SELECT * FROM posts ORDER BY created_at DESC LIMIT 100000, 20;

-- 优化：游标分页
SELECT * FROM posts WHERE created_at < ? ORDER BY created_at DESC LIMIT 20;
```

### 案例 2：ORDER BY 不走索引
```sql
-- 有 filesort
SELECT * FROM posts WHERE category_id = 1 ORDER BY created_at DESC;
-- 优化：加联合索引 (category_id, created_at)
```

### 案例 3：COUNT(*) 慢
```sql
-- InnoDB 需要扫描行
SELECT COUNT(*) FROM posts WHERE category_id = 1;
-- 优化：用二级索引计数（COUNT 走小索引更快）
```

### 案例 4：OR 条件
```sql
-- OR 通常不走索引
SELECT * FROM posts WHERE title = 'abc' OR content = 'abc';
-- 优化：改成 UNION
SELECT * FROM posts WHERE title = 'abc'
UNION
SELECT * FROM posts WHERE content = 'abc';
```

### 案例 5：JOIN 大表
```sql
-- 确保连接字段有索引
-- 小表驱动大表
SELECT p.*, c.name
FROM posts p
LEFT JOIN categories c ON c.id = p.category_id; -- category_id 要有索引
```

### 产出物
在 `exercises/` 下写一份优化报告 `optimization_report.md`，包含：
- 优化前 SQL、执行时间、EXPLAIN 结果
- 优化方案
- 优化后 SQL、执行时间

## 检查清单
- [ ] 能配置和查看慢查询日志
- [ ] 掌握游标分页优化大偏移量查询
- [ ] 能为 ORDER BY 加合适的索引消除 filesort
- [ ] 记住 OR → UNION 的改写技巧
- [ ] 完成 5 个案例的优化报告