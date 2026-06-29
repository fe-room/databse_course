# 第 11 周：备份恢复

## Day 1-3：mysqldump

### 全量备份
```bash
# 备份所有数据库
mysqldump -uroot -p --single-transaction --all-databases > full_backup.sql

# 备份指定数据库
mysqldump -uroot -p --single-transaction mydb > mydb_backup.sql

# 只备份表结构（不要数据）
mysqldump -uroot -p --no-data mydb > schema_only.sql

# 只备份数据（不要建表语句）
mysqldump -uroot -p --no-create-info mydb > data_only.sql
```

### --single-transaction 原理
```
在备份开始时开启一个事务
利用 MVCC 读取一致性快照
备份过程中数据可以继续写入（不影响备份一致性）
只对 InnoDB 有效
```

### 恢复
```bash
mysql -uroot -p < full_backup.sql
mysql -uroot -p mydb < mydb_backup.sql
```

---

## Day 4-5：binlog 定点恢复

### 开启 binlog
```ini
# my.cnf
[mysqld]
log_bin = mysql-bin
binlog_format = ROW
expire_logs_days = 7
```

### 查看 binlog
```sql
SHOW BINARY LOGS;                    -- 列出所有 binlog 文件
SHOW MASTER STATUS;                  -- 当前正在写的 binlog
```

### 基于 binlog 恢复数据
```bash
# 查看 binlog 内容
mysqlbinlog /var/lib/mysql/mysql-bin.000001

# 恢复到指定时间点
mysqlbinlog --stop-datetime="2026-01-01 10:00:00" mysql-bin.000001 | mysql -uroot -p

# 恢复到指定位置
mysqlbinlog --stop-position=12345 mysql-bin.000001 | mysql -uroot -p
```

### 练习
```bash
# 1. 删除一条重要数据
DELETE FROM users WHERE id = 1;

# 2. 用 mysqlbinlog 找到 DELETE 之前的 binlog 位置
mysqlbinlog mysql-bin.000001 | grep -A 5 "DELETE FROM"

# 3. 恢复到删除前
mysqlbinlog --stop-position=<删除前的位置> mysql-bin.000001 | mysql -uroot -p
```

---

## Day 6-7：自动化备份脚本

### 要求
写一个 bash 或 Python 脚本 `scripts/backup.sh`：
- 每日凌晨全量备份
- 备份文件名：`mydb_YYYYMMDD.sql.gz`
- 保留最近 7 天的备份
- 验证备份文件可用（解压 + 检查 SQL 头部）

### 参考框架
```bash
#!/bin/bash
DB_USER="root"
DB_PASS="root"
DB_NAME="mydb"
BACKUP_DIR="/backups/mysql"
DATE=$(date +%Y%m%d)
FILE="$BACKUP_DIR/${DB_NAME}_${DATE}.sql.gz"

# 备份
mysqldump --single-transaction -u$DB_USER -p$DB_PASS $DB_NAME | gzip > $FILE

# 验证
gunzip -t $FILE && echo "Backup OK" || echo "Backup corrupted"

# 删除 7 天前的备份
find $BACKUP_DIR -name "${DB_NAME}_*.sql.gz" -mtime +7 -delete
```

添加 crontab 定时执行：
```cron
0 2 * * * /path/to/backup.sh
```

## 检查清单
- [ ] 能用 mysqldump 做全量备份
- [ ] 理解 --single-transaction 的原理
- [ ] 能通过 binlog 做定点恢复
- [ ] 完成自动化备份脚本