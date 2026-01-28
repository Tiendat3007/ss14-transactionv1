
create database socialNetworkDB2;
use socialNetworkDB2;

CREATE TABLE users (

    user_id INT AUTO_INCREMENT PRIMARY KEY,

    username VARCHAR(50) NOT NULL,

    total_posts INT DEFAULT 0

);

 

-- 2. Tạo bảng Posts (Bài viết)

CREATE TABLE posts (

    post_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT,

    content TEXT,

    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id)

);

 

-- 3. Tạo dữ liệu mẫu

INSERT INTO users (username, total_posts) VALUES ('nguyen_van_a', 0);

INSERT INTO users (username, total_posts) VALUES ('le_thi_b', 0);

delimiter $$
create procedure sp_create_post(p_user_id int,p_content	text)
begin
DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; 
SIGNAL SQLSTATE '45000' 
SET MESSAGE_TEXT = 'Có lỗi xảy ra, giao dịch đã rollback'; 
END;
if p_content is null  or length(trim(p_content))=0  then
	signal sqlstate '45000'
		set message_text ='nội dung đang để trống';
	else
    start transaction;
    insert into posts(user_id,content)
    values(p_user_id,p_content);
    
    update users
    set total_posts =total_posts+1
    where p_user_id=user_id;
    commit;
    select 'bài viết đã được đăng' as message;
end if;
	rollback;
end $$
delimiter ;
call sp_create_post(1,'huhuh');

 