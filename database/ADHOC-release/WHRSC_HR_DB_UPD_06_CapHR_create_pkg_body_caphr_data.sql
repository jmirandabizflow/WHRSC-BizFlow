create or replace PACKAGE BODY              CAPHR_DATA_PKS AS
---------------------------------------------------------------------------------------------------------------------------------------------------------
--THIS PACKAGE WILL HANDLE PULLING AND POPULATING CapHR TABLES in HHS_WHRSC_HR SCHEMA (CHR_ TABLES)
---------------------------------------------------------------------------------------------------------------------------------------------------------
 
--======================================================
--  - - -   - - - - - - - - - - - - - - - - - - - - - - 
 
--GLOBAL VARIABLES
 
--- -  -  -- - - - - - - - - - - - - - - - - - - - - - -
--======================================================
        GCV_LIMIT               CONSTANT    NUMBER(10)      := 1000;
 
--======================================================
-- - - -- - - - - - - - - - - - - - - - - - - - - - - -
 
--CURSORS and TYPES
 
-- - - - - - - - - - - - - - - - - - - - - - - - - - - -
--======================================================
--------------------------------------------------------
--CURSOR: CUR_ADMIN_CODE
--DESCRIPTION: Fetches records from the ADMINISTRATIVE_CODE table
--based on the Admin Codes for WHRSC in 2018
--------------------------------------------------------
CURSOR CUR_ADMIN_CODE 
    IS
    SELECT ADMIN_CODE,
    ADMIN_CODE_DESC,
    OPDIV,
    OPDIV_NAME,
    STAFFDIV,
    STAFFDIV_NAME
    FROM HHS_HR.ADMINISTRATIVE_CODE
    WHERE OPDIV IN ('ACF','ACL','AHRQ','ASA','ASFR','ASL','ASPA','ASPE','ASPR','DAB','IEA','IOS','OASH','OCIO','OCR','OGA','OGC','ONC','OSSI','PSC','SAMHSA')
    AND ADMIN_CODE LIKE 'AX%' OR ADMIN_CODE LIKE 'AB' OR ADMIN_CODE LIKE 'AA%' OR ADMIN_CODE LIKE 'ABC%' OR ADMIN_CODE LIKE 'ABE%' OR ADMIN_CODE LIKE 'AC%' OR ADMIN_CODE LIKE 'AE%' OR ADMIN_CODE LIKE 'AG%' OR ADMIN_CODE LIKE 'AH%' OR ADMIN_CODE LIKE 'AJ%' OR ADMIN_CODE LIKE 'AJG%' OR ADMIN_CODE LIKE 'AL%' OR ADMIN_CODE LIKE 'AM%' OR ADMIN_CODE LIKE 'AN%' OR ADMIN_CODE LIKE 'AP%' OR ADMIN_CODE LIKE 'AQ%' OR ADMIN_CODE LIKE 'AR%' OR ADMIN_CODE LIKE 'AT%' OR ADMIN_CODE LIKE 'B%' OR ADMIN_CODE LIKE 'E%' OR ADMIN_CODE LIKE 'K%' OR ADMIN_CODE LIKE 'M%' OR ADMIN_CODE LIKE 'P%' OR ADMIN_CODE LIKE 'AD%'; 
 
    TYPE TYP_ADMIN_CODE IS TABLE OF CUR_ADMIN_CODE%ROWTYPE
    INDEX BY PLS_INTEGER;
 
    ADMINCODES TYP_ADMIN_CODE;
 
--------------------------------------------------------
--CURSOR: CUR_CAPHR_EMP
--DESCRIPTION: Fetches records from the PS_PERSONAL_DATA_VW table 
--------------------------------------------------------
CURSOR CUR_CAPHR_EMP 
          IS
          SELECT  EMPLID,
                  FIRST_NAME,
                  LAST_NAME   
 
          FROM    HHS_HR.PS_PERSONAL_DATA_VW;
 
          TYPE TYP_CAPHR_EMP IS TABLE OF CUR_CAPHR_EMP%ROWTYPE
          INDEX BY PLS_INTEGER;
 
          CAPHR_EMPLOYEES TYP_CAPHR_EMP;
 
--------------------------------------------------------
--CURSOR: CUR_CAPHR_PROCESSED_JOBS
--DESCRIPTION: Fetches records from the PS_HRS_JOB_OPENING table 
--------------------------------------------------------
CURSOR CUR_CAPHR_PROCESSED_JOBS 
          IS
          SELECT  HRS_JOB_OPENING_ID,
                  DESIRED_START_DT,
                  STATUS_DT,
                  GVT_RECR_OFFICE
 
          FROM    HHS_HR.PS_HRS_JOB_OPENING
 
          WHERE   STATUS_CODE = '110'
                  AND BUSINESS_UNIT IN ('OS000','ACF00','ACL00','AHRQ0','PSC00','SAMHS', 'AOA00');
                  --AND AUTHORIZATION_DT > '01-JAN-2018';
 
          TYPE TYP_CAPHR_PROCESSED_JOBS IS TABLE OF CUR_CAPHR_PROCESSED_JOBS%ROWTYPE
          INDEX BY PLS_INTEGER;
 
          JOBS_PROCESSED_IN_CAPHR TYP_CAPHR_PROCESSED_JOBS;
 
--------------------------------------------------------
--CURSOR: CUR_CAPHR_JOB_OPENINGS
--DESCRIPTION: Fetches records from the PS_HRS_JOB_OPENING, 
--PS_HRS_JO_POSN and PS_POSITION_DATA tables 
--------------------------------------------------------        
 
CURSOR CUR_CAPHR_JOB_OPENINGS
IS
SELECT  JO.HRS_JOB_OPENING_ID,
            JO.GVT_RECR_OFFICE,
            POS.GVT_ORG_TTL_DESCR,
            POS.GVT_PAY_PLAN,
            POS.GVT_OCC_SERIES,
            POS.GRADE,
            JO.AUTHORIZATION_DT,
            JO.HE_COMMENTS,
            RE.ACCT_CD
    FROM    HHS_HR.PS_HRS_JOB_OPENING JO
                 LEFT JOIN HHS_HR.PS_HRS_JO_POSN JOP
                         ON JO.HRS_JOB_OPENING_ID = JOP.HRS_JOB_OPENING_ID
                 LEFT JOIN HHS_HR.PS_POSITION_DATA POS
        ON POS.POSITION_NBR = JOP.POSITION_NBR
              AND POS.EFFDT = (
                                SELECT MAX(EFFDT)
                                FROM HHS_HR.PS_POSITION_DATA
                                WHERE POSITION_NBR = POS.POSITION_NBR
                                  AND EFFDT <= JO.OPEN_DT
                              )
      LEFT JOIN HHS_HR.PS_HE_RECRUIT_EWIT RE
        ON JO.HRS_JOB_OPENING_ID = RE.HRS_JOB_OPENING_ID
    WHERE TO_CHAR(JO.HRS_JOB_OPENING_ID) NOT IN (SELECT ID FROM HHS_WHRSC_HR.CHR_EMPLOYEE_INFO)
                AND JO.BUSINESS_UNIT IN ('OS000','ACF00','ACL00','AHRQ0','PSC00','SAMHS','AOA00')
        AND JO.AUTHORIZATION_DT > '01-JAN-2018'
        AND JO.DEPTID NOT LIKE 'AK%'
        AND JO.DEPTID NOT LIKE 'M%'
    ORDER BY JO.HRS_JOB_OPENING_ID ASC;
 
    TYPE TYP_JOB_OPENINGS IS TABLE OF CUR_CAPHR_JOB_OPENINGS%ROWTYPE
        INDEX BY PLS_INTEGER;
 
    TYPE TYP_CAPHR_JOBS_CACHE IS TABLE OF HHS_WHRSC_HR.CHR_EMPLOYEE_INFO%ROWTYPE
        INDEX BY PLS_INTEGER;
 
  V_TBL_JOBS_CACHE      TYP_CAPHR_JOBS_CACHE;
  V_TBL_JOB_OPENINGS    TYP_JOB_OPENINGS;
 
  TYPE TYP_CHR_EMP_INFO IS TABLE OF HHS_WHRSC_HR.CHR_EMPLOYEE_INFO%ROWTYPE INDEX BY PLS_INTEGER;
      V_TBL_INS_EMP_INFO TYP_CHR_EMP_INFO;
 
--======================================================
-- - - -- - - - - - - - - - - - - - - - - - - - - - - -
 
--PROCEDURES
 
-- - - - - - - - - - - - - - - - - - - - - - - - - - - -
--======================================================
 
---------------------------------------------------------
--PROCEDURE: INSERT_ADMIN_CODES
--DESCRIPTION : 
---------------------------------------------------------
PROCEDURE INSERT_ADMIN_CODES
AS    
BEGIN
 
    OPEN CUR_ADMIN_CODE;
    FETCH CUR_ADMIN_CODE BULK COLLECT INTO ADMINCODES;
    CLOSE CUR_ADMIN_CODE;
 
    IF ADMINCODES.COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('COUNT: ' || ADMINCODES.COUNT);
    --Truncate ORGS and CHR_WGI tables
        EXECUTE IMMEDIATE 'TRUNCATE TABLE HHS_WHRSC_HR.ORGS';
        EXECUTE IMMEDIATE 'TRUNCATE TABLE HHS_WHRSC_HR.CHR_WGI';
 
        --FORALL i IN ADMINCODES.FIRST..ADMINCODES.LAST SAVE EXCEPTIONS
         FOR i IN ADMINCODES.FIRST.. ADMINCODES.LAST LOOP
         --Insert record into ORGS table
            BEGIN
          INSERT INTO HHS_WHRSC_HR.ORGS
          ( ADMIN_CODE,
            ADMIN_TITLE,
            ORG_INITS)
          VALUES
          ( ADMINCODES(i).ADMIN_CODE,
            ADMINCODES(i).ADMIN_CODE_DESC,
            ADMINCODES(i).OPDIV_NAME );
 
            --Insert record into CHR_WGI table
            INSERT INTO HHS_WHRSC_HR.CHR_WGI
          ( DEPT_ID,
            NAME )
          VALUES
          ( ADMINCODES(i).ADMIN_CODE,
            ADMINCODES(i).STAFFDIV_NAME );    
 
          EXCEPTION
                WHEN OTHERS THEN
                        SP_ERROR_LOG();
            END;
        END LOOP;
 
        --Update ORGS table with IC for ADMIN_CODE
        UPDATE ORGS SET IC = CASE
        WHEN ADMIN_CODE LIKE 'AA%' OR ADMIN_CODE LIKE 'AB' OR ADMIN_CODE LIKE 'AX%' THEN 'IOS'
        WHEN ADMIN_CODE LIKE 'ABC%' OR ADMIN_CODE LIKE 'AD%'THEN 'IEA'
        WHEN ADMIN_CODE LIKE 'ABE%' THEN 'OSSI'
        WHEN ADMIN_CODE LIKE 'AC%' THEN 'OASH'
        WHEN ADMIN_CODE LIKE 'AE%' THEN 'ASPE'
        WHEN ADMIN_CODE LIKE 'AG%' THEN 'OGC'
        WHEN ADMIN_CODE LIKE 'AH%' THEN 'DAB'
        WHEN ADMIN_CODE LIKE 'AJ%' AND ADMIN_CODE NOT LIKE 'AJG%' THEN 'ASA'
        WHEN ADMIN_CODE LIKE 'AJG%' THEN 'OCIO'
        WHEN ADMIN_CODE LIKE 'AL%' THEN 'ASL'
        WHEN ADMIN_CODE LIKE 'AM%' THEN 'ASFR'
        WHEN ADMIN_CODE LIKE 'AN%' THEN 'ASPR'
        WHEN ADMIN_CODE LIKE 'AP%' THEN 'ASPA'
        WHEN ADMIN_CODE LIKE 'AQ%' THEN 'OGA'
        WHEN ADMIN_CODE LIKE 'AR%' THEN 'ONC'
        WHEN ADMIN_CODE LIKE 'AT%' THEN 'OCR'
        WHEN ADMIN_CODE LIKE 'B%' THEN 'ACL'
        WHEN ADMIN_CODE LIKE 'E%' THEN 'AHRQ'
        WHEN ADMIN_CODE LIKE 'K%' THEN 'ACF'
        WHEN ADMIN_CODE LIKE 'M%' THEN 'SAMHSA'
        WHEN ADMIN_CODE LIKE 'P%' THEN 'PSC'
        ELSE ' ' END;
        COMMIT;
      END IF;
 
END INSERT_ADMIN_CODES;
 
---------------------------------------------------------
--PROCEDURE: INSERT_CAPHR_EMP_DATA
--DESCRIPTION : 
---------------------------------------------------------
PROCEDURE INSERT_CAPHR_EMP_DATA
AS   
BEGIN
 
    OPEN CUR_CAPHR_EMP;
    FETCH CUR_CAPHR_EMP BULK COLLECT INTO CAPHR_EMPLOYEES;
    CLOSE CUR_CAPHR_EMP;
 
    IF CAPHR_EMPLOYEES.COUNT > 0 THEN
      DBMS_OUTPUT.PUT_LINE('COUNT: ' || CAPHR_EMPLOYEES.COUNT);
          --Truncate CHR_EMPLOYEE table
          EXECUTE IMMEDIATE 'TRUNCATE TABLE HHS_WHRSC_HR.CHR_EMPLOYEE';
 
           FOR i IN CAPHR_EMPLOYEES.FIRST.. CAPHR_EMPLOYEES.LAST LOOP
           --Insert record into CHR_EMPLOYEE table
              BEGIN
            INSERT INTO HHS_WHRSC_HR.CHR_EMPLOYEE
            ( EMPID,
              FIRST_NAME,
              LAST_NAME)
            VALUES
            ( CAPHR_EMPLOYEES(i).EMPLID,
              CAPHR_EMPLOYEES(i).FIRST_NAME,
              CAPHR_EMPLOYEES(i).LAST_NAME );           
 
            EXCEPTION
                  WHEN OTHERS THEN
                          SP_ERROR_LOG();
              END;
          END LOOP;
          COMMIT;
    END IF;
 
END INSERT_CAPHR_EMP_DATA;
 
---------------------------------------------------------
--PROCEDURE: INSERT_CAPHR_JOBID
--DESCRIPTION : 
---------------------------------------------------------
PROCEDURE INSERT_CAPHR_JOBID
AS
BEGIN
 
    OPEN CUR_CAPHR_PROCESSED_JOBS;
    FETCH CUR_CAPHR_PROCESSED_JOBS BULK COLLECT INTO JOBS_PROCESSED_IN_CAPHR;
    CLOSE CUR_CAPHR_PROCESSED_JOBS;
 
    IF JOBS_PROCESSED_IN_CAPHR.COUNT > 0 THEN
      DBMS_OUTPUT.PUT_LINE('COUNT: ' || JOBS_PROCESSED_IN_CAPHR.COUNT);
          --Truncate CHR_PROCESSED_JOBS table
          EXECUTE IMMEDIATE 'TRUNCATE TABLE HHS_WHRSC_HR.CHR_PROCESSED_JOBS';
 
           FOR i IN JOBS_PROCESSED_IN_CAPHR.FIRST.. JOBS_PROCESSED_IN_CAPHR.LAST LOOP
           --Insert record into CHR_PROCESSED_JOBS table
              BEGIN
            INSERT INTO HHS_WHRSC_HR.CHR_PROCESSED_JOBS
            ( JOB_ID,
              EFFDT,
              DATE_PROCESSED_IN_CAPHR)
            VALUES
            ( JOBS_PROCESSED_IN_CAPHR(i).HRS_JOB_OPENING_ID,
              JOBS_PROCESSED_IN_CAPHR(i).DESIRED_START_DT,
              JOBS_PROCESSED_IN_CAPHR(i).STATUS_DT );           
 
            EXCEPTION
                  WHEN OTHERS THEN
                          SP_ERROR_LOG();
              END;
          END LOOP;
          COMMIT;
    END IF;
 
END INSERT_CAPHR_JOBID;
 
---------------------------------------------------------
--PROCEDURE: INSERT_CAPHR_PCA_INFO
--DESCRIPTION : 
---------------------------------------------------------
PROCEDURE INSERT_CAPHR_PCA_INFO
AS
BEGIN
 
    OPEN CUR_CAPHR_PROCESSED_JOBS;
    FETCH CUR_CAPHR_PROCESSED_JOBS BULK COLLECT INTO JOBS_PROCESSED_IN_CAPHR;
    CLOSE CUR_CAPHR_PROCESSED_JOBS;
 
    IF JOBS_PROCESSED_IN_CAPHR.COUNT > 0 THEN
      DBMS_OUTPUT.PUT_LINE('COUNT: ' || JOBS_PROCESSED_IN_CAPHR.COUNT);
          --Truncate CHR_PROCESSED_JOBS table
          EXECUTE IMMEDIATE 'TRUNCATE TABLE HHS_WHRSC_HR.CHR_PCA_INFO';
 
           FOR i IN JOBS_PROCESSED_IN_CAPHR.FIRST.. JOBS_PROCESSED_IN_CAPHR.LAST LOOP
           --Insert record into CHR_PCA_INFO table
              BEGIN
            INSERT INTO HHS_WHRSC_HR.CHR_PCA_INFO
            ( ID,
              DEPT_ID,
              EFF_DATE)
            VALUES
            ( JOBS_PROCESSED_IN_CAPHR(i).HRS_JOB_OPENING_ID,
              JOBS_PROCESSED_IN_CAPHR(i).GVT_RECR_OFFICE,
              JOBS_PROCESSED_IN_CAPHR(i).DESIRED_START_DT);           
 
            EXCEPTION
                  WHEN OTHERS THEN
                          SP_ERROR_LOG();
              END;
          END LOOP;
          COMMIT;
    END IF;
 
END INSERT_CAPHR_PCA_INFO;
 
---------------------------------------------------------
--PROCEDURE: INSERT_CHR_EMP_INFO
--DESCRIPTION : 
---------------------------------------------------------
PROCEDURE INSERT_CHR_EMP_INFO
AS
V_JOB_IDX NUMBER;
V_MAX_GRADE VARCHAR2(30);
BEGIN
 
    OPEN CUR_CAPHR_JOB_OPENINGS;
    FETCH CUR_CAPHR_JOB_OPENINGS
    BULK COLLECT INTO V_TBL_JOB_OPENINGS;
    CLOSE CUR_CAPHR_JOB_OPENINGS;
        
        IF V_TBL_JOB_OPENINGS.COUNT > 0 THEN
  DBMS_OUTPUT.PUT_LINE('COUNT: ' || V_TBL_JOB_OPENINGS.COUNT);
                FOR i IN V_TBL_JOB_OPENINGS.FIRST .. V_TBL_JOB_OPENINGS.LAST LOOP
                
                SELECT  MAX(POS.GRADE) INTO V_MAX_GRADE FROM HHS_HR.PS_HRS_JO_POSN JOP,HHS_HR.PS_HRS_JOB_OPENING JO,HHS_HR.PS_POSITION_DATA POS                                  
                                  WHERE   JO.HRS_JOB_OPENING_ID = JOP.HRS_JOB_OPENING_ID
                                          AND POS.POSITION_NBR = JOP.POSITION_NBR
                                          AND JO.HRS_JOB_OPENING_ID = V_TBL_JOB_OPENINGS(i).HRS_JOB_OPENING_ID ;
 
                
                        IF NOT V_TBL_JOBS_CACHE.EXISTS(V_TBL_JOB_OPENINGS(i).HRS_JOB_OPENING_ID) THEN  --If job opening id does not exist
                                --Create a cache to store job opening id and grade, index on job opening id
                                V_TBL_JOBS_CACHE(V_TBL_JOB_OPENINGS(i).HRS_JOB_OPENING_ID).ID            := V_TBL_JOB_OPENINGS(i).HRS_JOB_OPENING_ID;
                                
                                V_JOB_IDX := V_TBL_INS_EMP_INFO.COUNT;
                                
                                --Add to collection for insert
                                V_TBL_INS_EMP_INFO(V_JOB_IDX).ID                                                 := V_TBL_JOB_OPENINGS(i).HRS_JOB_OPENING_ID;
                                V_TBL_INS_EMP_INFO(V_JOB_IDX).DEPT_ID                                    := V_TBL_JOB_OPENINGS(i).GVT_RECR_OFFICE;
                                V_TBL_INS_EMP_INFO(V_JOB_IDX).JOB_TITLE                          := V_TBL_JOB_OPENINGS(i).GVT_ORG_TTL_DESCR;
                                V_TBL_INS_EMP_INFO(V_JOB_IDX).PAY_PLAN                                   := V_TBL_JOB_OPENINGS(i).GVT_PAY_PLAN;
                                V_TBL_INS_EMP_INFO(V_JOB_IDX).OCC_SERIES                                 := V_TBL_JOB_OPENINGS(i).GVT_OCC_SERIES;
                                V_TBL_INS_EMP_INFO(V_JOB_IDX).GRADE                                      := V_MAX_GRADE;
                                V_TBL_INS_EMP_INFO(V_JOB_IDX).DATE_ADDED                                 := SYSDATE;
                                V_TBL_INS_EMP_INFO(V_JOB_IDX).DATE_JOB_REQ_APPROVED      := V_TBL_JOB_OPENINGS(i).AUTHORIZATION_DT;
                                V_TBL_INS_EMP_INFO(V_JOB_IDX).CAPHR_COMMENTS                     := V_TBL_JOB_OPENINGS(i).HE_COMMENTS;
        V_TBL_INS_EMP_INFO(V_JOB_IDX).CAN_NUMBER                         := V_TBL_JOB_OPENINGS(i).ACCT_CD;
                        END IF;
                END LOOP;
        END IF;
 
 
     IF V_TBL_INS_EMP_INFO.COUNT > 0 THEN
         --SP_INSERT_CHR_EMP_INFO(V_TBL_INS_EMP_INFO);
         FOR i IN V_TBL_INS_EMP_INFO.FIRST.. V_TBL_INS_EMP_INFO.LAST LOOP
           BEGIN
               INSERT INTO HHS_WHRSC_HR.CHR_EMPLOYEE_INFO
                       (ID,
                       DEPT_ID,
                       JOB_TITLE,
                       PAY_PLAN,
                       OCC_SERIES,
                       GRADE,
                       DATE_ADDED,
                       DATE_JOB_REQ_APPROVED,
                       CAPHR_COMMENTS,
                       CAN_NUMBER)
               VALUES
                       (V_TBL_INS_EMP_INFO(i).ID,
                       V_TBL_INS_EMP_INFO(i).DEPT_ID,
                       V_TBL_INS_EMP_INFO(i).JOB_TITLE,
                       V_TBL_INS_EMP_INFO(i).PAY_PLAN,
                       V_TBL_INS_EMP_INFO(i).OCC_SERIES,
                       V_TBL_INS_EMP_INFO(i).GRADE,
                       V_TBL_INS_EMP_INFO(i).DATE_ADDED,
                       V_TBL_INS_EMP_INFO(i).DATE_JOB_REQ_APPROVED,
                       V_TBL_INS_EMP_INFO(i).CAPHR_COMMENTS,
                       V_TBL_INS_EMP_INFO(i).CAN_NUMBER);
               EXCEPTION
                   WHEN OTHERS THEN
                       SP_ERROR_LOG();
               END;
       END LOOP;
--       UPDATE HHS_WHRSC_HR.CHR_EMPLOYEE_INFO
--       SET IC = (SELECT O.IC FROM HHS_WHRSC_HR.ORGS O WHERE O.ADMIN_CODE = DEPT_ID);
UPDATE CHR_EMPLOYEE_INFO SET IC = CASE
        WHEN DEPT_ID LIKE 'AA%' OR DEPT_ID LIKE 'AB' OR DEPT_ID LIKE 'AX%' THEN 'IOS'
        WHEN DEPT_ID LIKE 'ABC%' OR DEPT_ID LIKE 'AD%'THEN 'IEA'
        WHEN DEPT_ID LIKE 'ABE%' THEN 'OSSI'
        WHEN DEPT_ID LIKE 'AC%' THEN 'OASH'
        WHEN DEPT_ID LIKE 'AE%' THEN 'ASPE'
        WHEN DEPT_ID LIKE 'AG%' THEN 'OGC'
        WHEN DEPT_ID LIKE 'AH%' THEN 'DAB'
        WHEN DEPT_ID LIKE 'AJ%' AND DEPT_ID NOT LIKE 'AJG%' THEN 'ASA'
        WHEN DEPT_ID LIKE 'AJG%' THEN 'OCIO'
        WHEN DEPT_ID LIKE 'AL%' THEN 'ASL'
        WHEN DEPT_ID LIKE 'AM%' THEN 'ASFR'
        WHEN DEPT_ID LIKE 'AN%' THEN 'ASPR'
        WHEN DEPT_ID LIKE 'AP%' THEN 'ASPA'
        WHEN DEPT_ID LIKE 'AQ%' THEN 'OGA'
        WHEN DEPT_ID LIKE 'AR%' THEN 'ONC'
        WHEN DEPT_ID LIKE 'AT%' THEN 'OCR'
        WHEN DEPT_ID LIKE 'B%' THEN 'ACL'
        WHEN DEPT_ID LIKE 'E%' THEN 'AHRQ'
        WHEN DEPT_ID LIKE 'K%' THEN 'ACF'
        WHEN DEPT_ID LIKE 'M%' THEN 'SAMHSA'
        WHEN DEPT_ID LIKE 'P%' THEN 'PSC'
        ELSE ' ' END;
           COMMIT;
     END IF; 
END INSERT_CHR_EMP_INFO;
 
--------------------------------------------------------
--FUNCTION: FN_IMPORT_CAPHR_DATA
--DESCRIPTION: Entry point for this package,calls individual 
--procedure run INSERT scrip inside the procedure. It will
-- return and error code and message if any. This function
--will be called by spring batch.
--------------------------------------------------------
FUNCTION FN_IMPORT_CAPHR_DATA
RETURN VARCHAR2
AS
BEGIN
        INSERT_ADMIN_CODES();
        INSERT_CAPHR_EMP_DATA();
        INSERT_CAPHR_JOBID();
        INSERT_CAPHR_PCA_INFO();
        INSERT_CHR_EMP_INFO();
RETURN ERROR_LOG();
END FN_IMPORT_CAPHR_DATA;
 
--------------------------------------------------------
--PROCEDURE: ERROR_LOG
--DESCRIPTION: Return SQLCODE and SQLERRM
--------------------------------------------------------
FUNCTION ERROR_LOG
RETURN VARCHAR2
IS
        ERR_CODE   PLS_INTEGER        :=SQLCODE;
        ERR_MSG    VARCHAR2(32767)    := SQLERRM;
BEGIN
        RETURN ERR_CODE ||' : ' ||ERR_MSG;
END ERROR_LOG;
 
END CAPHR_DATA_PKS;
 
