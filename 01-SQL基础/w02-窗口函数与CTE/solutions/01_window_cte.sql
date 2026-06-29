-- 参考答案：第 2 周窗口函数与 CTE
USE sql_practice;

-- 1. 每个部门按工资从高到低排名
SELECT d.name AS 部门, e.name AS 员工, e.salary,
    ROW_NUMBER() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) AS 排名
FROM emp e
JOIN dept d ON e.dept_id = d.id;

-- 2. 每个部门工资最高的员工
SELECT 部门, 员工, 工资 FROM (
    SELECT d.name AS 部门, e.name AS 员工, e.salary AS 工资,
        RANK() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) AS rk
    FROM emp e
    JOIN dept d ON e.dept_id = d.id
) ranked WHERE rk = 1;

-- 3. 每个员工与同部门最高工资的差距
SELECT e.name, d.name AS 部门, e.salary,
    MAX(e.salary) OVER (PARTITION BY e.dept_id) AS 部门最高,
    MAX(e.salary) OVER (PARTITION BY e.dept_id) - e.salary AS 差距
FROM emp e
JOIN dept d ON e.dept_id = d.id;

-- 4. 每个部门工资排前 2 的员工
SELECT 部门, 员工, 工资 FROM (
    SELECT d.name AS 部门, e.name AS 员工, e.salary AS 工资,
        DENSE_RANK() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) AS rk
    FROM emp e
    JOIN dept d ON e.dept_id = d.id
) ranked WHERE rk <= 2;

-- 5. 按公司总工资排序，计算累计工资占比
SELECT name, salary,
    SUM(salary) OVER (ORDER BY salary DESC) AS 累计工资,
    SUM(salary) OVER (ORDER BY salary DESC) / SUM(salary) OVER () * 100 AS 占比百分比
FROM emp;

-- 6. 用 CTE 查高于部门平均水平的员工
WITH dept_avg AS (
    SELECT dept_id, AVG(salary) AS avg_salary
    FROM emp WHERE dept_id IS NOT NULL
    GROUP BY dept_id
)
SELECT e.name, d.name AS 部门, e.salary, da.avg_salary
FROM emp e
JOIN dept d ON e.dept_id = d.id
JOIN dept_avg da ON e.dept_id = da.dept_id
WHERE e.salary > da.avg_salary;

-- 7. 递归 CTE：生成 1 到 10 的数字序列
WITH RECURSIVE numbers(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;

-- 8. 递归 CTE：组织架构树
WITH RECURSIVE org_tree AS (
    -- 根节点（没有经理的人）
    SELECT id, name, 0 AS level, CAST(name AS CHAR(200)) AS path
    FROM emp WHERE manager_id IS NULL
    UNION ALL
    -- 递归子节点
    SELECT e.id, e.name, t.level + 1,
        CONCAT(t.path, ' -> ', e.name)
    FROM emp e
    JOIN org_tree t ON e.manager_id = t.id
)
SELECT name, level, path FROM org_tree ORDER BY path;
