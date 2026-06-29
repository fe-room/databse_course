# 第 7 周：索引原理

## Day 1-2：B+ Tree 索引

### 学习内容
- B+ Tree 结构：非叶子节点存指针，叶子节点存数据
- 为什么用 B+ Tree 而不是二叉树：磁盘 IO 次数少（3-4 层即可存上亿数据）
- 聚簇索引（InnoDB）：主键索引的叶子节点存整行数据
- 二级索引：叶子节点存主键值，需要回表查询
- 为什么主键推荐自增 INT：避免页分裂

### 先跑个实验
```sql
-- 建两个表：一个自增主键，一个 UUID 主键
-- 各插入 100 万行
-- 对比插入性能和数据文件大小
```

---

## Day 3-4：索引类型

### 学习内容
| 索引类型 | 特点 |
|---------|------|
| 主键索引 | 聚簇索引，每表一个 |
| 唯一索引 | 索引值唯一，可 NULL |
| 普通索引 | 允许重复 |
| 联合索引 | 多字段组合，最左前缀原则 |
| 全文索引 | 用于 LIKE 全文搜索的替代 |
| 覆盖索引 | 索引包含所有查询字段，无需回表 |

### 最左前缀原则
```sql
-- 联合索引 (a, b, c)
WHERE a = 1                  -- 能用
WHERE a = 1 AND b = 2        -- 能用
WHERE a = 1 AND c = 3        -- 只能用 a 部分
WHERE b = 2                  -- 无法使用
```

### 练习
在博客系统 posts 表上加联合索引 (category_id, created_at)：
- 测试哪些查询能用上这个索引
- 哪些用不上（违反最左前缀）
- 哪些可以实现覆盖索引

---

## Day 5-7：EXPLAIN 解读

### 学习内容
```
EXPLAIN SELECT * FROM posts WHERE category_id = 1\G

关键字段：
  type       → 访问类型（性能从好到差）
               system > const > eq_ref > ref > range > index > ALL
  key        → 实际使用的索引
  rows       → 估算扫描行数
  Extra      → 额外信息

Extra 重要值：
  Using index        → 覆盖索引，好
  Using where        → 索引后过滤
  Using filesort     → 额外排序，性能差
  Using temporary    → 用了临时表，性能差
  Using index condition → 索引下推
```

### 练习
```sql
-- 找一条 type=ALL 的查询
EXPLAIN SELECT * FROM posts WHERE content LIKE '%keyword%';

-- 加索引后改成 type=ref 或 range
-- 观察 Extra: Using filesort 的查询，加索引消除排序
SELECT * FROM posts WHERE category_id = 1 ORDER BY created_at DESC;
```

## 检查清单
- [ ] 理解 B+ Tree 的基本结构
- [ ] 知道联合索引的最左前缀原则
- [ ] 能看懂 EXPLAIN 输出
- [ ] 能从 Extra 字段判断查询是否高效