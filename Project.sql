set SERVEROUTPUT ON;
CREATE TABLE course_schedule(
    DERS_KOD VARCHAR(50),
    YEAR_SUBJECT NUMBER,
    TERM NUMBER,
    DERS_S_ID NUMBER,
    SECTION VARCHAR(50),
    MIN_START_TIME TIMESTAMP(6)
    );
    
CREATE TABLE course_sections(
    DERS_SOBE_ID NUMBER,
    DERS_KOD VARCHAR(50),
    YEAR_SUBJECT NUMBER,
    TERM NUMBER,
    SECTION VARCHAR(50),
    TYPE_SECTION VARCHAR(5),
    EMP_ID NUMBER,
    MESSAGE VARCHAR(100),
    WEEK_NUM NUMBER,
    HOUR_NUM NUMBER,
    PACKET_DERS NUMBER,
    ATTEND_TYPE NUMBER,
    PAID_SECTION NUMBER,
    EMP_ID_ENT NUMBER,
    LAST_MODIFIED TIMESTAMP(6),
    CREDIT NUMBER
    );
    
CREATE TABLE COURSE_SELECTIONS(
    STUD_ID VARCHAR(50), 
	DERS_KOD VARCHAR2(50),
	YEAR_SUBJECT NUMBER, 
	TERM NUMBER, 
	SECTION VARCHAR2(50), 
    LAB_SOBE_ID NUMBER,
	QIYMET_YUZ NUMBER, 
	QIYMET_HERF VARCHAR2(2), 
	GRADING_TYPE_PNP VARCHAR2(10), 
    ATTENDED NUMBER,
	PRACTICE NUMBER, 
	REG_DATE TIMESTAMP(6)
   );
    


--======================

--3)
CREATE OR REPLACE PROCEDURE CAL_GPA(p_studid IN VARCHAR,p_first OUT NUMBER,p_second OUT NUMBER,p_total OUT NUMBER) IS
CURSOR C_STUD(ssid varchar,v_c number) IS
SELECT STUD_ID,SUM(R)/SUM(Q) FROM(
SELECT L.STUD_ID,CASE SUM(S.cc)
WHEN 0 THEN 5 ELSE SUM(S.cc) END *(CASE (L.QIYMET_HERF)
WHEN 'A' THEN 4 WHEN 'A-' THEN	3.67
WHEN 'B+' THEN	3.33 WHEN 'B' THEN	3 WHEN 'B-' THEN	2.67 
WHEN 'C+' THEN	2.33  WHEN 'C' THEN	2
WHEN 'C-' THEN	1.67 WHEN 'D+' THEN	1.33  WHEN 'D' THEN	1
END ) AS R,CASE SUM(S.cc) WHEN 0 THEN 5 ELSE SUM(S.cc) END AS Q,TERM
FROM (SELECT DISTINCT(STUD_ID),min(DERS_KOD) AS QWE,QIYMET_HERF,TERM FROM course_selections 
WHERE qiymet_herf!='IP' AND QIYMET_HERF!='FX' AND QIYMET_HERF!='P'
AND QIYMET_HERF!='AW' AND QIYMET_HERF!='F' and QIYMET_HERF!='NP' and term=v_c GROUP BY STUD_ID,QIYMET_HERF,TERM) L JOIN
(SELECT DISTINCT(DERS_KOD),NVL(MIN(credit),5) as cc FROM course_sections GROUP BY DERS_KOD) S ON(QWE=S.DERS_KOD)
GROUP BY STUD_ID,L.QIYMET_HERF,TERM ORDER BY l.stud_id DESC) where stud_id=ssid GROUP BY STUD_ID;
    v_gpa1 NUMBER;
    v_gpa2 NUMBER;
    v_mc1 VARCHAR(50);
    v_mc2 VARCHAR(50);
   BEGIN 
    open c_stud(p_studid,1);
        loop   
        FETCH c_stud INTO v_mc1,v_gpa1;
        EXIT WHEN c_stud%notfound;
        p_first:=v_gpa1;
        end loop;
    close c_stud;
    open c_stud(p_studid,2);
        loop   
        FETCH c_stud INTO v_mc2,v_gpa2;
        EXIT WHEN c_stud%notfound;
        p_second:=v_gpa2;
        end loop;
    close c_stud;
    p_total:=p_first+p_second;
    END;
--3)test
DECLARE
    Q NUMBER;
    Q2 NUMBER;
    Q3 NUMBER;
BEGIN
cal_gpa('E2DBDAC1E60F2C8C6BA35B3B9CACBC2FA7E5C666',Q,Q2,Q3);
DBMS_OUTPUT.put_line(Q);
DBMS_OUTPUT.put_line(Q2);
DBMS_OUTPUT.put_line(Q3);
END;

--======================================


--5)

create or replace procedure cal_stud_ret(p_studid IN VARCHAR,p_first OUT NUMBER,p_second OUT NUMBER,p_total OUT NUMBER)  is
cursor c_ret(studid varchar,v_term number) is 
    SELECT STUD_ID,Q*15000 FROM 
(select L.TERM,L.STUD_ID,CASE SUM(S.cc) WHEN 0 THEN 5 ELSE SUM(S.cc) END AS Q 
from course_selections L JOIN (SELECT DISTINCT(DERS_KOD),NVL(MIN(credit),5) as cc 
FROM course_sections GROUP BY DERS_KOD) S ON(l.ders_kod=S.DERS_KOD) 
WHERE QIYMET_HERF='F' GROUP BY L.STUD_ID,TERM ORDER BY L.TERM ,Q DESC) WHERE stud_id=studid and term=v_term;
v_t NUMBER;
v_gpa1 NUMBER;
v_gpa2 NUMBER;
v_mc1 VARCHAR(50);
v_mc2 VARCHAR(50);
   BEGIN 
    open c_ret(p_studid,1);
        loop   
        FETCH c_ret INTO v_mc1,v_gpa1;
        EXIT WHEN c_ret%notfound;
        p_first:=v_gpa1;
        end loop;
    close c_ret;
    open c_ret(p_studid,2);
        loop   
        FETCH c_ret INTO v_mc2,v_gpa2;
        EXIT WHEN c_ret%notfound;
        p_second:=v_gpa2;
        end loop;
    close c_ret;
    p_total:=p_first+p_second;
end;
/
--5)test
DECLARE
    Q NUMBER;
    Q2 NUMBER;
    Q3 NUMBER;
BEGIN
cal_stud_ret('5FCC3A32EBB8E37CB7532E22EAD3D46915ACA67B',Q,Q2,Q3);
DBMS_OUTPUT.put_line(Q);
DBMS_OUTPUT.put_line(Q2);
DBMS_OUTPUT.put_line(Q3);
END;

--======================================








--4)
CREATE TYPE no_subj IS TABLE OF varchar(50);

create or replace function cal_no_subj(p_term number) return no_subj
is
v_no_subj no_subj:=no_subj();
student_id course_selections.stud_id%type;
c number:=1;
cursor c_nr is
select s.stud_id from 
(select stud_id,count(ders_kod) as a from course_selections where term=p_term and qiymet_herf='IP' group by stud_id) f join
(select stud_id,count(ders_kod) as j  from course_selections where term=p_term group by stud_id) s on(f.stud_id=s.stud_id) where (j-a)=0;
begin
    open c_nr;
    LOOP
    FETCH c_nr INTO student_id;
    EXIT WHEN c_nr%NOTFOUND;
    v_no_subj.extend;
    v_no_subj(c):=student_id;
    c:=c+1;
    END LOOP;
    close c_nr;
    return v_no_subj;
end;

select * from table (cal_no_subj(2));
    

--9)
create or replace TYPE studcredit IS OBJECT (stid varchar(50),curs number,credit number);
create or replace type array_t is varray(1000) of studcredit;

create or replace function will_sel return array_t is
v_array array_t:=array_t();
cursor c_info is
    SELECT L.STUD_ID,COUNT(DERS_KOD) AS A,SUM(S.CREDIT) AS CRED FROM (SELECT STUD_ID,MAX(DERS_KOD) AS Q FROM course_selections 
WHERE qiymet_herf!='IP' AND QIYMET_HERF!='FX' AND QIYMET_HERF!='P' GROUP BY STUD_ID,DERS_KOD) L JOIN
(select distinct(ders_kod),nvl(sum(credit),5) as credit from 
course_sections group by ders_kod) S ON(Q=S.DERS_KOD)
GROUP BY STUD_ID ORDER BY l.stud_id DESC FETCH FIRST 1000 ROWS ONLY;
    m number;
begin
    m:=1;
    for i in c_info loop
       v_array.extend;
       v_array(m):=studcredit(i.stud_id,i.a,i.cred);
       m:=m+1;
     end loop;
     return v_array;
end;

select * from table (will_sel);


--12)

create or replace TYPE subj IS OBJECT (sterm number,ders_kod varchar(50),ders_c number);
create or replace TYPE subj_t IS TABLE OF subj;
create or replace FUNCTION subj_reit RETURN subj_t IS
    v_subj_t subj_t:=subj_t();
    c number;
  BEGIN
  c:=1;
    FOR i IN(select term,ders_kod,count(ders_kod) as cc from course_selections group by ders_kod,term order by term,count(ders_kod) desc) LOOP
        v_subj_t.extend;
        v_subj_t(c):=subj(i.term,i.ders_kod,i.cc);
        c:=c+1;
    END LOOP;
    RETURN v_subj_t;
  END subj_reit;

select * from table (subj_reit);


--11)
    
create or replace TYPE teacher IS OBJECT (sterm number,ders_kod varchar(50),teachid number,ders_c number);
create or replace TYPE teach_t IS TABLE OF teacher;
create or replace FUNCTION teach_reit RETURN teach_t IS
    v_teach_t teach_t:=teach_t();
    c number;
  BEGIN
  c:=1;
    FOR i IN(select term,ders_kod,practice,count(ders_kod) as cc 
    from course_selections group by ders_kod,term,practice order by term,count(ders_kod) desc) LOOP
        v_teach_t.extend;
        v_teach_t(c):=teacher(i.term,i.ders_kod,i.practice,i.cc);
        c:=c+1;
    END LOOP;
    RETURN v_TEACH_t;
  END;
select * from table (teach_reit);


--1)
CREATE OR REPLACE TYPE POP_LIST IS object(DERS_KOD VARCHAR(50),STUDENTS NUMBER,PRACTICE number,reg_date date);
CREATE OR REPLACE TYPE POP_TABLE IS TABLE OF POP_LIST;

CREATE or REPLACE function most_pop_course(p_term IN number,p_year IN number) return pop_table is
v_list pop_table:=pop_table();
cursor c_info is
select ders_kod,count(stud_id) as cs, nvl(practice,0) as p,min(reg_date) as rg from course_selections  
where term=p_term and year_subject=p_year group by ders_kod,practice 
order by count(stud_id) desc,min(reg_date) asc;
c number:=1;
begin
    for i in c_info loop
        v_list.extend;
        v_list(c):=pop_list(i.ders_kod,i.cs,i.p,i.rg);
        c:=c+1;
    end loop;
    return v_list;
end;

select * from table (most_pop_course(1,2019));

    
   
   
--2)
CREATE OR REPLACE TYPE POP_TEACHER IS object(DERS_KOD VARCHAR(50),PRACTICE NUMBER,EMP_ID number);
CREATE OR REPLACE TYPE POP_T_TEACH IS TABLE OF POP_TEACHER;

CREATE or REPLACE function most_pop_teacher(p_term IN number,p_year IN number,p_course in varchar) return POP_T_TEACH is
v_list POP_T_TEACH:=POP_T_TEACH();
cursor c_info is
select l.ders_kod ,l.practice,s.emp_id from course_selections l 
join (select distinct(ders_kod),emp_id from course_sections ) s on(l.ders_kod=s.ders_kod)
where l.term=p_term and l.year_subject=p_year and l.ders_kod=p_course group by l.ders_kod,l.practice,s.emp_id
order by count(l.stud_id) desc,min(l.reg_date) asc;
c number:=1;
begin
    for i in c_info loop
        v_list.extend;
        v_list(c):=POP_TEACHER(i.ders_kod,i.practice,i.EMP_ID);
        c:=c+1;
    end loop;
    return v_list;
end;

select * from table (most_pop_TEACHER(1,2019,'ACC 203'));


--6)
create or replace TYPE teacher_time IS OBJECT (p_term number ,tid number,thour number);
create or replace TYPE time_t IS TABLE OF teacher_time;
create or replace function teacher_hour(p_term number,tid number) return time_t 
is
v_time_t time_t:=time_t();
n number;
begin
    n:=1;
    for i in (select term,e,sum(h) as sag from(select nvl(emp_id,0) as e,nvl(hour_num,0) as h,term from course_sections group by term,emp_id,hour_num order by emp_id,hour_num desc)
    where term=p_term and e=tid group by e,term order by e asc) loop
        v_time_t.extend;
        v_time_t(n):=teacher_time(i.term,i.e,i.sag);
        n:=n+1;
    end loop;
    return v_time_t;
end;
/
select * from table (teacher_hour(1,10009));





--7)


create or replace TYPE s_teacher IS OBJECT (tid varchar(100),ders varchar(50),dataa TIMESTAMP(5));
create or replace TYPE table_for_t IS TABLE OF s_teacher;
create or replace function create_teacher_t(p_tid varchar,p_year number,p_term number) 
return table_for_t is    
cursor c_t is
       SELECT DISTINCT s.emp_id,h.ders_kod,h.min_start_time as les_time
        FROM course_schedule h JOIN course_sections s 
        ON (h.ders_kod = s.ders_kod)
        where s.emp_id=p_tid and p_year=s.year_subject and p_term=s.term and
        h.section=s.section and p_year=h.year_subject and p_term=h.term;
        
        c number;
        v_t  table_for_t:=table_for_t();
begin
c:=1;
    FOR I IN C_T LOOP
        v_t.extend;
        v_t(c):=s_teacher(i.emp_id,i.ders_kod,i.les_time);
        c:=c+1;
    END LOOP;
    return v_t;
end;
select * from table (create_teacher_t(10057,2019,1));




--8)
create or REPLACE TYPE student IS OBJECT(stid varchar(100),ders varchar(50),dataa TIMESTAMP(5));
create or REPLACE TYPE table_for_s IS TABLE OF student;

create or replace function create_student_t(p_sid varchar,p_year number,p_term number) 
return table_for_s is    
cursor c_t is
       SELECT DISTINCT s.stud_id,h.ders_kod,h.min_start_time as les_time
        FROM course_schedule h JOIN course_selections s 
        ON (h.ders_kod = s.ders_kod)
        where s.stud_id=p_sid and p_year=s.year_subject and p_term=s.term and
        h.section=s.section and p_year=h.year_subject and p_term=h.term;
        
        c number;
        v_t  table_for_s:=table_for_s();
begin
c:=1;
    FOR I IN C_T LOOP
        v_t.extend;
        v_t(c):=student(i.stud_id,i.ders_kod,i.les_time);
        c:=c+1;
    END LOOP;
    return v_t;
end;

    
    
--10) 13)
CREATE OR REPLACE PACKAGE pac_calc AS  
   PROCEDURE avg_reit(tid out number,ders out varchar,ball out number);
   FUNCTION CAL_RETAKE RETURN NUMBER;
end pac_calc;

CREATE OR REPLACE PACKAGE BODY pac_calc AS 
PROCEDURE avg_reit(tid out number,ders out varchar,ball out number) is
begin
    for i in(select practice,ders_kod,nvl(avg(qiymet_yuz),0) as bal FROM 
    course_selections group by practice,ders_kod order by nvl(avg(qiymet_yuz),0) desc) loop
    tid:=i.practice;
    ders:=i.ders_kod;
    ball:=i.bal;
    end loop;
end;

FUNCTION CAL_RETAKE RETURN NUMBER
IS
RETAKE_SUM NUMBER:=0;
BEGIN
    FOR I IN (select DISTINCT(ders_kod) AS v_ders_kod,MAX(CREDIT) AS MCREDIT from course_sections GROUP BY DERS_KOD) LOOP
        FOR J IN (select ders_kod from course_selections where QIYMET_HERF='F' AND DERS_KOD=I.V_DERS_KOD) LOOP
            IF(I.MCREDIT!=0 AND I.MCREDIT IS NOT NULL) THEN
            RETAKE_SUM:=RETAKE_SUM+15000*I.MCREDIT;
            ELSE 
            RETAKE_SUM:=RETAKE_SUM+75000;
            END IF;
        END LOOP;
    END LOOP;
    return retake_sum;
END;
end;

--FOLLOWONG TABLE FOR FOLLOW CREATE OBJ WITH BACKEND

CREATE TABLE F_TABLE (
    log_id NUMBER,
    DB_NAME VARCHAR(100),
    NAME_OBJ VARCHAR(100),
    DB_OWN VARCHAR(100),
    TYPE_OBJ VARCHAR(100),
    OPERATION VARCHAR(100),
    OPER_DATE DATE
);
CREATE OR REPLACE TRIGGER LOG_TRIGGER
AFTER CREATE ON SCHEMA
BEGIN
    INSERT INTO f_table (log_id,DB_NAME,NAME_OBJ ,DB_OWN,TYPE_OBJ,OPERATION,OPER_DATE)
    VALUES(ORA_CLIENT_IP_ADDRESS,ORA_DATABASE_NAME,ORA_DICT_OBJ_NAME,ORA_DICT_OBJ_OWNER,ORA_DICT_OBJ_TYPE,ORA_SYSEVENT,SYSDATE);
END;

CREATE TABLE M(NN NUMBER);




    