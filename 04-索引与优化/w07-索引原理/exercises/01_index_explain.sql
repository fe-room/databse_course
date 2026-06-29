-- 第 7 周：索引与 EXPLAIN 练习
USE blog;  -- 使用第 3 周的博客数据库（先灌 10 万行数据）

-- 练习 1：查看不同查询的 EXPLAIN 计划

-- 1.1 没有索引的查询
EXPLAIN SELECT * FROM posts WHERE content LIKE '%keyword%';

-- 1.2 主键查询
EXPLAIN SELECT * FROM posts WHERE id = 1;

-- 1.3 外键查询
EXPLAIN SELECT * FROM posts WHERE user_id = 1;

-- 1.4 排序查询
EXPLAIN SELECT * FROM posts ORDER BY created_at DESC;

-- 练习 2：联合索引测试
-- 假设有联合索引 (category_id, created_at)

-- 2.1 能用到索引吗？
EXPLAIN SELECT * FROM posts WHERE category_id = 1;

-- 2.2 能用到索引吗？
EXPLAIN SELECT * FROM posts ORDER BY created_at;

-- 2.3 能用到索引吗？
EXPLAIN SELECT * FROM posts WHERE category_id = 1 ORDER BY created_at;

-- 2.4 能用到索引吗？为什么？
EXPLAIN SELECT * FROM posts WHERE created_at > '2026-01-01';

-- 练习 3：覆盖索引
-- 3.1 这个查询是否会回表？
EXPLAIN SELECT id, category_id, created_at FROM posts WHERE category_id = 1;

-- 对比
EXPLAIN SELECT * FROM posts WHERE category_id = 1;
