
[GET]
declare
    emp_cursor SYS_REFCURSOR;
begin
    -- select count(*)
    -- into  v_cnt
    -- from hm_codes
    -- where grp = 'AUTHORIZATION_KEY'
    -- and  code_id = :Authorization;

    -- if v_cnt = 1 then
    
    open emp_cursor for
        select empno, ename
        from emp;

    APEX_JSON.open_object;
    APEX_JSON.write('code', 'R001');
    APEX_JSON.write('message', 'SUCCESS');
    APEX_JSON.write('items', emp_cursor);
    APEX_JSON.close_object;

exception when others then
    APEX_JSON.open_object;
    APEX_JSON.write('code', 'E001');
    APEX_JSON.write('message', 'Authorization Fail');
    APEX_JSON.close_object;
    
end;

[POST]
create or replace PROCEDURE PROC_JSON_DATA
(
   P_DATA BLOB
)
IS
/* 
   목적 : Playwright (HTTP POST) 매장별 매출 데이타 처리 프로시져
   파라메타 : p_data (json object)
*/
    v_payment_name varchar(100);
    v_store_name varchar(100);
    v_c_date varchar(100);
    v_cnt number default 1;
    V_msg varchar2(1000);
    v_id varchar2(100);
BEGIN

/* 
   JSON에서 결제수단, 매장, 매출일자를 추출한다.
*/
    SELECT payment_name, store_name, c_date
    into   v_payment_name, v_store_name, v_c_date
    FROM   json_table(p_data FORMAT JSON, '$'
           COLUMNS (
             payment_name  VARCHAR2   PATH '$.payment_name',
             store_name   VARCHAR2 PATH '$.store_name',
             c_date   NUMBER PATH '$.c_date'));

/* 
  중복데이타를 체크하여 존재하면 이전 데이타는 삭제한다.
  Playwright 2회 문제 해결
*/
    begin
        select count(*)
        into   v_cnt
        from  json_data j
        where j.json_document.payment_name = v_payment_name 
        and j.json_document.store_name = v_store_name 
        and j.json_document.c_date = v_c_date;
    exception when others then
       v_cnt := 0;
    end;

    if v_cnt > 0 then
        delete 
        from  json_data j
        where j.json_document.payment_name = v_payment_name 
        and j.json_document.store_name = v_store_name 
        and j.json_document.c_date = v_c_date;
    end if;

 /* 
  JSON object를 저장한다.
  Playwright 2회 문제 해결
*/
    insert into json_data
    (id, created_on, last_modified, version, json_document)
    values
    (sys_guid(), current_date, current_date, sys_guid(), P_DATA);

    APEX_JSON.open_object; 
    APEX_JSON.write('code', 'R001');
    APEX_JSON.write('message', 'SUCCESS');
    APEX_JSON.close_object; 

EXCEPTION WHEN OTHERS THEN
    V_MSG := SQLERRM;
    APEX_JSON.open_object; 
    APEX_JSON.write('code', 'E001');
    APEX_JSON.write('message', V_MSG);
    APEX_JSON.close_object; 

END PROC_JSON_DATA;

