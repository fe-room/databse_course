# 第 9 周：事务基础

## Day 1-2：ACID 与事务使用

### 学习内容
- **原子性(Atomicity)**：事务内的操作要么全做要么全不做
- **一致性(Consistency)**：事务前后数据满足约束
- **隔离性(Isolation)**：并发事务互不干扰
- **持久性(Durability)**：提交后数据不会丢失

### 基本操作
```sql
BEGIN;  -- 或 START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT; -- 或 ROLLBACK;

SAVEPOINT sp1;
-- 部分回滚
ROLLBACK TO sp1;
```

### 练习
```sql
-- 1. 转账场景：扣钱 + 加钱，用事务保证
-- 2. 中间中断 ROLLBACK，验证余额不变
-- 3. 用 SAVEPOINT 部分回滚
```

---

## Day 3-5：隔离级别（重点！开两个终端实测）

### 四种隔离级别
| 级别 | 脏读 | 不可重复读 | 幻读 | 性能 |
|------|------|-----------|------|------|
| READ UNCOMMITTED | 可能 | 可能 | 可能 | 最高 |
| READ COMMITTED | 不会 | 可能 | 可能 | 高 |
| REPEATABLE READ(默认) | 不会 | 不会 | 可能(InnoDB解决) | 中 |
| SERIALIZABLE | 不会 | 不会 | 不会 | 低 |

### 实测步骤
```
终端 1（事务 A）             终端 2（事务 B）
─────────────────            ─────────────────
SET SESSION tx_isolation
  = 'READ-UNCOMMITTED';
BEGIN;
SELECT * FROM accounts;
                              BEGIN;
                              UPDATE accounts
                                SET balance = 200 WHERE id = 1;
                              -- 不提交
SELECT * FROM accounts;
-- → 看到 balance=200（脏读！）
                              ROLLBACK;
```

每个隔离级别都做一遍，记录观察到的现象。

---

## Day 6-7：MVCC 原理

### 关键概念
- **UNDO LOG**：记录数据的历史版本
- **事务 ID**：每个事务启动时分配递增 ID
- **ReadView**：事务启动时生成"快照"，记录活跃事务列表

### 可见性规则
```
REPEATABLE READ 下：
  事务 T1 首次读时生成 ReadView
  ReadView 里记录了"正在活跃的事务 ID 集合"
  后续读都复用这个 ReadView
  所以 T1 看不到 T1 启动之后才启动的事务的修改
```

### 自测
用自己的话解释：
> "为什么 REPEATABLE READ 下，同一个事务里多次读取结果一致？"

答案方向：因为事务首次读时生成了 ReadView，后续复用。

## 检查清单
- [ ] 理解 ACID 四个属性
- [ ] 能说出四种隔离级别各自解决了什么问题
- [ ] 用两个终端实测验证过每种隔离级别的行为
- [ ] 理解 MVCC + ReadView 的基本原理