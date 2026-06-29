-- 参考答案：Day 5 子查询
USE sql_practice;

-- 1. 查工资高于公司平均的员工（标量子查询）
SELECT name, salary
FROM emp
WHERE salary > (SELECT AVG(salary) FROM emp);

-- 2. 查工资高于技术部平均工资的员工
SELECT e.name, e.salary
FROM emp e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM emp e2
    JOIN dept d ON e2.dept_id = d.id
    WHERE d.name = '技术部'
);

-- 3. 查每个部门工资最高的员工（FROM 子查询）
SELECT d.name AS 部门, e.name AS 员工, e.salary AS 工资
FROM emp e
JOIN dept d ON e.dept_id = d.id
JOIN (
    SELECT dept_id, MAX(salary) AS max_salary
    FROM emp
    WHERE dept_id IS NOT NULL
    GROUP BY dept_id
) top ON e.dept_id = top.dept_id AND e.salary = top.max_salary;

-- 4. 查没有员工的部门（NOT EXISTS）
SELECT d.name
FROM dept d
WHERE NOT EXISTS (
    SELECT 1 FROM emp e WHERE e.dept_id = d.id
);

-- 5. 查工资最高的员工的部门名（IN 子查询）
SELECT name
FROM dept
WHERE id IN (
    SELECT dept_id FROM emp WHERE salary = (SELECT MAX(salary) FROM emp)
);
