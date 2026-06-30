const { Router } = require('express');
const pool = require('../db');

const router = Router();

// POST /comments — 发表评论
router.post('/', async (req, res, next) => {
  try {
    const { post_id, user_id, content } = req.body;
    if (!post_id || !user_id || !content) {
      return res.status(400).json({ error: 'post_id, user_id, content 为必填' });
    }

    // 检查文章是否存在
    const [posts] = await pool.query('SELECT id FROM posts WHERE id = ?', [post_id]);
    if (posts.length === 0) return res.status(404).json({ error: '文章不存在' });

    const [result] = await pool.query(
      'INSERT INTO comments (post_id, user_id, content) VALUES (?, ?, ?)',
      [post_id, user_id, content]
    );

    res.status(201).json({ id: result.insertId });
  } catch (err) { next(err); }
});

module.exports = router;
