delimiter $$
	create procedure user_proc()
		begin
			select * from member;
		end $$
delimiter ;

call user_proc();
drop procedure user_proc;
drop procedure user_proc3;

delimiter $$
	create procedure user_proc1(in userName varchar(10))
		begin
		
			select * from member where mem_name = userName;
		
		end $$
	
    create procedure user_proc3(in txtValue char(10), out outValue int)
		begin
			insert into noTable values(null, txtValue);
            select max(id) into outValue from noTable;
            -- noTable테이블의 id값 중 제일 큰 값을 outValue변수에 넣어라
        end $$
        
	create procedure ifelse_proc(in memName varchar(10))
		begin
			declare debutYear int;
            -- 지역변수생성
            
            select year(debut_date) into debutYear from member
				where mem_name = memName;
			-- member테이블에서 멤버네임과 파라미터이름이 같은 로우의
            -- debut_date를 가져와 년도만 추출하여 debutYear 변수에 담아라
			
            if(debutYear >=2015) then
				select '신인 가수, 화이팅~' as msg;
			else
				select '고참 가수, 수고요~' as msg;
			end if;
        end $$
        
	create procedure dynamic_proc(in tableName varchar(20))
		begin
            set @sqlQurey = concat('select * from ', tableName);
            -- 사용자 변수생성
            prepare myQuery from @sqlQurey;
            execute myQuery;
            deallocate prepare myQuery;
        end $$
delimiter ;

drop procedure dynamic_proc;
call user_proc1('블랙핑크');

create table noTable(
	id int auto_increment primary key,
	txt char(10)
);

call user_proc3('test1', @myValue);
call user_proc3('test2', @myValue);
call user_proc3('test3', @myValue);
select concat('입력된 id 값 ==>',@myValue) as meg;

drop table noTable;

call ifelse_proc('오마이걸');
call dynamic_proc('member');

set global log_bin_trust_function_creators = 1;
use market_db;

-- 이 안에서 스토어드 프로시저나 함수 작성 가능
delimiter $$
	create function sumFunc(number1 int, number2 int) returns int
		begin
			return number1 + number2;
		end $$
		
	create function calcYearFunc(dYear int) returns int
		begin
			declare runYear int; -- 변수생성
            set runYear = year(curdate()) - dYear;
            return runYear;
        end $$
        
	create procedure cursor_proc()
		begin
			declare memNumber int;
            declare cnt int default 0; -- 변수선언과 초기화
            declare total int default 0;
            declare endOfRow boolean default false;
            
            declare memberCursor cursor for
				select mem_number from member;
                
			declare continue handler for
				not found set endOfRow = true;
                
			open memberCursor;
            
            cursor_loop: Loop
				fetch memberCursor into memNumber;
                
                if endOfRow then
					leave cursor_loop; -- break
				end if;
                
                set cnt = cnt + 1;
                set total = total + memNumber;
			END loop cursor_loop;
            
            select (total/cnt) as '회원의 평균 인원 수';
            
            close memberCursor;
        end $$
        
        CREATE TRIGGER myTrigger
			AFTER DELETE ON trigger_table FOR EACH ROW
            BEGIN
				SET @msg = '가수 그룹이 삭제됨';
            END $$
            
		create trigger singer_updateTrg
			after update on singer for each row
            begin
				insert into backup_singer values(old.mem_id, old.mem_name,
					old.mem_number, old.addr, '수정', curdate(), current_user());
            end $$
		
        create trigger singer_deleteTrg
			after delete on singer for each row
            begin
				insert into backup_singer values(old.mem_id, old.mem_name,
					old.mem_number, old.addr, '삭제', curdate(), current_user());
            end $$
delimiter ;

select sumFunc(100, 200) as '합계';
select calcYearFunc(2010) as '활동 햇수';

select calcYearFunc(2007) into @debut2007;
select calcYearFunc(2013) into @debut2013;
select @debut2007-@debut2013 as '2007과 2013차이';

-- 함수 체이닝
select mem_id, mem_name, calcYearFunc(year(debut_date)) as '활동 햇수' from member;

drop function calcYearFunc;

call cursor_proc();
select mem_id, mem_number from member;

USE market_db;

CREATE TABLE IF NOT EXISTS trigger_table(
	id INT,
    txt VARCHAR(10)
);

INSERT INTO trigger_table VALUES(1,'레드벨벳');
INSERT INTO trigger_table VALUES(2,'잇지');
INSERT INTO trigger_table VALUES(3,'블랙핑크');

SET @msg = '';
INSERT INTO trigger_table values(4, '마마무');

UPDATE trigger_table SET txt = '블랙핑크' WHERE id = 3;

DROP TRIGGER myTrigger;

DELETE FROM trigger_table WHERE id=4;
SELECT @msg;

CREATE TABLE singer (select mem_id, mem_name, mem_number, addr FROM member);
create table backup_singer(
	mem_id char(8) not null,
    mem_name varchar(10) not null,
    mem_number int not null,
    addr char(2) not null,
    modType char(2), -- 변경한 타입, 직접 입력
    modDate date,	-- 변경한 날짜
    modUser varchar(30) -- 변경한 사용자
);

update singer set addr = '영국' where mem_id='BLK';
delete from singer where mem_number >= 7;
select * from backup_singer;

truncate table singer;
-- 테이블은 남겨놓고 알맹이만 지우지만 delete는 아니기 때문에 백업이 안된다
