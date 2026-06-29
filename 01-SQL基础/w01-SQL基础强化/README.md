# 第 1 周：SQL 基础强化

## Day 1-2：聚合与分组

### 学习内容
- COUNT, SUM, AVG, MAX, MIN
- GROUP BY + 多字段分组
- HAVING vs WHERE 的区别（WHERE 在分组前过滤，HAVING 在分组后过滤）

### 先建表
执行 `exercises/01_setup.sql` 创建员工部门表。

### 练习
在 `exercises/01_aggregation.sql` 中完成以下查询：

```sql
-- 1. 统计公司总员工数、平均工资
-- 2. 每个部门的平均工资
-- 3. 平均工资高于 5000 的部门（HAVING）
-- 4. 每个部门 salary > 3000 的人数
-- 5. 每个部门最高工资和最低工资
```

完成后对照 `solutions/01_aggregation.sql` 检查。

---

## Day 3-4：多表连接

### 学习内容
- INNER JOIN, LEFT JOIN, RIGHT JOIN
- 多表关联（3 表以上）
- 自连接

### 练习
执行 `exercises/02_join.sql` 中的练习：

```sql
-- 1. 查每个员工姓名 + 部门名（INNER JOIN）
-- 2. 查没有员工的部门（LEFT JOIN + IS NULL）
-- 3. 查工资高于同部门平均工资的员工（自连接）
-- 4. 查员工及其经理（假设 emp 有 manager_id，自连接）
```

---

## Day 5：子查询

### 学习内容
- WHERE 子查询（IN, EXISTS, ANY, ALL）
- FROM 子查询（派生表）
- SELECT 子查询（标量子查询）
- EXISTS vs IN 性能差异

### 练习
```sql
-- 1. 查工资高于公司平均的员工（标量子查询）
-- 2. 查有订单的客户（EXISTS）
-- 3. 查每个部门工资最高的员工（FROM 子查询）
```

---

## Day 6-7：CASE WHEN + UNION + 综合练习

### 学习内容
- CASE WHEN 做条件判断
- UNION / UNION ALL 合并结果

### 综合练习
```sql
-- 设计一个订单查询报表：
-- 按月份统计：总订单数、总收入、取消订单数
-- 用 CASE WHEN 标记订单金额区间（低/中/高）
-- 用 UNION 合并本年与去年数据
```

## 检查清单
- [ ] 能写出带 GROUP BY + HAVING 的查询
- [ ] 理解 LEFT JOIN 和 INNER JOIN 的区别
- [ ] 能用子查询解决"查最高/最低"类问题
- [ ] 会用 CASE WHEN 做条件分类
