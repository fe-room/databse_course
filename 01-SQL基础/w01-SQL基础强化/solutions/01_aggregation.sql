-- 参考答案：Day 1-2 聚合与分组
USE sql_practice;

-- 1. 统计公司总员工数、平均工资
SELECT COUNT(*) AS 总人数, AVG(salary) AS 平均工资
FROM emp;

-- 2. 每个部门的平均工资
SELECT d.name AS 部门名, AVG(e.salary) AS 平均工资
FROM emp e
JOIN dept d ON e.dept_id = d.id
GROUP BY d.id, d.name;

-- 3. 平均工资高于 8000 的部门
SELECT d.name AS 部门名, AVG(e.salary) AS 平均工资
FROM emp e
JOIN dept d ON e.dept_id = d.id
GROUP BY d.id, d.name
HAVING 平均工资 > 8000;

-- 4. 每个部门工资 > 8000 的人数
SELECT d.name AS 部门名, COUNT(*) AS 人数
FROM emp e
JOIN dept d ON e.dept_id = d.id
WHERE e.salary > 8000
GROUP BY d.id, d.name;

-- 5. 每个部门最高工资和最低工资
SELECT d.name AS 部门名, MAX(e.salary) AS 最高工资, MIN(e.salary) AS 最低工资
FROM emp e
JOIN dept d ON e.dept_id = d.id
GROUP BY d.id, d.name;

-- 6. 统计各部门人数，按人数降序排列
SELECT d.name AS 部门名, COUNT(*) AS 人数
FROM emp e
JOIN dept d ON e.dept_id = d.id
GROUP BY d.id, d.name
ORDER BY 人数 DESC;

-- 7. 统计每个部门 2022 年之后入职的人数
SELECT d.name AS 部门名, COUNT(*) AS 人数
FROM emp e
JOIN dept d ON e.dept_id = d.id
WHERE e.hire_date >= '2022-01-01'
GROUP BY d.id, d.name;

-- 8. 查询公司总月薪支出
SELECT SUM(salary) AS 总月薪支出 FROM emp;
