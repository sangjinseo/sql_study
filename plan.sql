-- 친절한 SQL 튜닝 기반 스터디
-- 실행계획과 사용
-- 임시테이블 생성
create table t
as
select d.no, e.*
  from scott.emp e
      ,(select rownum no from dual connect by level <= 1000) d;

-- 인덱스생성 2개
create index t_x01 on t(deptno, no);
create index t_x02 on t(deptno, job, no);

-- t 테이블에대한 통계수집 명령어
exec dbms_stats.gather_table_stats( user, 't');

-- autotrace 활성화 set
set autotrace traceonly exp;

> select * from t
   where deptno = 10
    and  no = 1;
    -- cost 2 
    -- index T_X01 을 탐..
    -- 왜 t_x01을 탔을까..

> select /*+ index(t t_x02) */ * from t
    where deptno = 10
      and no = 1;
    -- cost 29 
-- full scan 을 타도록 해보면

  select /*+ full(t) */ * from t 
    where deptno = 10
      and no = 1;
    -- cost 29 가 발생

###p27 페이지부터 공부할것 ( 표 )
