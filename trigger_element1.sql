create or replace trigger BARS_739.TRG_ELEMENT_BEFORE
    before update or delete on BARS_739.ELEMENT
    for each row
declare
  p_SQL_TEXT BARS_739.ELEMENT_HISTORY.SQL_TEXT%TYPE;
begin

    IF DELETING THEN p_SQL_TEXT:='DELETE';
    ELSIF UPDATING THEN p_SQL_TEXT:='UPDATE';
    ELSIF INSERTING THEN p_SQL_TEXT:='INSERT';
    ELSE p_SQL_TEXT:=' ';
    END IF;

    IF NOT (UPDATING AND SUBSTR(SYS_CONTEXT('USERENV', 'MODULE'),1,4)='JDBC') THEN

    -- Вставка результата в таблицу истории
    insert into BARS_739.ELEMENT_HISTORY (ID,ELEMENTTYPE_ID,DOC_ID,VALUE,DATEEL,ELEMENT_ORDER,USERS_ID,ISDELETED,FLAG,DATE_DOC,
                                          OS_USER,PROGR,UPD_DATE,SQL_TEXT,SESSION_ID)
        values (:OLD.ID,:OLD.ELEMENTTYPE_ID,:OLD.DOC_ID,:OLD.VALUE,:OLD.DATEEL,:OLD.ELEMENT_ORDER,:OLD.USERS_ID,:OLD.ISDELETED,:OLD.FLAG,:OLD.DATE_DOC,
                SYS_CONTEXT('USERENV', 'OS_USER'), 
                SYS_CONTEXT('USERENV', 'MODULE'),
                SYSDATE,
                --SYS_CONTEXT('USERENV', 'CURRENT_SQL')
                p_SQL_TEXT,
				SYS_CONTEXT('USERENV', 'SESSIONID')
                );
				
	END IF;			

end TRG_ELEMENT_BEFORE;
