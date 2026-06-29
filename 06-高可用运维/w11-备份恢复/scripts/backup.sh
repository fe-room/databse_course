#!/bin/bash
# 数据库自动备份脚本
# 用法: ./backup.sh
# 建议 crontab: 0 2 * * * /path/to/backup.sh

# ============ 配置 ============
DB_USER="root"
DB_PASS="root"
DB_HOST="localhost"
DB_NAME="mydb"          # 要备份的数据库名
BACKUP_DIR="/tmp/mysql_backups"  # 备份存放目录
RETENTION_DAYS=7        # 保留天数
# ==============================

DATE=$(date +%Y%m%d_%H%M%S)
FILE="${BACKUP_DIR}/${DB_NAME}_${DATE}.sql.gz"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始备份 $DB_NAME..."

# 备份并压缩
mysqldump \
    -h "$DB_HOST" \
    -u "$DB_USER" \
    -p"$DB_PASS" \
    --single-transaction \
    --routines \
    --triggers \
    "$DB_NAME" | gzip > "$FILE"

# 检查备份是否成功
if [ $? -eq 0 ] && [ -s "$FILE" ]; then
    FILE_SIZE=$(du -h "$FILE" | cut -f1)
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] 备份成功: $FILE ($FILE_SIZE)"

    # 验证备份文件完整性
    gunzip -t "$FILE"
    if [ $? -eq 0 ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] 备份文件完整性验证通过"
    else
        echo "[ERROR] 备份文件损坏: $FILE"
        exit 1
    fi
else
    echo "[ERROR] 备份失败!"
    exit 1
fi

# 删除过期备份
find "$BACKUP_DIR" -name "${DB_NAME}_*.sql.gz" -mtime +$RETENTION_DAYS -delete
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 已清理 $RETENTION_DAYS 天前的备份"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 备份完成"
