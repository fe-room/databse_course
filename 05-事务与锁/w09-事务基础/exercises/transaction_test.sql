-- 第 9 周练习：事务与隔离级别实测

-- 练习 1：转账事务
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
-- 在 COMMIT 前执行 ROLLBACK，验证余额恢复

-- 练习 2：隔离级别观察
-- 打开两个终端，分别执行：

-- 终端 A：
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN;
SELECT * FROM accounts WHERE id = 1;

-- 终端 B（在 A 的事务内执行）：
BEGIN;
UPDATE accounts SET balance = 200 WHERE id = 1;
-- 不提交

-- 回到终端 A 再查，观察脏读

-- 练习 3：测试其他隔离级别
-- 把 READ UNCOMMITTED 依次换成：
--   READ COMMITTED
--   REPEATABLE READ
--   SERIALIZABLE
-- 重复练习 2，观察每种级别的行为差异