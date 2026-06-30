-- 第 9 周参考答案

-- 练习 1：转账事务
-- 成功：两个 UPDATE 都执行后 COMMIT，余额正确
-- 失败：ROLLBACK 后两个 UPDATE 都被撤销，余额不变
-- SAVEPOINT 示例：
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
SAVEPOINT after_debit;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
-- 如果发现加错了账户
ROLLBACK TO after_debit;  -- 回滚到扣钱之后的状态
-- 此时 id=1 已扣 100，id=2 未加钱
COMMIT;

-- 练习 2：隔离级别
-- READ UNCOMMITTED: 终端 A 看到终端 B 未提交的修改（脏读）
-- READ COMMITTED: 终端 A 看不到终端 B 未提交的修改，但在同一事务内两次读可能结果不同（不可重复读）
-- REPEATABLE READ: 同一事务内多次读取结果一致（MySQL 默认）
-- SERIALIZABLE: 所有事务串行执行，并发最低

-- 练习 3：MVCC
-- REPEATABLE READ 下，事务首次 SELECT 时生成 ReadView
-- ReadView 记录了当前活跃事务 ID 列表
-- 后续 SELECT 复用该 ReadView，因此看不到其他事务的修改
-- READ COMMITTED 下，每次 SELECT 都生成新的 ReadView