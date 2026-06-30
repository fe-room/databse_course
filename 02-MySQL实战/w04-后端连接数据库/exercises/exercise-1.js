/**
 * 练习 1：数据库连接与基础查询
 *
 * 任务：
 * 1. 引入 mysql2/promise
 * 2. 创建连接池（host: localhost, user: root, password: root, database: blog）
 * 3. 实现以下函数并打印结果
 */

// TODO: 引入 mysql2/promise

// TODO: 创建连接池

async function getPostCount() {
  // TODO: 查询 posts 表的总文章数
}

async function getLatestPosts(limit) {
  // TODO: 查询最近发表的 limit 篇文章（返回 id, title, created_at）
}

async function getUserByUsername(username) {
  // TODO: 根据用户名查询用户（使用参数化查询）
}

// 依次调用并打印结果
async function main() {
  console.log('--- 文章总数 ---');
  console.log(await getPostCount());

  console.log('--- 最近 5 篇文章 ---');
  console.log(await getLatestPosts(5));

  console.log('--- 查询用户 ---');
  console.log(await getUserByUsername('张三'));
}

main().catch(console.error);
