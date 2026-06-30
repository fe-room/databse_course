# 第 12 周：主从复制与连接池

## Day 1-4：主从复制

### 复制原理
```
主库写 binlog → 从库 IO 线程拉取 → 写入 relay log
→ 从库 SQL 线程重放 relay log → 数据同步
```

### 同步模式
| 模式 | 特点 |
|------|------|
| 异步复制(默认) | 主库不管从库是否收到，性能最好，可能丢数据 |
| 半同步复制 | 主库等至少一个从库确认，性能稍差，数据更可靠 |

### Docker 搭建主从

配置文件在 `docker/` 目录下，使用 Docker Compose 一键启动：

```bash
# 启动主从
docker compose -f docker/docker-compose.yml up -d

# 查看日志确认启动成功
docker logs mysql-master
docker logs mysql-slave
```

**配置复制：**
```sql
-- 在主库创建复制用户
CREATE USER 'repl'@'%' IDENTIFIED BY 'repl';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
SHOW MASTER STATUS; -- 记下 File 和 Position

-- 在从库设置主库
CHANGE MASTER TO
  MASTER_HOST='<主库IP>',
  MASTER_PORT=3306,
  MASTER_USER='repl',
  MASTER_PASSWORD='repl',
  MASTER_LOG_FILE='mysql-bin.000001',
  MASTER_LOG_POS=0;
START SLAVE;
SHOW SLAVE STATUS\G  -- 看 Slave_IO_Running 和 Slave_SQL_Running
```

### 主从延迟
```sql
-- 查看延迟秒数
SHOW SLAVE STATUS\G
-- Seconds_Behind_Master 字段

-- 主从延迟的常见原因：
-- 1. 从库硬件比主库差
-- 2. 从库在做备份
-- 3. 大事务（一次删太多数据）
```

---

## Day 5-6：连接池

### 核心配置
```javascript
// Node.js mysql2 连接池
{
  connectionLimit: 10,      // 最大连接数
  waitForConnections: true, // 无可用连接时排队
  queueLimit: 0,            // 排队上限（0=不限制）
  maxIdle: 10               // 最大空闲连接
}
```

### 连接池大小怎么定
```
经验公式：
  connections = (CPU 核数 * 2) + 有效磁盘数

不是越大越好：
  连接数太大 → MySQL 线程上下文切换 → 性能下降
  连接数太小 → 请求排队 → 吞吐量下降
```

### 练习
在博客 API 项目上加压测对比：
```bash
# 无连接池 vs 有连接池
# 用 ab 或 wrk 压 100 并发
ab -n 1000 -c 100 http://localhost:3000/posts
```

---

## Day 7：读写分离

### 代码实现
```javascript
// 简单读写分离
const masterPool = mysql.createPool({/* 主库配置 */});
const slavePool = mysql.createPool({/* 从库配置 */});

async function query(sql, params, isWrite = false) {
  const pool = isWrite ? masterPool : slavePool;
  return pool.query(sql, params);
}

// SELECT 走从库
await query('SELECT * FROM posts', [], false);
// INSERT/UPDATE/DELETE 走主库
await query('INSERT INTO posts SET ?', [data], true);
```

### 主从延迟问题
```
写主库 → 读从库 → 可能读到旧数据

解决方案：
  1. 关键数据强制读主库（如：下单成功后查订单）
  2. 写后延迟读（前端等待 1 秒再查）
  3. 从库延迟监控，延迟高时切到主库读
```

### 扩展：中间件方案
```
不想在代码层处理读写分离？
→ ProxySQL / MySQL Router 做中间层代理
代码只需连一个地址，中间件路由到主/从
```

## 检查清单
- [ ] 理解 binlog → relay log → SQL 线程的复制流程
- [ ] 用 Docker 搭建了主从复制
- [ ] 知道怎么看主从延迟
- [ ] 理解连接池的作用和配置参数
- [ ] 实现简单的读写分离代码