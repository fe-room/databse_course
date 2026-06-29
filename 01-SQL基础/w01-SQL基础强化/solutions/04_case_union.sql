-- 参考答案：Day 6 CASE WHEN + UNION
USE sql_practice;

-- 1. 用 CASE WHEN 给员工工资分等级
SELECT name, salary,
    CASE
        WHEN salary < 10000 THEN '低'
        WHEN salary BETWEEN 10000 AND 20000 THEN '中'
        ELSE '高'
    END AS 等级
FROM emp
ORDER BY salary DESC;

-- 2. 统计每个工资等级的人数
SELECT
    CASE
        WHEN salary < 10000 THEN '低'
        WHEN salary BETWEEN 10000 AND 20000 THEN '中'
        ELSE '高'
    END AS 等级,
    COUNT(*) AS 人数
FROM emp
GROUP BY 等级
ORDER BY 人数 DESC;

-- 3. 统计各部门不同工资等级的人数分布
SELECT d.name AS 部门名,
    COUNT(CASE WHEN e.salary < 10000 THEN 1 END) AS 低,
    COUNT(CASE WHEN e.salary BETWEEN 10000 AND 20000 THEN 1 END) AS 中,
    COUNT(CASE WHEN e.salary > 20000 THEN 1 END) AS 高
FROM dept d
LEFT JOIN emp e ON e.dept_id = d.id
GROUP BY d.id, d.name;

-- 4. UNION 练习
SELECT name, salary FROM emp WHERE dept_id = 1
UNION
SELECT name, salary FROM emp WHERE dept_id = 3
ORDER BY salary DESC;
