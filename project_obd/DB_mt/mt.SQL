[20241120-DB멘토링] 김광진 

* 팀명 : OBD(Old Best Driver)
  팀원 : 최홍준, 김신진, 조성일, 정지은, 안진영, 박은빈
  과제 : 객체인식 기반 주행보조 서비스 

* DB모델링 주소 
URL : https://aquerytool.com/aquerymain/index/?rurl=b25a39eb-6b87-4e2a-93b5-ba7aeedc6b69&
Password : 37erz8

* MySQL 설치 
- 윈도우 : mysql installer 
- 리눅스 : yum install -y mysql* 
         dnf install -y mysql* 
         
* datetime, timestamp 차이 

  datetime  : '2024-11-20 09:27:20'
  timestamp : '2024-11-20 09:27:20', UTC+09:00(TIMEZONE) -> 시간 설정시 일반적으로 사용

* 말풍선(Verbose, 말이 많은) : 상세모드 

* int, int unsigned 차이 

  int          ... 32 bit 정수(-2147483648~-1, 0~2147483647) *대략 -21억~+21억
  int unsigned ... 32 bit 정수(0~2147483647 + 2147483648)    *대략     0~+42억

* 소수점 데이터의 표시 

  300.85 ____ DECIMAL(10,2) = NUMERIC(10,2) : 동일 결과

* 엔터티 간의 관계차수 

  운전자(tb_driver) ---------------- OBD(tb_obd2)

       1                   :        0, 1, N(Numerous, 여러개의)

* ERD 
  ER-Diagram 
  Entity Relationship Diagram       


  Relation     : 일반적인 관계('날씨와 우산판매량의 관계')
  Relations    : 국가적인 관계(relations) between the two countries.
  Relationship : 개인적인 관계, 비즈니스 관계

* 데이터모델 : VO : DTO : Java Model 

  VO(Value Object)
  DTO(Data Transfer Object)
--------------------------------------------------------------------------
* 계정 생성 
use sys;
use mysql;

# root : mysql
show databases;
use mysql;

# (1) DB생성, (2) USER생성 (3) USER 권한부여 (4)권한반영 

# (1) CREATE DATABASE obd_db;

# (2) CREATE USER obd_user@localhost IDENTIFIED BY '1234';      -- 로컬호스트 접속 허용
CREATE USER obd_user@210.110.20.50 IDENTIFIED BY '1234';  -- 특정 IP
CREATE USER obd_user@`210.110.20.*` IDENTIFIED BY '1234'; -- 특정 IP 대역
CREATE USER obd_user@`%` IDENTIFIED BY '1234';            -- 모든 외부 호스트  

GRANT SELECT ON obd_db.* TO obd_user@localhost;
GRANT SELECT, UPDATE, DELETE ON obd_db.* TO obd_user@localhost;
# (3) GRANT ALL PRIVILEGES ON obd_db.* to obd_user@localhost;

# (4) FLUSH PRIVILEGES;

# (5) 유저 계정 삭제 
DROP USER obd_user@localhost;

# (6) DB 삭제 
DROP DATABASE obd_db;



# SQL  : SELECT 3 + 2;
# PL/SQL : FUNCTION(함수), 프로시저(PROCEDURE), 트리거(TRIGGER)

# 일반 사용자에게 함수/프로시저/트리거 생성 권한을 줘야 함. 
SET global log_bin_trust_function_creators=on;
= SET global log_bin_trust_function_creators=1;





--------------------------------------------------------------------------
* 사용자 토큰 발행  
SELECT 3 + 2; -> delimeter로 일반적으로 ';'사용


* 일반 유저가 함수/프로시저/트리거를 작성하기 위해서는 'root'사용자가 
SQL> set global log_bin_trust_function_creators=on;  (또는)
SQL> set global log_bin_trust_function_creators=1;

-- 토큰 발행 함수 ( 함수 생성 ) 
DELIMITER $$ 
DROP FUNCTION IF EXISTS fn_token $$
CREATE FUNCTION fn_token(length INT) RETURNS VARCHAR(300)
NO SQL
BEGIN 
   -- 토큰 발행 과정 
      
   DECLARE characters VARCHAR(36); 
   DECLARE char_length INT; 
   DECLARE token VARCHAR(300); 
   DECLARE i INT;
   
   SET characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
   SET char_length = LENGTH(characters);
   SET token = SUBSTRING(UPPER(TO_BASE64(UNIX_TIMESTAMP() * 1000000 + MICROSECOND(NOW(6)))), 1, 22);
   SET i = 0;
   
   WHILE i < length - 22 DO 
      SET token = CONCAT(token, SUBSTRING(characters, FLOOR(1 + RAND() * char_length), 1));
      SET i = i + 1;
   END WHILE;
   RETURN token;
   
   
END $$ 
DELIMITER ;

SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 1, 1); # A
SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 2, 1); # B
SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 36, 1); # 9
SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 1, 2); # AB

SELECT FLOOR(1.5); # 1
SELECT CEIL(1.5);  # 2

SELECT RAND();  # 0 < RAND() < 1
SELECT RAND() * 36;  # 0 < RAND() < 36
SELECT FLOOR(RAND() * 36);  # 0 <= RAND() <=35
SELECT FLOOR(1 + RAND() * 36);  # 1 <= RAND() <=36

# 문자열 합치기 
# JAVA : 'A' + 'B'
# ORCALE : 'A'||'B'
# MYSQL : CONCAT('A','B','C',.....)

SELECT LENGTH('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789');

SELECT fn_token(20); # QGVNBFX3DA39RR9QLHEB
SELECT fn_token(200); # MTCZMJA2OTEXMZGZNJG3NA7YWDTOP7OH3SC21QB4BYKPI789BIAN6NEUPSHR3VT52JBO6K19VAJKYSSBWAG4Y6S2RC4BZN22VVF9PJBO6ITAOA2AV8AF1NU1B8YTWRSGLDRFJ5UIRYABG0FSEDCBA7YV6Y11TONZO5GLAEVWJPP5ASTE8SWXLYQI2HZ7RY5OLRNSNKNB
# 36글자 중에서 200글자를 뽑은 것 : 36의 200승. (36x36x36x....200회)



-- 밀리초(1/1000초) 
-- 마이크로초 : (1/1,000,000초) 
-- 나노초 : (1/1,000,000,000초) 

SELECT CURRENT_TIMESTAMP();  # 2024-11-20 11:03:33
SELECT CURRENT_TIMESTAMP(3); # 2024-11-20 11:03:48.568
SELECT CURRENT_TIMESTAMP(6); # 2024-11-20 11:04:05.771092
SELECT NOW(6);               # 2024-11-20 11:04:16.111487
SELECT MICROSECOND(NOW(6));  # 182412
SELECT UNIX_TIMESTAMP(); # 1732068336(1970.1.1~현재까지의 초)
SELECT  UNIX_TIMESTAMP() * 1000000; # (1970.1.1~현재까지의 마이크로초)

SELECT  UNIX_TIMESTAMP() * 1000000 + MICROSECOND(NOW(6)); # 1732068623686918
SELECT TO_BASE64();
SELECT UPPER(TO_BASE64(UNIX_TIMESTAMP() * 1000000 + MICROSECOND(NOW(6)))); # MTCZMJA2ODY2NDE1NTQ3OA==
SELECT LENGTH('MTCZMJA2ODY2NDE1NTQ3OA==');

SELECT SUBSTRING(UPPER(TO_BASE64(UNIX_TIMESTAMP() * 1000000 + MICROSECOND(NOW(6)))), 1, 22); # MTCZMJA2ODC0MZA0OTGYNG



# 11720685173143290V1A3C4C1YCLM00N1W4OQCA4IWNA7YTXYQI1ELKPMM10P7OH1J9EZDOYID0RFLDTPSK5UIOLODKF6CXDP6GJ05EB2453R9QNRMHCZKOBCFWWIK3FMKNA96RZDNTVOH3SC48KUAMZQFPZKJOLM10QEFQ1QB1ZKM26E9SXXLWGBXDW16JXOCFWU8E0JD1TMF0GX16IRY95
SELECT fn_token(200); # MTCZMJA2ODGZNZY0OTGYNAPRHSAQKCRHWPKF58G9PGX0XBIDZMU3PYEVVGC38IM9817NEP2X7XQMPB5K3J4OSNNYKQP2X5OP6KYTXXLVAKOGXZWAG3VT52LF58CUTCZMT0DGXZW9AEURY93HTFC5IS7CSMJIMBH5Z916IS2P1VWM7T7BP8U63Q2UR0H4WU7AH9M11TQY


* 배치 파일(batch file) : 일련의 자동 실행 파일 
DML(Data Manipulation Language) : INSERT, UPDATE, DELETE 시 트리거 동작시킬 수 있음.

* 토큰 자동발행 트리거 
# PL/SQL(Procedural Language/Structured Query Language) : 함수(FUNCTION), 프로시저(PROCEDURE), 트리거(TRIGGER);

DELIMITER $$
DROP TRIGGER IF EXISTS trg_token $$
CREATE TRIGGER trg_token  
AFTER INSERT ON tb_driver 
FOR EACH ROW 
BEGIN 
  INSERT INTO tb_token (id, token, expire_dt, create_dt) VALUES (NEW.id, fn_token(200), DATE_ADD(NOW(), INTERVAL 7 DAY), NOW());
END $$
DELIMITER ;

SELECT DATE_ADD(NOW(), INTERVAL 7 DAY); # 7일 뒤의 시간 구하기

INSERT INTO tb_driver (name, birthdate, gender, family_contact, join_dt) VALUES ('name 2342', NOW(), 'N', 'family_contact 1', NOW());

# 운전자 아이디로 운전자 나이 구하는 프로시저 
DELIMITER $$
CREATE PROCEDURE proc_member_age(IN driver_id INT, OUT age INT) 
BEGIN    

   DECLARE v_age INT;
    SET v_age = (SELECT TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) FROM tb_driver WHERE id = driver_id);
    SET age = v_age;
END $$
DELIMITER ;

SELECT birthdate FROM tb_driver WHERE id = 1;
SELECT TIMESTAMPDIFF(YEAR, '2010-11-20', '2024-11-20'); # 나이 구하기
SELECT TIMESTAMPDIFF(HOUR, '2010-11-20', '2024-11-20'); # 시간 차이 구하기 122736

UPDATE tb_driver SET birthdate='2010-11-20' WHERE id = 1;
CALL proc_member_age(1, @age);
SELECT @age;


DELIMITER $$ 
CREATE FUNCTION fn_driver_age(driver_id INT)  RETURNS INT 
BEGIN 
   DECLARE v_age INT;
    SET v_age = (SELECT TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) FROM tb_driver WHERE id = driver_id);
    RETURN v_age;
END $$
DELIMITER ;

SELECT fn_driver_age(1);


------------------------------------------------------------------------
(실전프로젝트 MySQL SQL문)  

-- 테이블 순서는 관계를 고려하여 한 번에 실행해도 에러가 발생하지 않게 정렬되었습니다.

-- tb_driver Table Create SQL
-- 테이블 생성 SQL - tb_driver
CREATE TABLE tb_driver
(
    `id`              INT            NOT NULL    AUTO_INCREMENT COMMENT '운전자 아이디', 
    `name`            VARCHAR(50)    NOT NULL    COMMENT '운전자 이름', 
    `birthdate`       DATE           NOT NULL    COMMENT '운전자 생년월일', 
    `gender`          CHAR(1)        NOT NULL    COMMENT '운전자 성별', 
    `family_contact`  VARCHAR(20)    NOT NULL    COMMENT '가족 연락처', 
    `join_dt`         TIMESTAMP      NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '가입 일자', 
     PRIMARY KEY (id)
);

-- 테이블 Comment 설정 SQL - tb_driver
ALTER TABLE tb_driver COMMENT '운전자';


-- tb_obd2 Table Create SQL
-- 테이블 생성 SQL - tb_obd2
CREATE TABLE tb_obd2
(
    `obd_idx`     INT UNSIGNED     NOT NULL    AUTO_INCREMENT COMMENT 'OBD 식별자', 
    `product_id`  VARCHAR(50)      NOT NULL    COMMENT '제품 번호', 
    `speed`       DECIMAL(10,2)    NOT NULL    COMMENT '속도', 
    `accel_b`     DECIMAL(10,2)    NOT NULL    COMMENT '가속도 B', 
    `rpm`         INT              NOT NULL    COMMENT '엔진 RPM', 
    `create_dt`   TIMESTAMP        NOT NULL    COMMENT '측정 일자', 
    `id`          INT              NOT NULL    COMMENT '운전자 아이디', 
     PRIMARY KEY (obd_idx)
);

-- 테이블 Comment 설정 SQL - tb_obd2
ALTER TABLE tb_obd2 COMMENT 'OBD 정보';

-- Foreign Key 설정 SQL - tb_obd2(id) -> tb_driver(id)
ALTER TABLE tb_obd2
    ADD CONSTRAINT FK_tb_obd2_id_tb_driver_id FOREIGN KEY (id)
        REFERENCES tb_driver (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_obd2(id)
-- ALTER TABLE tb_obd2
-- DROP FOREIGN KEY FK_tb_obd2_id_tb_driver_id;


-- tb_road Table Create SQL
-- 테이블 생성 SQL - tb_road
CREATE TABLE tb_road
(
    `road_idx`          INT UNSIGNED    NOT NULL    AUTO_INCREMENT COMMENT '노면 식별자', 
    `product_id`        VARCHAR(50)     NOT NULL    COMMENT '제품 번호', 
    `forward`           INT             NOT NULL    COMMENT '직진', 
    `direction_change`  INT             NOT NULL    COMMENT '경로 변경', 
    `crosswalk`         INT             NOT NULL    COMMENT '횡단 보도', 
    `lane_change`       INT             NOT NULL    COMMENT '차로 변경', 
    `speed_limit`       INT             NOT NULL    COMMENT '제한 속도', 
    `caution`           INT             NOT NULL    COMMENT '양보', 
     PRIMARY KEY (road_idx)
);

-- 테이블 Comment 설정 SQL - tb_road
ALTER TABLE tb_road COMMENT '노면표시';


-- tb_driver_habit Table Create SQL
-- 테이블 생성 SQL - tb_driver_habit
CREATE TABLE tb_driver_habit
(
    `id`              INT              NOT NULL    COMMENT '운전자 아이디', 
    `obd_idx`         INT UNSIGNED     NOT NULL    COMMENT 'OBD 식별자', 
    `avg_accel`       DECIMAL(10,2)    NOT NULL    COMMENT '평균 가속도', 
    `avg_speed`       DECIMAL(10,2)    NOT NULL    COMMENT '평균 속도', 
    `sudden_braking`  DECIMAL(10,2)    NOT NULL    COMMENT '급제동 횟수', 
     PRIMARY KEY (id)
);

-- 테이블 Comment 설정 SQL - tb_driver_habit
ALTER TABLE tb_driver_habit COMMENT '운전자 습관 정보';

-- Foreign Key 설정 SQL - tb_driver_habit(id) -> tb_driver(id)
ALTER TABLE tb_driver_habit
    ADD CONSTRAINT FK_tb_driver_habit_id_tb_driver_id FOREIGN KEY (id)
        REFERENCES tb_driver (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_driver_habit(id)
-- ALTER TABLE tb_driver_habit
-- DROP FOREIGN KEY FK_tb_driver_habit_id_tb_driver_id;

-- Foreign Key 설정 SQL - tb_driver_habit(obd_idx) -> tb_obd2(obd_idx)
ALTER TABLE tb_driver_habit
    ADD CONSTRAINT FK_tb_driver_habit_obd_idx_tb_obd2_obd_idx FOREIGN KEY (obd_idx)
        REFERENCES tb_obd2 (obd_idx) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_driver_habit(obd_idx)
-- ALTER TABLE tb_driver_habit
-- DROP FOREIGN KEY FK_tb_driver_habit_obd_idx_tb_obd2_obd_idx;


-- tb_imu Table Create SQL
-- 테이블 생성 SQL - tb_imu
CREATE TABLE tb_imu
(
    `imu_id`          INT UNSIGNED     NOT NULL    AUTO_INCREMENT COMMENT 'IMU 아이디', 
    `product_id`      VARCHAR(50)      NOT NULL    COMMENT '제품 번호', 
    `accel_i`         DECIMAL(10,2)    NOT NULL    COMMENT '가속도 I', 
    `tumble`          CHAR(1)          NOT NULL    COMMENT '전복 여부', 
    `side_collision`  CHAR(1)          NOT NULL    COMMENT '측면 충돌 여부', 
    `create_dt`       TIMESTAMP        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '측정 날짜', 
    `id`              INT              NOT NULL    COMMENT '운전자 아이디', 
     PRIMARY KEY (imu_id)
);

-- 테이블 Comment 설정 SQL - tb_imu
ALTER TABLE tb_imu COMMENT 'IMU';

-- Foreign Key 설정 SQL - tb_imu(id) -> tb_driver(id)
ALTER TABLE tb_imu
    ADD CONSTRAINT FK_tb_imu_id_tb_driver_id FOREIGN KEY (id)
        REFERENCES tb_driver (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_imu(id)
-- ALTER TABLE tb_imu
-- DROP FOREIGN KEY FK_tb_imu_id_tb_driver_id;


-- tb_env Table Create SQL
-- 테이블 생성 SQL - tb_env
CREATE TABLE tb_env
(
    `env_idx`  INT UNSIGNED    NOT NULL    AUTO_INCREMENT COMMENT '설정 식별자', 
    `volumn`   INT             NOT NULL    COMMENT '음향 볼륨 조절', 
    `light`    INT             NOT NULL    COMMENT '밝기 조절', 
    `id`       INT             NOT NULL    COMMENT '운전자 아이디', 
     PRIMARY KEY (env_idx)
);

-- 테이블 Comment 설정 SQL - tb_env
ALTER TABLE tb_env COMMENT '환경 설정';

-- Foreign Key 설정 SQL - tb_env(id) -> tb_driver_habit(id)
ALTER TABLE tb_env
    ADD CONSTRAINT FK_tb_env_id_tb_driver_habit_id FOREIGN KEY (id)
        REFERENCES tb_driver_habit (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_env(id)
-- ALTER TABLE tb_env
-- DROP FOREIGN KEY FK_tb_env_id_tb_driver_habit_id;


-- tb_deep_learning Table Create SQL
-- 테이블 생성 SQL - tb_deep_learning
CREATE TABLE tb_deep_learning
(
    `dl_idx`     INT UNSIGNED    NOT NULL    AUTO_INCREMENT COMMENT '학습식별자', 
    `dl_model`   VARCHAR(100)    NOT NULL    COMMENT '사용 모델명', 
    `dl_result`  TEXT            NOT NULL    COMMENT '학습 결과', 
    `road_idx`   INT UNSIGNED    NOT NULL    COMMENT '노면 식별자', 
    `create_dt`  TIMESTAMP       NOT NULL    COMMENT '등록 일자', 
     PRIMARY KEY (dl_idx)
);

-- 테이블 Comment 설정 SQL - tb_deep_learning
ALTER TABLE tb_deep_learning COMMENT '딥러닝 학습 정보';

-- Foreign Key 설정 SQL - tb_deep_learning(road_idx) -> tb_road(road_idx)
ALTER TABLE tb_deep_learning
    ADD CONSTRAINT FK_tb_deep_learning_road_idx_tb_road_road_idx FOREIGN KEY (road_idx)
        REFERENCES tb_road (road_idx) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_deep_learning(road_idx)
-- ALTER TABLE tb_deep_learning
-- DROP FOREIGN KEY FK_tb_deep_learning_road_idx_tb_road_road_idx;


-- tb_behavior_guide Table Create SQL
-- 테이블 생성 SQL - tb_behavior_guide
CREATE TABLE tb_behavior_guide
(
    `guide_idx`  INT UNSIGNED    NOT NULL    AUTO_INCREMENT COMMENT '가이드 식별자', 
    `id`         INT             NOT NULL    COMMENT '운전자 아이디', 
    `accel_yn`   CHAR(1)         NOT NULL    COMMENT '엑셀', 
    `brake_yn`   CHAR(1)         NOT NULL    COMMENT '브레이크', 
    `create_dt`  TIMESTAMP       NULL        DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일자', 
     PRIMARY KEY (guide_idx)
);

-- 테이블 Comment 설정 SQL - tb_behavior_guide
ALTER TABLE tb_behavior_guide COMMENT '행동 가이드';

-- Foreign Key 설정 SQL - tb_behavior_guide(id) -> tb_driver_habit(id)
ALTER TABLE tb_behavior_guide
    ADD CONSTRAINT FK_tb_behavior_guide_id_tb_driver_habit_id FOREIGN KEY (id)
        REFERENCES tb_driver_habit (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_behavior_guide(id)
-- ALTER TABLE tb_behavior_guide
-- DROP FOREIGN KEY FK_tb_behavior_guide_id_tb_driver_habit_id;


[20241120-DB멘토링] 김광진 

* 팀명 : OBD(Old Best Driver)
  팀원 : 최홍준, 김신진, 조성일, 정지은, 안진영, 박은빈
  과제 : 객체인식 기반 주행보조 서비스 

* DB모델링 주소 
URL : https://aquerytool.com/aquerymain/index/?rurl=b25a39eb-6b87-4e2a-93b5-ba7aeedc6b69&
Password : 37erz8

* MySQL 설치 
- 윈도우 : mysql installer 
- 리눅스 : yum install -y mysql* 
         dnf install -y mysql* 
         
* datetime, timestamp 차이 

  datetime  : '2024-11-20 09:27:20'
  timestamp : '2024-11-20 09:27:20', UTC+09:00(TIMEZONE) -> 시간 설정시 일반적으로 사용

* 말풍선(Verbose, 말이 많은) : 상세모드 

* int, int unsigned 차이 

  int          ... 32 bit 정수(-2147483648~-1, 0~2147483647) *대략 -21억~+21억
  int unsigned ... 32 bit 정수(0~2147483647 + 2147483648)    *대략     0~+42억

* 소수점 데이터의 표시 

  300.85 ____ DECIMAL(10,2) = NUMERIC(10,2) : 동일 결과

* 엔터티 간의 관계차수 

  운전자(tb_driver) ---------------- OBD(tb_obd2)

       1                   :        0, 1, N(Numerous, 여러개의)

* ERD 
  ER-Diagram 
  Entity Relationship Diagram       


  Relation     : 일반적인 관계('날씨와 우산판매량의 관계')
  Relations    : 국가적인 관계(relations) between the two countries.
  Relationship : 개인적인 관계, 비즈니스 관계

* 데이터모델 : VO : DTO : Java Model 

  VO(Value Object)
  DTO(Data Transfer Object)
--------------------------------------------------------------------------
* 계정 생성 
use sys;
use mysql;

# root : mysql
show databases;
use mysql;

# (1) DB생성, (2) USER생성 (3) USER 권한부여 (4)권한반영 

# (1) CREATE DATABASE obd_db;

# (2) CREATE USER obd_user@localhost IDENTIFIED BY '1234';      -- 로컬호스트 접속 허용
CREATE USER obd_user@210.110.20.50 IDENTIFIED BY '1234';  -- 특정 IP
CREATE USER obd_user@`210.110.20.*` IDENTIFIED BY '1234'; -- 특정 IP 대역
CREATE USER obd_user@`%` IDENTIFIED BY '1234';            -- 모든 외부 호스트  

GRANT SELECT ON obd_db.* TO obd_user@localhost;
GRANT SELECT, UPDATE, DELETE ON obd_db.* TO obd_user@localhost;
# (3) GRANT ALL PRIVILEGES ON obd_db.* to obd_user@localhost;

# (4) FLUSH PRIVILEGES;

# (5) 유저 계정 삭제 
DROP USER obd_user@localhost;

# (6) DB 삭제 
DROP DATABASE obd_db;



# SQL  : SELECT 3 + 2;
# PL/SQL : FUNCTION(함수), 프로시저(PROCEDURE), 트리거(TRIGGER)

# 일반 사용자에게 함수/프로시저/트리거 생성 권한을 줘야 함. 
SET global log_bin_trust_function_creators=on;
= SET global log_bin_trust_function_creators=1;





--------------------------------------------------------------------------
* 사용자 토큰 발행  
SELECT 3 + 2; -> delimeter로 일반적으로 ';'사용


* 일반 유저가 함수/프로시저/트리거를 작성하기 위해서는 'root'사용자가 
SQL> set global log_bin_trust_function_creators=on;  (또는)
SQL> set global log_bin_trust_function_creators=1;

-- 토큰 발행 함수 ( 함수 생성 ) 
DELIMITER $$ 
DROP FUNCTION IF EXISTS fn_token $$
CREATE FUNCTION fn_token(length INT) RETURNS VARCHAR(300)
NO SQL
BEGIN 
   -- 토큰 발행 과정 
      
   DECLARE characters VARCHAR(36); 
   DECLARE char_length INT; 
   DECLARE token VARCHAR(300); 
   DECLARE i INT;
   
   SET characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
   SET char_length = LENGTH(characters);
   SET token = SUBSTRING(UPPER(TO_BASE64(UNIX_TIMESTAMP() * 1000000 + MICROSECOND(NOW(6)))), 1, 22);
   SET i = 0;
   
   WHILE i < length - 22 DO 
      SET token = CONCAT(token, SUBSTRING(characters, FLOOR(1 + RAND() * char_length), 1));
      SET i = i + 1;
   END WHILE;
   RETURN token;
   
   
END $$ 
DELIMITER ;

SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 1, 1); # A
SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 2, 1); # B
SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 36, 1); # 9
SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 1, 2); # AB

SELECT FLOOR(1.5); # 1
SELECT CEIL(1.5);  # 2

SELECT RAND();  # 0 < RAND() < 1
SELECT RAND() * 36;  # 0 < RAND() < 36
SELECT FLOOR(RAND() * 36);  # 0 <= RAND() <=35
SELECT FLOOR(1 + RAND() * 36);  # 1 <= RAND() <=36

# 문자열 합치기 
# JAVA : 'A' + 'B'
# ORCALE : 'A'||'B'
# MYSQL : CONCAT('A','B','C',.....)

SELECT LENGTH('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789');

SELECT fn_token(20); # QGVNBFX3DA39RR9QLHEB
SELECT fn_token(200); # MTCZMJA2OTEXMZGZNJG3NA7YWDTOP7OH3SC21QB4BYKPI789BIAN6NEUPSHR3VT52JBO6K19VAJKYSSBWAG4Y6S2RC4BZN22VVF9PJBO6ITAOA2AV8AF1NU1B8YTWRSGLDRFJ5UIRYABG0FSEDCBA7YV6Y11TONZO5GLAEVWJPP5ASTE8SWXLYQI2HZ7RY5OLRNSNKNB
# 36글자 중에서 200글자를 뽑은 것 : 36의 200승. (36x36x36x....200회)



-- 밀리초(1/1000초) 
-- 마이크로초 : (1/1,000,000초) 
-- 나노초 : (1/1,000,000,000초) 

SELECT CURRENT_TIMESTAMP();  # 2024-11-20 11:03:33
SELECT CURRENT_TIMESTAMP(3); # 2024-11-20 11:03:48.568
SELECT CURRENT_TIMESTAMP(6); # 2024-11-20 11:04:05.771092
SELECT NOW(6);               # 2024-11-20 11:04:16.111487
SELECT MICROSECOND(NOW(6));  # 182412
SELECT UNIX_TIMESTAMP(); # 1732068336(1970.1.1~현재까지의 초)
SELECT  UNIX_TIMESTAMP() * 1000000; # (1970.1.1~현재까지의 마이크로초)

SELECT  UNIX_TIMESTAMP() * 1000000 + MICROSECOND(NOW(6)); # 1732068623686918
SELECT TO_BASE64();
SELECT UPPER(TO_BASE64(UNIX_TIMESTAMP() * 1000000 + MICROSECOND(NOW(6)))); # MTCZMJA2ODY2NDE1NTQ3OA==
SELECT LENGTH('MTCZMJA2ODY2NDE1NTQ3OA==');

SELECT SUBSTRING(UPPER(TO_BASE64(UNIX_TIMESTAMP() * 1000000 + MICROSECOND(NOW(6)))), 1, 22); # MTCZMJA2ODC0MZA0OTGYNG



# 11720685173143290V1A3C4C1YCLM00N1W4OQCA4IWNA7YTXYQI1ELKPMM10P7OH1J9EZDOYID0RFLDTPSK5UIOLODKF6CXDP6GJ05EB2453R9QNRMHCZKOBCFWWIK3FMKNA96RZDNTVOH3SC48KUAMZQFPZKJOLM10QEFQ1QB1ZKM26E9SXXLWGBXDW16JXOCFWU8E0JD1TMF0GX16IRY95
SELECT fn_token(200); # MTCZMJA2ODGZNZY0OTGYNAPRHSAQKCRHWPKF58G9PGX0XBIDZMU3PYEVVGC38IM9817NEP2X7XQMPB5K3J4OSNNYKQP2X5OP6KYTXXLVAKOGXZWAG3VT52LF58CUTCZMT0DGXZW9AEURY93HTFC5IS7CSMJIMBH5Z916IS2P1VWM7T7BP8U63Q2UR0H4WU7AH9M11TQY


* 배치 파일(batch file) : 일련의 자동 실행 파일 
DML(Data Manipulation Language) : INSERT, UPDATE, DELETE 시 트리거 동작시킬 수 있음.

* 토큰 자동발행 트리거 
# PL/SQL(Procedural Language/Structured Query Language) : 함수(FUNCTION), 프로시저(PROCEDURE), 트리거(TRIGGER);

DELIMITER $$
DROP TRIGGER IF EXISTS trg_token $$
CREATE TRIGGER trg_token  
AFTER INSERT ON tb_driver 
FOR EACH ROW 
BEGIN 
  INSERT INTO tb_token (id, token, expire_dt, create_dt) VALUES (NEW.id, fn_token(200), DATE_ADD(NOW(), INTERVAL 7 DAY), NOW());
END $$
DELIMITER ;

SELECT DATE_ADD(NOW(), INTERVAL 7 DAY); # 7일 뒤의 시간 구하기

INSERT INTO tb_driver (name, birthdate, gender, family_contact, join_dt) VALUES ('name 2342', NOW(), 'N', 'family_contact 1', NOW());

# 운전자 아이디로 운전자 나이 구하는 프로시저 
DELIMITER $$
CREATE PROCEDURE proc_member_age(IN driver_id INT, OUT age INT) 
BEGIN    

   DECLARE v_age INT;
    SET v_age = (SELECT TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) FROM tb_driver WHERE id = driver_id);
    SET age = v_age;
END $$
DELIMITER ;

SELECT birthdate FROM tb_driver WHERE id = 1;
SELECT TIMESTAMPDIFF(YEAR, '2010-11-20', '2024-11-20'); # 나이 구하기
SELECT TIMESTAMPDIFF(HOUR, '2010-11-20', '2024-11-20'); # 시간 차이 구하기 122736

UPDATE tb_driver SET birthdate='2010-11-20' WHERE id = 1;
CALL proc_member_age(1, @age);
SELECT @age;


DELIMITER $$ 
CREATE FUNCTION fn_driver_age(driver_id INT)  RETURNS INT 
BEGIN 
   DECLARE v_age INT;
    SET v_age = (SELECT TIMESTAMPDIFF(YEAR, birthdate, CURDATE()) FROM tb_driver WHERE id = driver_id);
    RETURN v_age;
END $$
DELIMITER ;

SELECT fn_driver_age(1);


------------------------------------------------------------------------
(실전프로젝트 MySQL SQL문)  

-- 테이블 순서는 관계를 고려하여 한 번에 실행해도 에러가 발생하지 않게 정렬되었습니다.

-- tb_driver Table Create SQL
-- 테이블 생성 SQL - tb_driver
CREATE TABLE tb_driver
(
    `id`              INT            NOT NULL    AUTO_INCREMENT COMMENT '운전자 아이디', 
    `name`            VARCHAR(50)    NOT NULL    COMMENT '운전자 이름', 
    `birthdate`       DATE           NOT NULL    COMMENT '운전자 생년월일', 
    `gender`          CHAR(1)        NOT NULL    COMMENT '운전자 성별', 
    `family_contact`  VARCHAR(20)    NOT NULL    COMMENT '가족 연락처', 
    `join_dt`         TIMESTAMP      NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '가입 일자', 
     PRIMARY KEY (id)
);

-- 테이블 Comment 설정 SQL - tb_driver
ALTER TABLE tb_driver COMMENT '운전자';


-- tb_obd2 Table Create SQL
-- 테이블 생성 SQL - tb_obd2
CREATE TABLE tb_obd2
(
    `obd_idx`     INT UNSIGNED     NOT NULL    AUTO_INCREMENT COMMENT 'OBD 식별자', 
    `product_id`  VARCHAR(50)      NOT NULL    COMMENT '제품 번호', 
    `speed`       DECIMAL(10,2)    NOT NULL    COMMENT '속도', 
    `accel_b`     DECIMAL(10,2)    NOT NULL    COMMENT '가속도 B', 
    `rpm`         INT              NOT NULL    COMMENT '엔진 RPM', 
    `create_dt`   TIMESTAMP        NOT NULL    COMMENT '측정 일자', 
    `id`          INT              NOT NULL    COMMENT '운전자 아이디', 
     PRIMARY KEY (obd_idx)
);

-- 테이블 Comment 설정 SQL - tb_obd2
ALTER TABLE tb_obd2 COMMENT 'OBD 정보';

-- Foreign Key 설정 SQL - tb_obd2(id) -> tb_driver(id)
ALTER TABLE tb_obd2
    ADD CONSTRAINT FK_tb_obd2_id_tb_driver_id FOREIGN KEY (id)
        REFERENCES tb_driver (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_obd2(id)
-- ALTER TABLE tb_obd2
-- DROP FOREIGN KEY FK_tb_obd2_id_tb_driver_id;


-- tb_road Table Create SQL
-- 테이블 생성 SQL - tb_road
CREATE TABLE tb_road
(
    `road_idx`          INT UNSIGNED    NOT NULL    AUTO_INCREMENT COMMENT '노면 식별자', 
    `product_id`        VARCHAR(50)     NOT NULL    COMMENT '제품 번호', 
    `forward`           INT             NOT NULL    COMMENT '직진', 
    `direction_change`  INT             NOT NULL    COMMENT '경로 변경', 
    `crosswalk`         INT             NOT NULL    COMMENT '횡단 보도', 
    `lane_change`       INT             NOT NULL    COMMENT '차로 변경', 
    `speed_limit`       INT             NOT NULL    COMMENT '제한 속도', 
    `caution`           INT             NOT NULL    COMMENT '양보', 
     PRIMARY KEY (road_idx)
);

-- 테이블 Comment 설정 SQL - tb_road
ALTER TABLE tb_road COMMENT '노면표시';


-- tb_driver_habit Table Create SQL
-- 테이블 생성 SQL - tb_driver_habit
CREATE TABLE tb_driver_habit
(
    `id`              INT              NOT NULL    COMMENT '운전자 아이디', 
    `obd_idx`         INT UNSIGNED     NOT NULL    COMMENT 'OBD 식별자', 
    `avg_accel`       DECIMAL(10,2)    NOT NULL    COMMENT '평균 가속도', 
    `avg_speed`       DECIMAL(10,2)    NOT NULL    COMMENT '평균 속도', 
    `sudden_braking`  DECIMAL(10,2)    NOT NULL    COMMENT '급제동 횟수', 
     PRIMARY KEY (id)
);

-- 테이블 Comment 설정 SQL - tb_driver_habit
ALTER TABLE tb_driver_habit COMMENT '운전자 습관 정보';

-- Foreign Key 설정 SQL - tb_driver_habit(id) -> tb_driver(id)
ALTER TABLE tb_driver_habit
    ADD CONSTRAINT FK_tb_driver_habit_id_tb_driver_id FOREIGN KEY (id)
        REFERENCES tb_driver (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_driver_habit(id)
-- ALTER TABLE tb_driver_habit
-- DROP FOREIGN KEY FK_tb_driver_habit_id_tb_driver_id;

-- Foreign Key 설정 SQL - tb_driver_habit(obd_idx) -> tb_obd2(obd_idx)
ALTER TABLE tb_driver_habit
    ADD CONSTRAINT FK_tb_driver_habit_obd_idx_tb_obd2_obd_idx FOREIGN KEY (obd_idx)
        REFERENCES tb_obd2 (obd_idx) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_driver_habit(obd_idx)
-- ALTER TABLE tb_driver_habit
-- DROP FOREIGN KEY FK_tb_driver_habit_obd_idx_tb_obd2_obd_idx;


-- tb_imu Table Create SQL
-- 테이블 생성 SQL - tb_imu
CREATE TABLE tb_imu
(
    `imu_id`          INT UNSIGNED     NOT NULL    AUTO_INCREMENT COMMENT 'IMU 아이디', 
    `product_id`      VARCHAR(50)      NOT NULL    COMMENT '제품 번호', 
    `accel_i`         DECIMAL(10,2)    NOT NULL    COMMENT '가속도 I', 
    `tumble`          CHAR(1)          NOT NULL    COMMENT '전복 여부', 
    `side_collision`  CHAR(1)          NOT NULL    COMMENT '측면 충돌 여부', 
    `create_dt`       TIMESTAMP        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '측정 날짜', 
    `id`              INT              NOT NULL    COMMENT '운전자 아이디', 
     PRIMARY KEY (imu_id)
);

-- 테이블 Comment 설정 SQL - tb_imu
ALTER TABLE tb_imu COMMENT 'IMU';

-- Foreign Key 설정 SQL - tb_imu(id) -> tb_driver(id)
ALTER TABLE tb_imu
    ADD CONSTRAINT FK_tb_imu_id_tb_driver_id FOREIGN KEY (id)
        REFERENCES tb_driver (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_imu(id)
-- ALTER TABLE tb_imu
-- DROP FOREIGN KEY FK_tb_imu_id_tb_driver_id;


-- tb_env Table Create SQL
-- 테이블 생성 SQL - tb_env
CREATE TABLE tb_env
(
    `env_idx`  INT UNSIGNED    NOT NULL    AUTO_INCREMENT COMMENT '설정 식별자', 
    `volumn`   INT             NOT NULL    COMMENT '음향 볼륨 조절', 
    `light`    INT             NOT NULL    COMMENT '밝기 조절', 
    `id`       INT             NOT NULL    COMMENT '운전자 아이디', 
     PRIMARY KEY (env_idx)
);

-- 테이블 Comment 설정 SQL - tb_env
ALTER TABLE tb_env COMMENT '환경 설정';

-- Foreign Key 설정 SQL - tb_env(id) -> tb_driver_habit(id)
ALTER TABLE tb_env
    ADD CONSTRAINT FK_tb_env_id_tb_driver_habit_id FOREIGN KEY (id)
        REFERENCES tb_driver_habit (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_env(id)
-- ALTER TABLE tb_env
-- DROP FOREIGN KEY FK_tb_env_id_tb_driver_habit_id;


-- tb_deep_learning Table Create SQL
-- 테이블 생성 SQL - tb_deep_learning
CREATE TABLE tb_deep_learning
(
    `dl_idx`     INT UNSIGNED    NOT NULL    AUTO_INCREMENT COMMENT '학습식별자', 
    `dl_model`   VARCHAR(100)    NOT NULL    COMMENT '사용 모델명', 
    `dl_result`  TEXT            NOT NULL    COMMENT '학습 결과', 
    `road_idx`   INT UNSIGNED    NOT NULL    COMMENT '노면 식별자', 
    `create_dt`  TIMESTAMP       NOT NULL    COMMENT '등록 일자', 
     PRIMARY KEY (dl_idx)
);

-- 테이블 Comment 설정 SQL - tb_deep_learning
ALTER TABLE tb_deep_learning COMMENT '딥러닝 학습 정보';

-- Foreign Key 설정 SQL - tb_deep_learning(road_idx) -> tb_road(road_idx)
ALTER TABLE tb_deep_learning
    ADD CONSTRAINT FK_tb_deep_learning_road_idx_tb_road_road_idx FOREIGN KEY (road_idx)
        REFERENCES tb_road (road_idx) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_deep_learning(road_idx)
-- ALTER TABLE tb_deep_learning
-- DROP FOREIGN KEY FK_tb_deep_learning_road_idx_tb_road_road_idx;


-- tb_behavior_guide Table Create SQL
-- 테이블 생성 SQL - tb_behavior_guide
CREATE TABLE tb_behavior_guide
(
    `guide_idx`  INT UNSIGNED    NOT NULL    AUTO_INCREMENT COMMENT '가이드 식별자', 
    `id`         INT             NOT NULL    COMMENT '운전자 아이디', 
    `accel_yn`   CHAR(1)         NOT NULL    COMMENT '엑셀', 
    `brake_yn`   CHAR(1)         NOT NULL    COMMENT '브레이크', 
    `create_dt`  TIMESTAMP       NULL        DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일자', 
     PRIMARY KEY (guide_idx)
);

-- 테이블 Comment 설정 SQL - tb_behavior_guide
ALTER TABLE tb_behavior_guide COMMENT '행동 가이드';

-- Foreign Key 설정 SQL - tb_behavior_guide(id) -> tb_driver_habit(id)
ALTER TABLE tb_behavior_guide
    ADD CONSTRAINT FK_tb_behavior_guide_id_tb_driver_habit_id FOREIGN KEY (id)
        REFERENCES tb_driver_habit (id) ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Foreign Key 삭제 SQL - tb_behavior_guide(id)
-- ALTER TABLE tb_behavior_guide
-- DROP FOREIGN KEY FK_tb_behavior_guide_id_tb_driver_habit_id;


