# Redis

## 学习内容

### 五种基本数据结构
| 结构 | 场景 | 命令 |
|------|------|------|
| String | 缓存、计数器 | SET, GET, INCR, DECR |
| Hash | 对象存储 | HSET, HGET, HGETALL |
| List | 消息队列 | LPUSH, RPOP, LRANGE |
| Set | 标签、去重 | SADD, SMEMBERS, SINTER |
| ZSet | 排行榜 | ZADD, ZRANGE, ZREVRANGE |

### 推荐资源
- Redis 官方文档：redis.io/docs
- 《Redis 设计与实现》第 1-4 章

### 练习

1. **搭建 Redis**
```bash
docker run --name redis -p 6379:6379 -d redis:7
```

2. **基础操作**
```bash
redis-cli
SET user:1:name "alice"
GET user:1:name
INCR page:view:1
```

3. **缓存博客文章**
   - 用对应语言的 Redis 客户端连接
   - 查询文章时先查 Redis，没有再查 MySQL
   - 设置 5 分钟过期时间
   - 模式：Cache Aside

4. **实现分布式锁**
```python
SET lock:product:1 "uuid" NX EX 10
# 释放：只有持有者才能释放
if GET("lock:product:1") == "uuid":
    DEL("lock:product:1")
```

5. **计数器**
```bash
# 文章阅读量
INCR post:42:views
# 日活用户（Set 去重）
SADD dau:2026-06-29 user:123
SCARD dau:2026-06-29
```
