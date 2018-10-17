--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_VACANCY
--------------------------------------------------------
/**
 * Parses WHRSC Vacancy XML data and 
 * stores it into DSS_VACANCY table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_VACANCY							
(							
	I_ID                IN      NUMBER						
)							
IS							
	V_REC_CNT                   NUMBER(10);						
	V_XMLDOC                    XMLTYPE;						
	V_XMLVALUE                  XMLTYPE;						
	V_ERRCODE                   NUMBER(10);						
	V_ERRMSG                    VARCHAR2(512);						
	E_INVALID_REC_ID            EXCEPTION;						
	PRAGMA EXCEPTION_INIT(E_INVALID_REC_ID, -20920);						
	E_INVALID_DATA     EXCEPTION;						
	PRAGMA EXCEPTION_INIT(E_INVALID_DATA, -20921);						
BEGIN							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_VACANCY - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_VACANCY: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_VACANCY table');					
		INSERT INTO DSS_VACANCY					
			(		POSITION_TITLE		
					, VACANCY_IDENTIFICATION_NUMBER						
					, VACANCY_ANNOUNCEMENT_NUMBER						
					, VACANCY_STATUS						
					, ANNOUNCEMENT_TYPE						
					, LAST_UPDATE_DATE						
					, FULL_PERFORMANCE_LEVEL						
					, DATE_ANNOUNCEMENT_POSTED						
					, DATE_ANNOUNCEMENT_OPENED						
					, DATE_ANNOUNCEMENT_CLOSED						
					, NUMBER_OF_POSITIONS_ADVERTISED						
					, TOTAL_APPLICANTS						
					, TOTAL_ELIGIBLE_APPLICANTS						
					, TOTAL_REFERRED_APPLICANTS						
					, TOTAL_SELECTED_APPLICANTS
					, ANNOUNCEMENT_CONTROL_NUMBER)						
		SELECT					
				X.POSITION_TITLE			
				, X.VACANCY_IDENTIFICATION_NUMBER							
				, X.VACANCY_ANNOUNCEMENT_NUMBER							
				, X.VACANCY_STATUS							
				, X.ANNOUNCEMENT_TYPE							
				, TO_DATE(SUBSTR(X.LAST_UPDATE_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS LAST_UPDATE_DATE							
				, X.FULL_PERFORMANCE_LEVEL							
				, TO_DATE(SUBSTR(X.DATE_ANNOUNCEMENT_POSTED, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS DATE_ANNOUNCEMENT_POSTED							
				, TO_DATE(SUBSTR(X.DATE_ANNOUNCEMENT_OPENED, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS DATE_ANNOUNCEMENT_OPENED							
				, TO_DATE(SUBSTR(X.DATE_ANNOUNCEMENT_CLOSED, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS DATE_ANNOUNCEMENT_CLOSED							
				, X.NUMBER_OF_POSITIONS_ADVERTISED							
				, X.TOTAL_APPLICANTS							
				, X.TOTAL_ELIGIBLE_APPLICANTS							
				, X.TOTAL_REFERRED_APPLICANTS							
				, X.TOTAL_SELECTED_APPLICANTS
				, X.ANNOUNCEMENT_CONTROL_NUMBER				
							
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					POSITION_TITLE					VARCHAR2(202)	Path 'Position__Title'
					,VACANCY_IDENTIFICATION_NUMBER	NUMBER(10)		Path 'Vacancy__Identification__Number'					
					,VACANCY_ANNOUNCEMENT_NUMBER	VARCHAR2(56)	Path 'Vacancy__Announcement__Number'					
					,VACANCY_STATUS					VARCHAR2(1002)	Path 'Vacancy__Status'					
					,ANNOUNCEMENT_TYPE				VARCHAR2(24)	Path 'Announcement__Type'					
					,LAST_UPDATE_DATE				VARCHAR2(50)	Path 'Vacancy__Last__Update__Date_x002fTime'					
					,FULL_PERFORMANCE_LEVEL			VARCHAR2(6)		Path 'Full__Performance__Level'					
					,DATE_ANNOUNCEMENT_POSTED		VARCHAR2(50)	Path 'Date__Announcement__Posted'					
					,DATE_ANNOUNCEMENT_OPENED		VARCHAR2(50)	Path 'Date__Announcement__Opened'					
					,DATE_ANNOUNCEMENT_CLOSED		VARCHAR2(50)	Path 'Date__Announcement__Closed'					
					,NUMBER_OF_POSITIONS_ADVERTISED	VARCHAR2(12)	Path 'Number__of__Positions__Advertised'					
					,TOTAL_APPLICANTS				NUMBER(10)		Path 'Vacancy__Total__Applicants'					
					,TOTAL_ELIGIBLE_APPLICANTS		NUMBER(10)		Path 'Vacancy__Total__Eligible__Applicants'					
					,TOTAL_REFERRED_APPLICANTS		NUMBER(10)		Path 'Vacancy__Total__Referred__Applicants'					
					,TOTAL_SELECTED_APPLICANTS		NUMBER(10)		Path 'Vacancy__Total__Selected__Applicants'					
					,ANNOUNCEMENT_CONTROL_NUMBER	NUMBER(10)		Path 'Announcement__Control__Number'
					) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_VACANCY: Invalid VACANCY data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_VACANCY - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VACANCY -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VACANCY -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VACANCY -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/