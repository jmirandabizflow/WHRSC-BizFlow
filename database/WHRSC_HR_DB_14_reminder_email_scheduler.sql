--BEGIN
--DBMS_SCHEDULER.DISABLE('EMAIL_RECRUIT_PRE_VALID');
--DBMS_SCHEDULER.DISABLE('EMAIL_RECRUIT_SLA_POST');
--DBMS_SCHEDULER.DISABLE('EMAIL_RECRUIT_SLA_CERT_EX');
--DBMS_SCHEDULER.DISABLE('EMAIL_RECRUIT_JOB_TENT');
--DBMS_SCHEDULER.DISABLE('EMAIL_RECRUIT_SLA_DECS_EX');
--END;
--/

----------------------------------------------------------------------------
--  Oracle Scheduler to Create Jobs to execute Reminder Email Procedures
----------------------------------------------------------------------------
----------------------------------------------------------------------------

--------------------------------------------------------
--  DDL for Job EMAIL_RECRUIT_PRE_VALID
--------------------------------------------------------
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            JOB_NAME => 'EMAIL_RECRUIT_PRE_VALID',
            JOB_TYPE => 'STORED_PROCEDURE',
            JOB_ACTION => 'SP_JOB_RECRUITMENT_PRE_VALID',
            START_DATE => SYSTIMESTAMP,
            REPEAT_INTERVAL => 'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI;BYHOUR=6;BYMINUTE=0;BYSECOND=0;',
            ENABLED => TRUE,
            COMMENTS => 'Oracle Job: Email - Number of days to Validate Need');
END;
/
--------------------------------------------------------
--  DDL for Job EMAIL_RECRUIT_SLA_POST
--------------------------------------------------------
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            JOB_NAME => 'EMAIL_RECRUIT_SLA_POST',
            JOB_TYPE => 'STORED_PROCEDURE',
            JOB_ACTION => 'SP_JOB_RECRUITMENT_SLA_POST',
            START_DATE => SYSTIMESTAMP,
            REPEAT_INTERVAL => 'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI;BYHOUR=6;BYMINUTE=0;BYSECOND=0;',
            ENABLED => TRUE,
            COMMENTS => 'Oracle Job: Email - Post Vacancy(MP and DE) within 2 Calendar Days');
END;
/
--------------------------------------------------------
--  DDL for Job EMAIL_RECRUIT_SLA_CERT_EX
--------------------------------------------------------
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            JOB_NAME => 'EMAIL_RECRUIT_SLA_CERT_EX',
            JOB_TYPE => 'STORED_PROCEDURE',
            JOB_ACTION => 'SP_JOB_RECRUITMENT_SLA_CERT_EX',
            START_DATE => SYSTIMESTAMP,
            REPEAT_INTERVAL => 'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI;BYHOUR=6;BYMINUTE=0;BYSECOND=0;',
            ENABLED => TRUE,
            COMMENTS => 'Oracle Job: Email - Cert Expires HRS Notification');
END;
/
--------------------------------------------------------
--  DDL for Job EMAIL_RECRUIT_JOB_TENT
--------------------------------------------------------
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            JOB_NAME => 'EMAIL_RECRUIT_JOB_TENT',
            JOB_TYPE => 'STORED_PROCEDURE',
            JOB_ACTION => 'SP_JOB_RECRUITMENT_JOB_TENT',
            START_DATE => SYSTIMESTAMP,
            REPEAT_INTERVAL => 'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI;BYHOUR=6;BYMINUTE=0;BYSECOND=0;',
            ENABLED => TRUE,
            COMMENTS => 'Oracle Job: Email - Make Tentative Job Offer within 2 Calendar Days');
END;
/
--------------------------------------------------------
--  DDL for Job EMAIL_RECRUIT_SLA_DECS_EX
--------------------------------------------------------
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            JOB_NAME => 'EMAIL_RECRUIT_SLA_DECS_EX',
            JOB_TYPE => 'STORED_PROCEDURE',
            JOB_ACTION => 'SP_JOB_RECRUITMENT_SLA_DECS_EX',
            START_DATE => SYSTIMESTAMP,
            REPEAT_INTERVAL => 'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI;BYHOUR=6;BYMINUTE=0;BYSECOND=0;',
            ENABLED => TRUE,
            COMMENTS => 'Oracle Job: Email - Cert Expires Without Hiring Decision');
END;
/
