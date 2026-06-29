# Elasticsearch

## 学习内容

### 核心概念
- **倒排索引**：词 → 文档（和 MySQL 的正排索引相反）
- **索引(Index)**：相当于 MySQL 的表
- **映射(Mapping)**：相当于 MySQL 的 Schema
- **分片**：数据水平拆分

### 适用场景
- 全文搜索（MySQL LIKE 无法替代）
- 日志分析（ELK 栈）
- 搜索建议（自动补全）

### 推荐资源
- Elasticsearch 官方入门：elastic.co/guide
- 中文搜索场景特别适合 ES

### 练习

1. **搭建 ES**
```bash
# ES 需要配置 vm.max_map_count
sudo sysctl -w vm.max_map_count=262144

docker run --name es -p 9200:9200 -e "discovery.type=single-node" -d elasticsearch:8.10

# 获取密码
docker logs es | grep "Password for elastic"
```

2. **创建索引并导入数据**
```bash
# 创建索引
PUT /posts
{
  "mappings": {
    "properties": {
      "title": { "type": "text", "analyzer": "ik_max_word" },
      "content": { "type": "text", "analyzer": "ik_max_word" },
      "created_at": { "type": "date" }
    }
  }
}

# 导入文档
POST /posts/_doc
{
  "title": "MySQL 索引优化实战",
  "content": "本文介绍 MySQL 索引的 B+ Tree 结构...",
  "created_at": "2026-06-29"
}
```

3. **全文搜索**
```bash
# 搜索
GET /posts/_search
{
  "query": {
    "match": {
      "content": "索引优化"
    }
  }
}
```

4. **文章搜索同步**
   - 把 MySQL 里的博客文章同步到 ES
   - 实现一个搜索接口 `GET /search?q=关键词`
   - 搜索结果来自 ES
