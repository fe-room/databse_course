-- 第 7 周参考答案：索引与 EXPLAIN

-- 练习 1.1：没有索引 → type: ALL (全表扫描)
-- 练习 1.2：主键查询 → type: const
-- 练习 1.3：外键查询 → 有索引(type: ref) / 无索引(type: ALL)
-- 练习 1.4：排序 → 有索引(Using index) / 无索引(Using filesort)

-- 练习 2：联合索引 (category_id, created_at)
-- 2.1 WHERE category_id = 1 → 能用，type: ref
-- 2.2 ORDER BY created_at → 不能，违反最左前缀，type: ALL
-- 2.3 WHERE category_id = 1 ORDER BY created_at → 能用，Extra: Using index condition
-- 2.4 WHERE created_at > '2026-01-01' → 不能，跳过了最左列

-- 练习 3：覆盖索引
-- 3.1 SELECT id, category_id, created_at ... → Extra: Using index (覆盖索引，不回表)
-- 对比 SELECT * ... → 需要回表读取 content 等字段

-- 扩展：如何建索引
-- ALTER TABLE posts ADD INDEX idx_cat_created (category_id, created_at);