# 第 2 周：窗口函数与 CTE

## Day 1-2：窗口函数

### 学习内容
- ROW_NUMBER(), RANK(), DENSE_RANK() — 排名
- LAG(), LEAD() — 前后行引用
- SUM() OVER(PARTITION BY ... ORDER BY ...) — 累计求和
- 窗口 vs GROUP BY 的区别：窗口不减少行数

### 练习
```sql
-- 1. 每个部门按工资从高到低排名（ROW_NUMBER）
-- 2. 每个部门工资最高的员工（RANK）
-- 3. 查每个员工与同部门最高工资的差距（MAX OVER PARTITION BY）
-- 4. 每个部门工资排前 2 的员工（DENSE_RANK）
-- 5. 按工资从高到低排序，计算累计工资占比
```

---

## Day 3-4：CTE (Common Table Expressions)

### 学习内容
- WITH ... AS 基本用法
- 多个 CTE 串联
- 递归 CTE

### 练习
```sql
-- 1. 用 CTE 简化复杂子查询
-- 2. 递归查组织架构树（员工-经理层级）
-- 3. 生成一个日期序列做报表补零
```

---

## Day 5-7：实战项目 — SQL 查询工具箱 CLI

用你熟悉的语言写一个命令行工具：

**功能要求：**
- 连接 MySQL，执行传入的 SQL 文件
- 支持输出格式：表格 / CSV
- 支持超时控制
- 错误处理（SQL 语法错误提示）

**示例用法：**
```bash
cd code && npm install
node query.js -f query.sql -o table
node query.js -f query.sql -o csv
```

## 检查清单
- [ ] 能写出 ROW_NUMBER 排名查询
- [ ] 会使用 LAG/LEAD 做前后行比较
- [ ] 能用 CTE 简化嵌套子查询
- [ ] 完成 CLI 工具并跑通
