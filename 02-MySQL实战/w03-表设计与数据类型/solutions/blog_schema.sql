-- 参考答案：博客系统建表
CREATE DATABASE IF NOT EXISTS blog DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE blog;

-- 用户表
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
    password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
    bio VARCHAR(200) DEFAULT NULL COMMENT '个人简介',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 分类表
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '分类名',
    description VARCHAR(200) DEFAULT NULL COMMENT '分类描述'
) ENGINE=InnoDB;

-- 文章表
CREATE TABLE posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL COMMENT '标题',
    content TEXT NOT NULL COMMENT '内容',
    user_id INT NOT NULL COMMENT '作者',
    category_id INT DEFAULT NULL COMMENT '分类',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_category_id (category_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB;

-- 评论表
CREATE TABLE comments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL COMMENT '所属文章',
    user_id INT NOT NULL COMMENT '评论者',
    content TEXT NOT NULL COMMENT '评论内容',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_post_id (post_id)
) ENGINE=InnoDB;

-- 标签表
CREATE TABLE tags (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT '标签名'
) ENGINE=InnoDB;

-- 文章-标签关联表
CREATE TABLE post_tags (
    post_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (post_id, tag_id),
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- 测试数据
-- ============================================

-- 用户
INSERT INTO users (id, username, email, password_hash, bio) VALUES
(1, 'alice', 'alice@example.com', '$2a$10$xVqYLFJ6yZ3aB6Y', '后端工程师'),
(2, 'bob',   'bob@example.com',   '$2a$10$xVqYLFJ6yZ3aB6Z', '前端工程师'),
(3, 'carol', 'carol@example.com', '$2a$10$xVqYLFJ6yZ3aB7A', '产品经理'),
(4, 'dave',  'dave@example.com',  '$2a$10$xVqYLFJ6yZ3aB7B', '运营'),
(5, 'eve',   'eve@example.com',   '$2a$10$xVqYLFJ6yZ3aB7C', '设计师');

-- 分类
INSERT INTO categories (id, name, description) VALUES
(1, '技术', '技术相关文章'),
(2, '产品', '产品设计和管理'),
(3, '运营', '运营经验和分享');

-- 标签
INSERT INTO tags (id, name) VALUES
(1, 'MySQL'), (2, 'JavaScript'), (3, '性能优化'), (4, '设计模式');

-- 文章
INSERT INTO posts (id, title, content, user_id, category_id, created_at) VALUES
(1, 'MySQL 索引优化实战', '索引是数据库性能优化的核心手段之一。本文介绍 B+ Tree 索引原理...', 1, 1, '2026-06-01 10:00:00'),
(2, 'Express 中间件原理', 'Express 的中间件模型是 Node.js 后端开发的核心概念...', 2, 1, '2026-06-03 14:30:00'),
(3, '如何写好产品需求文档', '一份好的 PRD 应该包含哪些内容？本文从结构、格式、粒度三个方面...', 3, 2, '2026-06-05 09:00:00'),
(4, '数据库范式与反范式', '设计数据库时，范式和反范式各有适用场景...', 1, 1, '2026-06-08 11:00:00'),
(5, 'A/B 测试实战指南', '从流量分配到显著性检验，A/B 测试的完整流程...', 4, 3, '2026-06-10 16:00:00');

-- 文章-标签关联
INSERT INTO post_tags (post_id, tag_id) VALUES
(1, 1), (1, 3), (2, 2), (4, 1), (4, 4);

-- 评论
INSERT INTO comments (id, post_id, user_id, content, created_at) VALUES
(1, 1, 2, '很实用，收藏了', '2026-06-01 11:00:00'),
(2, 1, 3, '能不能具体讲一下联合索引？', '2026-06-01 15:00:00'),
(3, 1, 1, '回复 @carol：下一篇文章会讲', '2026-06-02 09:00:00'),
(4, 2, 1, '写得很清楚，终于搞懂了中间件', '2026-06-03 16:00:00'),
(5, 2, 4, 'Koa 的中间件模型也是类似的吗？', '2026-06-04 10:00:00'),
(6, 2, 2, '类似，但 Koa 是洋葱模型', '2026-06-04 11:00:00'),
(7, 3, 1, '作为开发也想看产品文档怎么写', '2026-06-05 10:00:00'),
(8, 3, 5, '补充一下：需求优先级也很重要', '2026-06-05 14:00:00'),
(9, 3, 3, '谢谢建议，下个版本加上', '2026-06-05 15:00:00'),
(10, 4, 2, '反范式在报表场景确实很常见', '2026-06-08 14:00:00'),
(11, 4, 5, '我们项目就是反范式过度了', '2026-06-09 09:00:00'),
(12, 4, 1, '反范式要有度，否则维护成本很高', '2026-06-09 10:00:00'),
(13, 5, 1, '统计学知识是 A/B 测试的关键', '2026-06-10 17:00:00'),
(14, 5, 2, '样本量不够大时结果不可信', '2026-06-11 09:00:00'),
(15, 5, 4, '确实，我们之前踩过这个坑', '2026-06-11 10:00:00'),
(16, 1, 5, '期待下一篇文章', '2026-06-02 10:00:00'),
(17, 2, 3, '有没有关于错误处理的文章？', '2026-06-04 15:00:00'),
(18, 4, 3, '学到了，感谢分享', '2026-06-09 11:00:00'),
(19, 5, 3, '很好的入门指南', '2026-06-11 11:00:00'),
(20, 5, 5, '收藏了，回头分享给团队', '2026-06-12 09:00:00');
