-- 第 3 周实战：博客系统建表
-- 完成以下建表语句，选择合适的数据类型和约束

-- 用户表
CREATE TABLE users (
    -- 完善字段定义
);

-- 分类表
CREATE TABLE categories (
    -- 完善字段定义
);

-- 文章表
CREATE TABLE posts (
    -- 完善字段定义
    -- 注意：外键关联 users 和 categories
);

-- 评论表
CREATE TABLE comments (
    -- 完善字段定义
    -- 注意：外键关联 posts 和 users
);

-- 标签表
CREATE TABLE tags (
    -- 完善字段定义
);

-- 文章-标签关联表
CREATE TABLE post_tags (
    -- 完善字段定义
    -- 联合主键或自增主键？
);
