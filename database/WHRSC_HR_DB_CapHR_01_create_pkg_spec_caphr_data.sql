CREATE OR REPLACE PACKAGE HHS_WHRSC_HR.CAPHR_DATA_PKS AS
--======================================================

--------------------------------------------------------
--PROCEDURE: INSERT_ADMIN_CODES
--DESCRIPTION: Insert new records into CHR_WGI and
--ORGS table
--------------------------------------------------------
PROCEDURE INSERT_ADMIN_CODES;

--------------------------------------------------------
--PROCEDURE: INSERT_CAPHR_EMP_DATA
--DESCRIPTION: Insert new records into CHR_EMPLOYEE table
--------------------------------------------------------
PROCEDURE INSERT_CAPHR_EMP_DATA;

--------------------------------------------------------
--PROCEDURE: INSERT_CAPHR_JOBID
--DESCRIPTION: Insert new records into CHR_PROCESSED_JOBS table
--------------------------------------------------------
PROCEDURE INSERT_CAPHR_JOBID;

--------------------------------------------------------
--PROCEDURE: INSERT_CAPHR_PCA_INFO
--DESCRIPTION: Insert new records into CHR_PCA_INFO table
--------------------------------------------------------
PROCEDURE INSERT_CAPHR_PCA_INFO;

--------------------------------------------------------
--PROCEDURE: INSERT_CHR_EMP_INFO
--DESCRIPTION: Insert new records into CHR_EMPLOYEE_INFO table
--------------------------------------------------------
PROCEDURE INSERT_CHR_EMP_INFO;

--------------------------------------------------------
--PROCEDURE: FN_IMPORT_CAPHR_DATA
--DESCRIPTION: FN_IMPORT_CAPHR_DATA will be called by spring batch, 
--which will call individual procedures in the package.
--------------------------------------------------------
FUNCTION FN_IMPORT_CAPHR_DATA 
RETURN VARCHAR2;

--------------------------------------------------------
--PROCEDURE: ERROR_LOG
--DESCRIPTION: Return SQLCODE and SQLERRM
--------------------------------------------------------
FUNCTION ERROR_LOG 
RETURN VARCHAR2;


END CAPHR_DATA_PKS;
/