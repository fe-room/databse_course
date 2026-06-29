# MongoDB

## 学习内容

### 核心概念
| MySQL | MongoDB |
|-------|---------|
| 数据库 | 数据库 |
| 表 | 集合(Collection) |
| 行 | 文档(Document) |
| 索引 | 索引 |

### 特点
- 无 Schema：同一集合可以存不同结构
- 嵌套文档：一个文档里直接存关联数据（不用 JOIN）
- 内置聚合管道：类似 SQL 的 GROUP BY

### 推荐资源
- MongoDB 官方文档：mongodb.com/docs
- MongoDB University 免费课程

### 练习

1. **搭建 MongoDB**
```bash
docker run --name mongo -p 27017:27017 -d mongo:7
```

2. **基本 CRUD**
```javascript
// 插入
db.posts.insertOne({
  title: "Hello MongoDB",
  content: "...",
  tags: ["mongodb", "database"],
  author: { name: "alice", email: "alice@example.com" },
  comments: [
    { user: "bob", content: "good post", created_at: new Date() }
  ],
  created_at: new Date()
})

// 查询
db.posts.find({ tags: "mongodb" }).sort({ created_at: -1 }).limit(10)

// 更新
db.posts.updateOne(
  { _id: ObjectId("...") },
  { $push: { comments: { user: "bob", content: "nice" } } }
)
```

3. **对比 MySQL 和 MongoDB**
   - 把博客系统的文章数据存到 MongoDB
   - 感受：不需要 JOIN，评论直接嵌入文档
   - 思考：什么场景下这种设计有问题？（评论太多时）
