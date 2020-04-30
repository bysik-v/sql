DROP TRIGGER BARS_739.TRG_ELEMENT_INSERT_BEFORE;

CREATE OR REPLACE TRIGGER BARS_739.TRG_ELEMENT_INSERT_BEFORE
    before insert on BARS_739.ELEMENT
    for each row
declare
  p_dt_id NUMBER;
  p_det_id NUMBER;
  ex_custom       EXCEPTION;
begin

    SELECT /*+ leading(d dt det) use_nl(d dt det)*/ 
    max(dt.id),max(det.id) into p_dt_id,p_det_id
    FROM BARS_739.DOC d, dt, det
    WHERE d.id=:NEW.DOC_ID and dt.ID=d.DOCTYPE_ID and dt.id=det.dt_id(+) and
    det.id(+)=:NEW.ELEMENTTYPE_ID;
    IF p_det_id is null THEN
        raise_application_error(-20001,'Elementtype_id('||to_char(:NEW.ELEMENTTYPE_ID)||') does not match DOC_TYPE('||to_char(p_dt_id)||')');
    END IF;
end TRG_ELEMENT_BEFORE;
/
