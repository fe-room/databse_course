# 第 4 周：后端连接数据库

## Day 1-3：语言驱动连接 MySQL

### 选择你的语言

**Node.js（mysql2）：**
```javascript
const mysql = require('mysql2/promise');
const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'root',
  database: 'blog',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});
// 查询
const [rows] = await pool.query('SELECT * FROM posts WHERE id = ?', [id]);
```

**Python（pymysql）：**
```python
import pymysql
conn = pymysql.connect(host='localhost', user='root', password='root', db='blog')
with conn.cursor() as cur:
    cur.execute('SELECT * FROM posts WHERE id = %s', (id,))
    rows = cur.fetchall()
```

**Go（go-sql-driver/mysql）：**
```go
import "database/sql"
import _ "github.com/go-sql-driver/mysql"

db, _ := sql.Open("mysql", "root:root@tcp(127.0.0.1:3306)/blog")
rows, _ := db.Query("SELECT * FROM posts WHERE id = ?", id)
```

### 练习
1. 封装一个 DB 模块，包含连接池初始化
2. 实现基本的 CRUD 函数
3. 测试参数化查询防止 SQL 注入

---

## Day 4-7：REST API + MySQL

### 接口清单
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /posts | 文章列表（分页） |
| GET | /posts/:id | 文章详情（含评论） |
| POST | /posts | 创建文章 |
| POST | /comments | 发表评论 |
| GET | /tags/:id/posts | 标签下的文章 |

### 要求
- 使用连接池
- 参数校验 + 错误处理
- 返回 JSON 格式
- 分页参数（page, page_size）

### 代码结构参考
```
code/
├── db.js          # 连接池
├── routes/
│   ├── posts.js
│   └── comments.js
├── app.js         # 入口
└── package.json
```

## 检查清单
- [ ] 能用代码连接 MySQL 并执行查询
- [ ] 理解连接池的作用和配置
- [ ] 完成博客 REST API
- [ ] 用 curl 或 Postman 测试所有接口
