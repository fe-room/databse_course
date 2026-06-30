/**
 * 练习 1 参考答案
 */
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: 'root',
  database: 'blog',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

async function getPostCount() {
  const [[{ count }]] = await pool.query('SELECT COUNT(*) AS count FROM posts');
  return count;
}

async function getLatestPosts(limit) {
  const [rows] = await pool.query(
    'SELECT id, title, created_at FROM posts ORDER BY created_at DESC LIMIT ?',
    [limit]
  );
  return rows;
}

async function getUserByUsername(username) {
  const [rows] = await pool.query('SELECT id, username, email FROM users WHERE username = ?', [username]);
  return rows[0] || null;
}

async function main() {
  console.log('--- 文章总数 ---');
  console.log(await getPostCount());

  console.log('--- 最近 5 篇文章 ---');
  console.log(await getLatestPosts(5));

  console.log('--- 查询用户 ---');
  console.log(await getUserByUsername('张三'));
}

main().catch(console.error);
