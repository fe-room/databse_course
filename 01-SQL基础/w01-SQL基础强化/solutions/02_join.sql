-- 参考答案：Day 3-4 多表连接
USE sql_practice;

-- 1. 查每个员工姓名 + 部门名（INNER JOIN）
SELECT e.name AS 员工, d.name AS 部门
FROM emp e
JOIN dept d ON e.dept_id = d.id;

-- 2. 查没有员工的部门（LEFT JOIN + IS NULL）
SELECT d.name AS 部门名
FROM dept d
LEFT JOIN emp e ON e.dept_id = d.id
WHERE e.id IS NULL;

-- 3. 查每个部门工资高于部门平均工资的员工
SELECT e.name AS 员工, e.salary AS 工资, d.name AS 部门
FROM emp e
JOIN dept d ON e.dept_id = d.id
JOIN (
    SELECT dept_id, AVG(salary) AS avg_salary
    FROM emp
    WHERE dept_id IS NOT NULL
    GROUP BY dept_id
) dept_avg ON e.dept_id = dept_avg.dept_id
WHERE e.salary > dept_avg.avg_salary;

-- 4. 查每个员工的姓名和他们的经理姓名（自连接）
SELECT e.name AS 员工, m.name AS 经理
FROM emp e
LEFT JOIN emp m ON e.manager_id = m.id;

-- 5. 查所有部门及其员工数（包括没有员工的部门）
SELECT d.name AS 部门名, COUNT(e.id) AS 员工数
FROM dept d
LEFT JOIN emp e ON e.dept_id = d.id
GROUP BY d.id, d.name;

-- 6. 查工资最高的员工姓名、部门名和工资
SELECT e.name AS 员工, d.name AS 部门, e.salary AS 工资
FROM emp e
LEFT JOIN dept d ON e.dept_id = d.id
ORDER BY e.salary DESC
LIMIT 1;
