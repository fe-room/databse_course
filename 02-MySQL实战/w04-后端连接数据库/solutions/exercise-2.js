/**
 * 练习 2 参考答案
 */
const pool = require('../code/db');

async function createPost(title, content, userId, categoryId) {
  const [result] = await pool.query(
    'INSERT INTO posts (title, content, user_id, category_id) VALUES (?, ?, ?, ?)',
    [title, content, userId, categoryId ?? null]
  );
  return result.insertId;
}

async function updatePost(id, title, content) {
  const [result] = await pool.query(
    'UPDATE posts SET title = ?, content = ? WHERE id = ?',
    [title, content, id]
  );
  return result.affectedRows;
}

async function deletePost(id) {
  const [result] = await pool.query('DELETE FROM posts WHERE id = ?', [id]);
  return result.affectedRows;
}

async function getPostsByCategory(categoryId, page = 1, pageSize = 10) {
  const offset = (page - 1) * pageSize;
  const [rows] = await pool.query(
    `SELECT p.id, p.title, p.created_at, u.username
     FROM posts p
     JOIN users u ON p.user_id = u.id
     WHERE p.category_id = ?
     ORDER BY p.created_at DESC
     LIMIT ? OFFSET ?`,
    [categoryId, pageSize, offset]
  );
  const [[{ total }]] = await pool.query(
    'SELECT COUNT(*) AS total FROM posts WHERE category_id = ?',
    [categoryId]
  );
  return { data: rows, total };
}

async function main() {
  const newId = await createPost('测试标题', '测试内容', 1, null);
  console.log('新文章 ID:', newId);

  const affected = await updatePost(newId, '新标题', '新内容');
  console.log('更新行数:', affected);

  const result = await getPostsByCategory(1, 1, 5);
  console.log('分类文章数:', result.total);

  const deleted = await deletePost(newId);
  console.log('删除行数:', deleted);
}

main().catch(console.error);
