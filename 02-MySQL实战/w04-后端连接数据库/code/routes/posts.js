const { Router } = require('express');
const pool = require('../db');

const router = Router();

// GET /posts — 文章列表（分页）
router.get('/', async (req, res, next) => {
  try {
    const page = Math.max(parseInt(req.query.page) || 1, 1);
    const pageSize = Math.min(Math.max(parseInt(req.query.page_size) || 10, 1), 100);
    const offset = (page - 1) * pageSize;

    const [rows] = await pool.query(
      `SELECT p.id, p.title, p.created_at, u.username, c.name AS category
       FROM posts p
       JOIN users u ON p.user_id = u.id
       LEFT JOIN categories c ON p.category_id = c.id
       ORDER BY p.created_at DESC
       LIMIT ? OFFSET ?`,
      [pageSize, offset]
    );
    const [[{ total }]] = await pool.query('SELECT COUNT(*) AS total FROM posts');

    res.json({ data: rows, pagination: { page, page_size: pageSize, total } });
  } catch (err) { next(err); }
});

// GET /posts/:id — 文章详情（含评论）
router.get('/:id', async (req, res, next) => {
  try {
    const [posts] = await pool.query(
      `SELECT p.*, u.username, c.name AS category
       FROM posts p
       JOIN users u ON p.user_id = u.id
       LEFT JOIN categories c ON p.category_id = c.id
       WHERE p.id = ?`,
      [req.params.id]
    );
    if (posts.length === 0) return res.status(404).json({ error: '文章不存在' });

    const [comments] = await pool.query(
      `SELECT c.id, c.content, c.created_at, u.username
       FROM comments c
       JOIN users u ON c.user_id = u.id
       WHERE c.post_id = ?
       ORDER BY c.created_at ASC`,
      [req.params.id]
    );

    res.json({ post: posts[0], comments });
  } catch (err) { next(err); }
});

// POST /posts — 创建文章
router.post('/', async (req, res, next) => {
  try {
    const { title, content, user_id, category_id } = req.body;
    if (!title || !content || !user_id) {
      return res.status(400).json({ error: 'title, content, user_id 为必填' });
    }

    const [result] = await pool.query(
      'INSERT INTO posts (title, content, user_id, category_id) VALUES (?, ?, ?, ?)',
      [title, content, user_id, category_id ?? null]
    );

    res.status(201).json({ id: result.insertId });
  } catch (err) { next(err); }
});

module.exports = router;
