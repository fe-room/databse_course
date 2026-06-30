# 第 4 周：后端连接数据库

> 产出物：博客系统 REST API（基于第 3 周的 blog 表结构）
> 前置依赖：第 3 周建表完成、 blog 库存在、有测试数据

---

## Day 1：环境搭建 + 连接数据库

### 目标
装上语言驱动、连上 MySQL、跑通第一条查询。

### 步骤

**1. 初始化项目（Node.js 示例）**
```bash
mkdir blog-api && cd blog-api
npm init -y
npm install express mysql2 dotenv
```

**2. 写连接代码**
```javascript
// db.js
const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASS || 'root',
  database: process.env.DB_NAME || 'blog',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

module.exports = pool;
```

**3. 跑通第一条查询**
```javascript
const pool = require('./db');
async function test() {
  const [rows] = await pool.query('SELECT 1 + 1 AS result');
  console.log(rows); // [ { result: 2 } ]
}
test();
```

### 理解连接池
- `connectionLimit: 10` — 最多 10 个并发连接，超出的请求排队
- `waitForConnections: true` — 连接用尽时等待而非报错
- `queueLimit: 0` — 不限制排队数量
- **为什么不用单连接？** 每个请求都创建新连接开销大；单连接无法并发处理请求；连接池复用连接，性能提升 10-100 倍

### 练习
见 `exercises/exercise-1.js` — 实现数据库连接和基础查询。

---

## Day 2：参数化查询与 SQL 注入

### 不要拼字符串
```javascript
// ❌ 危险！SQL 注入
const sql = `SELECT * FROM users WHERE username = '${username}'`;

// ✅ 正确：参数化查询
const sql = 'SELECT * FROM users WHERE username = ?';
const [rows] = await pool.query(sql, [username]);
```

### 为什么参数化查询安全
- MySQL 驱动自动转义参数值
- 用户输入不会被当作 SQL 语句执行
- `' OR 1=1 --` 这种注入 payload 会被转义成普通字符串

### 多参数与 LIKE
```javascript
// 多个参数按顺序匹配 ?
const [rows] = await pool.query(
  'SELECT * FROM posts WHERE user_id = ? AND category_id = ?',
  [userId, categoryId]
);

// LIKE 查询：通配符放在参数值里
const [rows] = await pool.query(
  'SELECT * FROM posts WHERE title LIKE ?',
  [`%${keyword}%`]
);
```

---

## Day 3-4：CRUD 操作

### 查询单条
```javascript
const [rows] = await pool.query('SELECT * FROM posts WHERE id = ?', [id]);
const post = rows[0]; // 没有匹配 → undefined
```

### 插入并返回 ID
```javascript
const [result] = await pool.query(
  'INSERT INTO posts (title, content, user_id, category_id) VALUES (?, ?, ?, ?)',
  [title, content, userId, categoryId]
);
console.log('新文章 ID:', result.insertId);
```

### 更新与删除
```javascript
await pool.query('UPDATE posts SET title = ? WHERE id = ?', [newTitle, id]);
await pool.query('DELETE FROM posts WHERE id = ?', [id]);
```

### 事务（后续第 9 周详细讲）
```javascript
const conn = await pool.getConnection();
try {
  await conn.beginTransaction();
  await conn.query('INSERT INTO posts ...', [...]);
  await conn.query('INSERT INTO post_tags ...', [...]);
  await conn.commit();
} catch (err) {
  await conn.rollback();
  throw err;
} finally {
  conn.release();
}
```

---

## Day 5-7：搭建 REST API

### 项目结构
```
blog-api/
├── db.js          ← 连接池（Day 1 完成）
├── app.js         ← Express 入口
├── routes/
│   ├── posts.js
│   └── comments.js
├── package.json
└── .env
```

### 接口清单
| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /posts | 文章列表（分页） |
| GET | /posts/:id | 文章详情（含评论） |
| POST | /posts | 创建文章 |
| POST | /comments | 发表评论 |
| GET | /tags/:id/posts | 标签下的文章 |

### 实现要点

**分页查询**
```javascript
// GET /posts?page=1&page_size=10
const page = parseInt(req.query.page) || 1;
const pageSize = parseInt(req.query.page_size) || 10;
const offset = (page - 1) * pageSize;

const [rows] = await pool.query(
  'SELECT p.*, u.username FROM posts p JOIN users u ON p.user_id = u.id ORDER BY p.created_at DESC LIMIT ? OFFSET ?',
  [pageSize, offset]
);
const [[{ total }]] = await pool.query('SELECT COUNT(*) AS total FROM posts');
// 返回 { data: [...], pagination: { page, page_size, total } }
```

**文章详情含评论**
```javascript
const [posts] = await pool.query('SELECT ... FROM posts WHERE id = ?', [id]);
if (posts.length === 0) return res.status(404).json({ error: '文章不存在' });

const [comments] = await pool.query(
  'SELECT c.*, u.username FROM comments c JOIN users u ON c.user_id = u.id WHERE c.post_id = ? ORDER BY c.created_at ASC',
  [id]
);
res.json({ post: posts[0], comments });
```

### 错误处理

用一个全局中间件兜底，避免每个路由写 try-catch：
```javascript
// app.js
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: '服务器内部错误' });
});
```

也可以用一个 async wrapper 省掉重复的 try-catch：
```javascript
const asyncHandler = (fn) => (req, res, next) =>
  Promise.resolve(fn(req, res, next)).catch(next);
```

---

## 检查清单
- [ ] 代码能连接 MySQL 并执行查询
- [ ] 能说出连接池的作用和三个关键参数含义
- [ ] 理解参数化查询为什么能防止 SQL 注入
- [ ] 完成博客 REST API 五个接口
- [ ] 用 curl 或 Postman 测试所有接口

### curl 测试示例
```bash
# 文章列表
curl http://localhost:3000/posts?page=1&page_size=5

# 文章详情
curl http://localhost:3000/posts/1

# 创建文章
curl -X POST http://localhost:3000/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"测试文章","content":"内容","user_id":1,"category_id":1}'

# 发表评论
curl -X POST http://localhost:3000/comments \
  -H "Content-Type: application/json" \
  -d '{"post_id":1,"user_id":1,"content":"好文！"}'

# 标签下的文章
curl http://localhost:3000/tags/1/posts
```