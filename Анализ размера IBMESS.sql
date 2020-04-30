--UTL_COMPRESS - ZIP data
--------------------------------------------------------------------------------

DECLARE
   v_tmp_blob_in          BLOB;
   v_tmp_blob_out         BLOB;
   v_size_before          NUMBER:=0;
   v_size_after           NUMBER:=0;
   v_size_before_full     NUMBER := 0;
   v_size_after_full      NUMBER := 0;
   v_result_zip_percent   NUMBER := 0;
   v_cnt                  NUMBER := 0;
   v_cnt_full             NUMBER := 0;
   v_doc_type             DT.NAME%TYPE:=' '; 
BEGIN
    dbms_output.enable(999000);
    
   DBMS_OUTPUT.PUT_LINE('START_ZIP---IBMESS-------');

  FOR curs_row IN (SELECT tbl.*, 'файл' as name
                      FROM BARS_739.IBMESS tbl
                     WHERE tbl.MESS_FILE IS NOT NULL --and rownum<1000
                     order by name) --NEED CHANGE TABLE NAME and BLOB NAME!!!!!!!!

   LOOP
      IF v_doc_type not in (' ',curs_row.name) THEN
          DBMS_OUTPUT.PUT_LINE (
                'BEFORE_ALL='
             || TO_CHAR(v_size_before,'999,999,999,990')
             || '. AFTER_ALL='
             || TO_CHAR (v_size_after,'999,999,999,990')
             || '. BEFORE_AVG='
             || TO_CHAR(round(v_size_before/v_cnt,0),'999,999,999,990')
             || '. AFTER_AVG='
             || TO_CHAR(round(v_size_after/v_cnt,0),'999,999,999,990') || '. Count: '|| TO_CHAR (v_cnt,'999,999,990')
             || '. После сжатия останется:' || to_char(CEIL(v_size_after * 100 / CASE WHEN v_size_before=0 THEN 9999999999 ELSE v_size_before END),'999,990')
             || ' %. Тип док-та: ' || v_doc_type);
          v_size_before_full := v_size_before_full + v_size_before;
          v_size_after_full := v_size_after_full + v_size_after;
          v_size_before := 0;
          v_size_after := 0;
          v_cnt:=0;
      END IF;
      
      v_doc_type :=curs_row.name;
      v_tmp_blob_in := curs_row.MESS_FILE;           --NEED CHANGE BLOB FIELD NAME!!!!!!!!
      v_size_before := v_size_before + DBMS_LOB.GETLENGTH (v_tmp_blob_in);
      v_tmp_blob_out := UTL_COMPRESS.lz_compress (v_tmp_blob_in);
      v_size_after := v_size_after + DBMS_LOB.GETLENGTH (v_tmp_blob_out);
      v_cnt:=v_cnt+1;

      v_cnt_full := v_cnt_full + 1;
   END LOOP;
          v_size_before_full := v_size_before_full + v_size_before;
          v_size_after_full := v_size_after_full + v_size_after;
   
             DBMS_OUTPUT.PUT_LINE (
                'BEFORE_ALL='
             || TO_CHAR(v_size_before,'999,999,999,990')
             || '. AFTER_ALL='
             || TO_CHAR (v_size_after,'999,999,999,990')
             || '. BEFORE_AVG='
             || TO_CHAR(round(v_size_before/v_cnt,0),'999,999,999,990')
             || '. AFTER_AVG='
             || TO_CHAR(round(v_size_after/v_cnt,0),'999,999,999,990') || '. Count: '|| TO_CHAR (v_cnt,'999,999,990')
             || '. После сжатия останется:' || to_char(CEIL(v_size_after * 100 / CASE WHEN v_size_before=0 THEN 9999999999 ELSE v_size_before END),'999,990')
             || ' %. Тип док-та: ' || v_doc_type);

   DBMS_OUTPUT.PUT_LINE('END_ZIP----IBMESS---------');
      
             DBMS_OUTPUT.PUT_LINE (
                'BEFORE_ALL='
             || TO_CHAR(v_size_before_full,'999,999,999,990')
             || '. AFTER_ALL='
             || TO_CHAR (v_size_after_full,'999,999,999,990')
             || '. BEFORE_AVG='
             || TO_CHAR(round(v_size_before_full/v_cnt_full,0),'999,999,999,990')
             || '. AFTER_AVG='
             || TO_CHAR(round(v_size_after_full/v_cnt_full,0),'999,999,999,990') || '. Count: '|| TO_CHAR (v_cnt_full,'999,999,990'));


   IF v_size_after_full != 0
   THEN
      v_result_zip_percent :=
         CEIL (v_size_after_full * 100 / v_size_before_full);
   END IF;

   DBMS_OUTPUT.PUT_LINE (
      'ZIP PERCENT=' || TO_CHAR (v_result_zip_percent) || '%');
   DBMS_OUTPUT.PUT_LINE('END--------IBMESS---------');

END;
--------------------------------------------------------------------------------