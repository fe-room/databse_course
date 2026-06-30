#!/usr/bin/env node
/**
 * SQL 查询工具箱 CLI
 * 用法: node query.js -f query.sql [-o table|csv] [-h localhost] [-u root] [-p root] [-d sql_practice]
 */
const fs = require('fs');
const mysql = require('mysql2/promise');
const path = require('path');

const args = require('minimist')(process.argv.slice(2), {
  alias: { f: 'file', o: 'output', h: 'host', u: 'user', p: 'password', d: 'database' },
  default: { o: 'table', h: 'localhost', u: 'root', p: 'root', d: 'sql_practice' },
});

async function main() {
  if (!args.file) {
    console.error('用法: node query.js -f query.sql [-o table|csv]');
    process.exit(1);
  }

  const sql = fs.readFileSync(path.resolve(args.file), 'utf8');
  const conn = await mysql.createConnection({
    host: args.host, user: args.user, password: args.password, database: args.database,
  });

  try {
    const [rows] = await conn.query(sql);
    if (args.output === 'csv') {
      if (rows.length === 0) return console.log('(empty)');
      console.log(Object.keys(rows[0]).join(','));
      rows.forEach(r => console.log(Object.values(r).join(',')));
    } else {
      console.table(rows);
    }
  } catch (err) {
    console.error('SQL 执行错误:', err.message);
    process.exit(1);
  } finally {
    await conn.end();
  }
}

main();