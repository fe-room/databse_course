const express = require('express');
const pool = require('./db');
const postsRouter = require('./routes/posts');
const commentsRouter = require('./routes/comments');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// 路由
app.use('/posts', postsRouter);
app.use('/comments', commentsRouter);

// GET /tags/:id/posts — 标签下的文章
app.get('/tags/:id/posts', async (req, res, next) => {
  try {
    const [rows] = await pool.query(
      `SELECT p.id, p.title, p.created_at, u.username
       FROM posts p
       JOIN post_tags pt ON p.id = pt.post_id
       JOIN users u ON p.user_id = u.id
       WHERE pt.tag_id = ?
       ORDER BY p.created_at DESC`,
      [req.params.id]
    );
    res.json({ data: rows });
  } catch (err) { next(err); }
});

// 全局错误处理
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: '服务器内部错误' });
});

app.listen(PORT, () => {
  console.log(`blog-api running on http://localhost:${PORT}`);
});
