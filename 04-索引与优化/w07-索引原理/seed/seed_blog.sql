-- 博客库 10 万行种子数据
-- 前提：已执行 w03 的建表语句
USE blog;

DELIMITER $$
CREATE PROCEDURE seed_posts()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE batch_size INT DEFAULT 1000;
  DECLARE max_rows INT DEFAULT 100000;
  START TRANSACTION;
  WHILE i <= max_rows DO
    INSERT INTO posts(title, content, user_id, category_id, created_at)
    VALUES (
      CONCAT('Post ', i),
      REPEAT('content ', 20),
      FLOOR(1 + RAND() * 5),
      FLOOR(1 + RAND() * 3),
      DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY)
    );
    IF i % batch_size = 0 THEN
      COMMIT;
      START TRANSACTION;
      SELECT CONCAT('Inserted ', i, ' rows...') AS progress;
    END IF;
    SET i = i + 1;
  END WHILE;
  COMMIT;
END$$
DELIMITER ;

CALL seed_posts();
DROP PROCEDURE seed_posts;

SELECT COUNT(*) AS total_posts FROM posts;