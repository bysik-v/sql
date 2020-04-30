create or replace trigger BARS_739.TRG_DOC_BEFORE
    before update or delete on BARS_739.DOC
    for each row
declare
  p_SQL_TEXT BARS_739.DOC_HISTORY.SQL_TEXT%TYPE;
begin

    IF DELETING THEN p_SQL_TEXT:='DELETE';
    ELSIF UPDATING THEN p_SQL_TEXT:='UPDATE';
    ELSIF INSERTING THEN p_SQL_TEXT:='INSERT';
    ELSE p_SQL_TEXT:=' ';
    END IF;

    -- Вставка результата в таблицу истории
    insert into BARS_739.DOC_HISTORY (ID,DOCTYPE_ID,NUM_DOC,DATE_DOC,STATUS,FLAG,PARENT_ID,USERS_ID,
  OS_USER,PROGR,UPD_DATE,SQL_TEXT,SESSION_ID)
        values (:OLD.ID,:OLD.DOCTYPE_ID,:OLD.NUM_DOC,:OLD.DATE_DOC,:OLD.STATUS,:OLD.FLAG,:OLD.PARENT_ID,:OLD.USERS_ID, 
                SYS_CONTEXT('USERENV', 'OS_USER'), 
                SYS_CONTEXT('USERENV', 'MODULE'),
                SYSDATE,
                --SYS_CONTEXT('USERENV', 'CURRENT_SQL')
                p_SQL_TEXT,
                SYS_CONTEXT('USERENV', 'SESSIONID')
                );

end TRG_DOC_BEFORE;