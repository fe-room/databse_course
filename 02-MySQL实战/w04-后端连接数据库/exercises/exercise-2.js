/**
 * 练习 2：CRUD 操作
 *
 * 任务：实现文章的增删改查函数
 * 要求：全部使用参数化查询
 */

const pool = require('../code/db');

// TODO: 实现 createPost(title, content, userId, categoryId)
// 返回新文章的 ID

// TODO: 实现 updatePost(id, title, content)
// 返回受影响的行数

// TODO: 实现 deletePost(id)
// 返回受影响的行数

// TODO: 实现 getPostsByCategory(categoryId, page, pageSize)
// 返回 { data: [...], total: number }

async function main() {
  // 测试创建
  // const newId = await createPost('测试标题', '测试内容', 1, null);
  // console.log('新文章 ID:', newId);

  // 测试更新
  // const affected = await updatePost(newId, '新标题', '新内容');
  // console.log('更新行数:', affected);

  // 测试分页查询
  // const result = await getPostsByCategory(1, 1, 5);
  // console.log('分类文章:', result);

  // 测试删除
  // const deleted = await deletePost(newId);
  // console.log('删除行数:', deleted);
}

main().catch(console.error);
