# 第 3 周：表设计与数据类型

## Day 1-2：数据类型选型

### 学习内容
| 类型 | 选型原则 |
|------|---------|
| 整型 | TINYINT(1字节) / INT(4字节) / BIGINT(8字节)，够用就好 |
| 小数 | 钱永远用 DECIMAL，不用 FLOAT/DOUBLE |
| 字符串 | CHAR(定长) / VARCHAR(变长)，知道最大长度的区别 |
| 大文本 | TEXT / MEDIUMTEXT / LONGTEXT，不是万不得已不用 |
| 日期 | DATETIME(范围大) / TIMESTAMP(省空间但有2038问题) |
| JSON | MySQL 5.7+ 支持，适合不固定结构的字段 |

### 练习
设计一个用户表，为每个字段选择最合适的类型：
```
用户表：id, 用户名, 邮箱, 手机号, 年龄, 身高(cm), 月收入(分),
        个人简介, 注册时间, 最后登录时间, 扩展信息(JSON)
```

---

## Day 3-4：约束

### 学习内容
- PRIMARY KEY：聚簇索引，每表一个
- FOREIGN KEY：保证引用完整性，但影响写入性能
- UNIQUE：唯一约束，自动建索引
- NOT NULL, DEFAULT, CHECK(MySQL 8.0+)

### 练习
给用户表加上所有合适的约束，测试：
- 插入重复邮箱 → 报错
- 删除有外键关联的数据 → 观察级联效果
- CHECK 约束检查年龄 > 0

---

## Day 5-7：实战 — 博客系统建表

### 表结构
```
users：id, username, email, password_hash, created_at
posts：id, title, content, user_id, category_id, created_at, updated_at
comments：id, post_id, user_id, content, created_at
tags：id, name
post_tags：post_id, tag_id
categories：id, name
```

### 要求
1. 先画 ER 图（用 dbdiagram.io）
2. 写出完整 DDL（含外键、索引、默认值）
3. 插入测试数据（5 篇文章、20 条评论）
4. 写出常用查询：
   - 首页文章列表（含作者名、评论数）
   - 文章详情
   - 标签下的文章列表

### 产出
建表 SQL 保存到 `exercises/blog_schema.sql`

## 检查清单
- [ ] 能给字段选择合适的数据类型
- [ ] 理解外键的优缺点
- [ ] 独立完成博客系统建表
