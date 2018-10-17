--------------------------------------------------------
--  DDL for Procedure SP_ERROR_LOG
--------------------------------------------------------
/**
 * Stores database errors to ERROR_LOG table to help troubleshooting.
 *
 */
CREATE OR REPLACE PROCEDURE SP_ERROR_LOG
IS
	PRAGMA AUTONOMOUS_TRANSACTION;
	V_CODE      PLS_INTEGER := SQLCODE;
	V_MSG       VARCHAR2(32767) := SQLERRM;
BEGIN
	INSERT INTO ERROR_LOG
	(
		ERROR_CD
		, ERROR_MSG
		, BACKTRACE
		, CALLSTACK
		, CRT_DT
		, CRT_USR
	)
	VALUES (
		V_CODE
		, V_MSG
		, SYS.DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
		, SYS.DBMS_UTILITY.FORMAT_CALL_STACK
		, SYSDATE
		, USER
	);

	COMMIT;
END;
/


--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_APPLICANT_NOTIFICTNS
--------------------------------------------------------
/**
 * Parses WHRSC Applicant Notifications XML data and 
 * stores it into DSS_APPLICANT_NOTIFICATIONS table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_APPLICANT_NOTIFICTNS
(
	I_ID		IN     	NUMBER
)
IS
	V_REC_CNT			NUMBER(10);
	V_XMLDOC	 		XMLTYPE;
	V_XMLVALUE	  		XMLTYPE;
	V_ERRCODE			NUMBER(10);
	V_ERRMSG	 		VARCHAR2(512);
	E_INVALID_REC_ID	EXCEPTION;
	PRAGMA EXCEPTION_INIT(E_INVALID_REC_ID, -20920);
	E_INVALID_DATA     	EXCEPTION;
	PRAGMA EXCEPTION_INIT(E_INVALID_DATA, -20921);
BEGIN
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_APPLICANT_NOTIFICTNS - BEGIN ============================');
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));
	--DBMS_OUTPUT.PUT_LINE(' ----------------');

	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');

	IF I_ID IS NULL THEN
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_APPLICANT_NOTIFICTNS: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );
	END IF;

	BEGIN
		
		--DBMS_OUTPUT.PUT_LINE('    DSS_APPLICANT_NOTIFICATIONS table');
		INSERT INTO DSS_APPLICANT_NOTIFICATIONS
			(VACANCY_NUMBER
			,APPLICATN_NOTIFICATN_TEMPLATE
			,NOTIFICATIONS_SENT
			,INITIAL_NOTIFICATION_SEND_DATE)
		SELECT
			X.VACANCY_NUMBER
			, X.APPLICATN_NOTIFICATN_TEMPLATE
			, X.NOTIFICATIONS_SENT
			, TO_DATE(SUBSTR(X.INITIAL_NOTIFICATION_SEND_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS INITIAL_NOTIFICATION_SEND_DATE
		FROM INTG_DATA_DTL IDX
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'
				PASSING IDX.FIELD_DATA
				COLUMNS
					VACANCY_NUMBER	 						NUMBER(10)			PATH 'Vacancy__Number'
					, APPLICATN_NOTIFICATN_TEMPLATE	 		VARCHAR2(102)	  	PATH 'Application__Notification__Template__Type'
					, NOTIFICATIONS_SENT					NUMBER(10)	  		PATH 'Notifications__Sent'
					, INITIAL_NOTIFICATION_SEND_DATE		VARCHAR2(50)    	PATH 'Initial__Notification__Send__Date'
			) X
		WHERE IDX.ID = I_ID;
		
	EXCEPTION
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_APPLICANT_NOTIFICTNS: Invalid APPLICANT NOTIFICATIONS data.  I_ID = ' || TO_CHAR(I_ID) );
	END;

	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_APPLICANT_NOTIFICTNS - END ==========================');


EXCEPTION
	WHEN E_INVALID_REC_ID THEN
		SP_ERROR_LOG();
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_APPLICANT_NOTIFICTNS -------------------');
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');
	WHEN E_INVALID_DATA THEN
		SP_ERROR_LOG();
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_APPLICANT_NOTIFICTNS -------------------');
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');
	WHEN OTHERS THEN
		SP_ERROR_LOG();
		V_ERRCODE := SQLCODE;
		V_ERRMSG := SQLERRM;
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_APPLICANT_NOTIFICTNS -------------------');
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);
END;
/


--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_CERTIFICATE_LOCATION
--------------------------------------------------------
/**
 * Parses WHRSC Certificate Series Locations XML data and 
 * stores it into DSS_CERTIFICATE_LOCATIONS table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_CERTIFICATE_LOCATION
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_CERTIFICATE_LOCATION - BEGIN ============================');
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));
	--DBMS_OUTPUT.PUT_LINE(' ----------------');

	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');

	IF I_ID IS NULL THEN
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_CERTIFICATE_LOCATION: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );
	END IF;

	BEGIN
		
		--DBMS_OUTPUT.PUT_LINE('    DSS_CERTIFICATE_LOCATIONS table');
		INSERT INTO DSS_CERTIFICATE_LOCATIONS
			(CERTIFICATE_NUMBER
			,CERT_FILTER_SERIES
			,CERT_FILTER_LOCATION_CODE
			,CERT_FILTER_LOCATION_CITY
			,CERT_FILTER_LOCATION_STATE
			,CERT_FILTER_LOCATION_COUNTRY)
		SELECT
			X.CERTIFICATE_NUMBER
			, X.CERT_FILTER_SERIES
			, X.CERT_FILTER_LOCATION_CODE
			, X.CERT_FILTER_LOCATION_CITY
			, X.CERT_FILTER_LOCATION_STATE
			, X.CERT_FILTER_LOCATION_COUNTRY
		FROM INTG_DATA_DTL IDX
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'
				PASSING IDX.FIELD_DATA
				COLUMNS
					CERTIFICATE_NUMBER                 		VARCHAR2(102)      	PATH 'Certificate__Number'
					, CERT_FILTER_SERIES                    VARCHAR2(1028)     	PATH 'Certificate__Filter__Series'
					, CERT_FILTER_LOCATION_CODE             VARCHAR2(34)       	PATH 'Certificate__Filter__Location__Code'
					, CERT_FILTER_LOCATION_CITY             VARCHAR2(122)      	PATH 'Certificate__Filter__Location__City'
					, CERT_FILTER_LOCATION_STATE            VARCHAR2(8)    		PATH 'Certificate__Filter__Location__State'
					, CERT_FILTER_LOCATION_COUNTRY          VARCHAR2(202)    	PATH 'Certificate__Filter__Location__Country'
				) X
		WHERE IDX.ID = I_ID;
		
	EXCEPTION
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_CERTIFICATE_LOCATION: Invalid CERTIFICATE LOCATIONS data.  I_ID = ' || TO_CHAR(I_ID) );
	END;

	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_CERTIFICATE_LOCATION - END ==========================');


EXCEPTION
	WHEN E_INVALID_REC_ID THEN
		SP_ERROR_LOG();
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_CERTIFICATE_LOCATION -------------------');
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');
	WHEN E_INVALID_DATA THEN
		SP_ERROR_LOG();
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_CERTIFICATE_LOCATION -------------------');
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');
	WHEN OTHERS THEN
		SP_ERROR_LOG();
		V_ERRCODE := SQLCODE;
		V_ERRMSG := SQLERRM;
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_CERTIFICATE_LOCATION -------------------');
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);
END;
/

--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_CERTIFICATES
--------------------------------------------------------
/**
 * Parses WHRSC Certificates XML data and 
 * stores it into DSS_CERTIFICATES table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_CERTIFICATES
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_CERTIFICATES - BEGIN ============================');
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));
	--DBMS_OUTPUT.PUT_LINE(' ----------------');

	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');

	IF I_ID IS NULL THEN
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_CERTIFICATES: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );
	END IF;

	BEGIN
		
		--DBMS_OUTPUT.PUT_LINE('    DSS_CERTIFICATES table');
		INSERT INTO DSS_CERTIFICATES
			(CERTIFICATE_NUMBER
			,VACANCY_IDENTIFICATION_NUMBER
			,POSITION_TITLE
			,CERTIFICATE_TYPE
			,ANNOUNCEMENT_NUMBER
			,DATE_AUDIT_COMPLETED
			,DATE_CERTIFICATE_ISSUED
			,DATE_CERTIFICATE_SENT_TO_SO
			,DATE_HIRING_DECISN_RECD_IN_HR
			,TOTAL_REFERRED_APPLICANTS
			,SELECTIONS_MADE
			,TOTAL_VETERANS_REFERRED
			,TOTAL_VETERANS_SELECTED
			,CERT_FILTER_LOCATIONS
			,CERT_FILTER_GRADE)
		SELECT
			X.CERTIFICATE_NUMBER
			, X.VACANCY_IDENTIFICATION_NUMBER
			, X.POSITION_TITLE
			, X.CERTIFICATE_TYPE
			, X.ANNOUNCEMENT_NUMBER
			, TO_DATE(SUBSTR(X.DATE_AUDIT_COMPLETED, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS DATE_AUDIT_COMPLETED
			, TO_DATE(SUBSTR(X.DATE_CERTIFICATE_ISSUED, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS DATE_CERTIFICATE_ISSUED
			, TO_DATE(SUBSTR(X.DATE_CERTIFICATE_SENT_TO_SO, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS DATE_CERTIFICATE_SENT_TO_SO
			, TO_DATE(SUBSTR(X.DATE_HIRING_DECISN_RECD_IN_HR, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS DATE_HIRING_DECISN_RECD_IN_HR
			, X.TOTAL_REFERRED_APPLICANTS
			, X.SELECTIONS_MADE
			, X.TOTAL_VETERANS_REFERRED
			, X.TOTAL_VETERANS_SELECTED
			, X.CERT_FILTER_LOCATIONS
			, X.CERT_FILTER_GRADE
		FROM INTG_DATA_DTL IDX
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'
				PASSING IDX.FIELD_DATA
				COLUMNS
					CERTIFICATE_NUMBER                 				VARCHAR2(102)      	PATH 'Certificate__Number'
					, VACANCY_IDENTIFICATION_NUMBER                 NUMBER(10)      	PATH 'Vacancy__Identification__Number'
					, POSITION_TITLE                 				VARCHAR2(202)      	PATH 'Position__Title'
					, CERTIFICATE_TYPE                 				VARCHAR2(82)      	PATH 'Certificate__Type'
					, ANNOUNCEMENT_NUMBER                 			VARCHAR2(56)      	PATH 'Announcement__Number'
					, DATE_AUDIT_COMPLETED                 			VARCHAR2(50)      	PATH 'Date__Audit__Completed'
					, DATE_CERTIFICATE_ISSUED               		VARCHAR2(50)      	PATH 'Date__Certificate__Issued'
					, DATE_CERTIFICATE_SENT_TO_SO           		VARCHAR2(50)      	PATH 'Date__Certificate__Sent__to__SO'
					, DATE_HIRING_DECISN_RECD_IN_HR         		VARCHAR2(50)      	PATH 'Date__Hiring__Decision__Rec_x0027d__in__HR'
					, TOTAL_REFERRED_APPLICANTS             		NUMBER(10)      	PATH 'Certificate__Total__Referred__Applicants'
					, SELECTIONS_MADE                 				NUMBER(10)      	PATH 'Selections__Made'
					, TOTAL_VETERANS_REFERRED                 		NUMBER(10)      	PATH 'Certificate__Total__Veterans__Referred'
					, TOTAL_VETERANS_SELECTED                 		NUMBER(10)      	PATH 'Certificate__Total__Veterans__Selected'
					, CERT_FILTER_LOCATIONS                 		VARCHAR2(2050)      PATH 'Certificate__Filter__Locations'
					, CERT_FILTER_GRADE                 			VARCHAR2(502)      	PATH 'Certificate__Filter__Grade'
				) X
		WHERE IDX.ID = I_ID;
		
	EXCEPTION
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_CERTIFICATES: Invalid CERTIFICATE data.  I_ID = ' || TO_CHAR(I_ID) );
	END;

	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_CERTIFICATES - END ==========================');

EXCEPTION
	WHEN E_INVALID_REC_ID THEN
		SP_ERROR_LOG();
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_CERTIFICATES -------------------');
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');
	WHEN E_INVALID_DATA THEN
		SP_ERROR_LOG();
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_CERTIFICATES -------------------');
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');
	WHEN OTHERS THEN
		SP_ERROR_LOG();
		V_ERRCODE := SQLCODE;
		V_ERRMSG := SQLERRM;
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_CERTIFICATES -------------------');
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);
END;
/


--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_NEW_HIRE_FORMS
--------------------------------------------------------
/**
 * Parses WHRSC New Hire Forms XML data and 
 * stores it into DSS_NEW_HIRE_FORMS table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_NEW_HIRE_FORMS
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_NEW_HIRE_FORMS - BEGIN ============================');
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));
	--DBMS_OUTPUT.PUT_LINE(' ----------------');

	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');

	IF I_ID IS NULL THEN
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_NEW_HIRE_FORMS: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );
	END IF;

	BEGIN
		
		--DBMS_OUTPUT.PUT_LINE('    DSS_NEW_HIRE_FORMS table');
		INSERT INTO DSS_NEW_HIRE_FORMS
			(NEW_HIRE_NUMBER
			,NH_FORM_NAME
			,NH_FORM_NEXT_AGENCY_ACTION
			,NH_FORM_NEXT_NEW_HIRE_ACTION
			,NH_FORM_NUMBER
			,NH_FORM_STATUS)
		SELECT
			X.NEW_HIRE_NUMBER
			, X.NH_FORM_NAME
			, X.NH_FORM_NEXT_AGENCY_ACTION
			, X.NH_FORM_NEXT_NEW_HIRE_ACTION
			, X.NH_FORM_NUMBER
			, X.NH_FORM_STATUS
		FROM INTG_DATA_DTL IDX
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'
				PASSING IDX.FIELD_DATA
				COLUMNS
					NEW_HIRE_NUMBER                 				VARCHAR2(22)      	PATH 'New__Hire__Number'
					, NH_FORM_NAME                 					VARCHAR2(514)      	PATH 'New__Hire__Form__Name'
					, NH_FORM_NEXT_AGENCY_ACTION                 	VARCHAR2(1002)      PATH 'New__Hire__Form__Next__Agency__Action'
					, NH_FORM_NEXT_NEW_HIRE_ACTION                 	VARCHAR2(1002)      PATH 'New__Hire__Form__Next__New__Hire__Action'
					, NH_FORM_NUMBER                 				VARCHAR2(130)      	PATH 'New__Hire__Form__Number'
					, NH_FORM_STATUS                 				VARCHAR2(1002)      PATH 'New__Hire__Form__Status'
				) X
		WHERE IDX.ID = I_ID;
		
	EXCEPTION
		WHEN OTHERS THEN
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_NEW_HIRE_FORMS: Invalid NEW HIRE FORMS  data.  I_ID = ' || TO_CHAR(I_ID) );
	END;

	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_NEW_HIRE_FORMS - END ==========================');

EXCEPTION
	WHEN E_INVALID_REC_ID THEN
		SP_ERROR_LOG();
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRE_FORMS -------------------');
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');
	WHEN E_INVALID_DATA THEN
		SP_ERROR_LOG();
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRE_FORMS -------------------');
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');
	WHEN OTHERS THEN
		SP_ERROR_LOG();
		V_ERRCODE := SQLCODE;
		V_ERRMSG := SQLERRM;
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRE_FORMS -------------------');
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);
END;
/


--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_NEW_HIRE_ONBRDNG_DOC
--------------------------------------------------------
/**
 * Parses WHRSC New Hire Onboarding Documents XML data and 
 * stores it into DSS_NEW_HIRE_ONBOARDING_DOCS table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_NEW_HIRE_ONBRDNG_DOC							
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_NEW_HIRE_ONBRDNG_DOC - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_NEW_HIRE_ONBRDNG_DOC: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_NEW_HIRE_ONBOARDING_DOCS table');					
		INSERT INTO DSS_NEW_HIRE_ONBOARDING_DOCS					
			(NEW_HIRE_NUMBER				
			,NH_ONBOARDING_DOC_FILE_NAME				
			,NH_ONBOARDING_DOC_NAME				
			,NH_ONBOARDING_DOC_NUMBER				
			,NH_ONBOARDING_DOC_SOURCE				
			,NH_ONBOARDING_DOC_UPLOAD_DATE)				
		SELECT					
			X.NEW_HIRE_NUMBER				
			, X.NH_ONBOARDING_DOC_FILE_NAME				
			, X.NH_ONBOARDING_DOC_NAME				
			, X.NH_ONBOARDING_DOC_NUMBER				
			, X.NH_ONBOARDING_DOC_SOURCE				
			, TO_DATE(SUBSTR(X.NH_ONBOARDING_DOC_UPLOAD_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS NH_ONBOARDING_DOC_UPLOAD_DATE				
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					NEW_HIRE_NUMBER						VARCHAR2(22)	PATH 'New__Hire__Number'
					, NH_ONBOARDING_DOC_FILE_NAME		VARCHAR2(202)	PATH 'New__Hire__Onboarding__Document__File__Name'					
					, NH_ONBOARDING_DOC_NAME			VARCHAR2(514)	PATH 'New__Hire__Onboarding__Document__Name'					
					, NH_ONBOARDING_DOC_NUMBER			VARCHAR2(102)	PATH 'New__Hire__Onboarding__Document__Number'					
					, NH_ONBOARDING_DOC_SOURCE			VARCHAR2(1002)	PATH 'New__Hire__Onboarding__Document__Source'					
					, NH_ONBOARDING_DOC_UPLOAD_DATE		VARCHAR2(50)	PATH 'New__Hire__Onboarding__Document__Upload__Date'					
) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_NEW_HIRE_ONBRDNG_DOC: Invalid NEW HIRE ONBOARDNG DOCS  data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_NEW_HIRE_ONBRDNG_DOC - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRE_ONBRDNG_DOC -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRE_ONBRDNG_DOC -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRE_ONBRDNG_DOC -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/


--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_NEW_HIRE_TASKS
--------------------------------------------------------
/**
 * Parses WHRSC New Hire Tasks XML data and 
 * stores it into DSS_NEW_HIRE_TASKS table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_NEW_HIRE_TASKS							
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_NEW_HIRE_TASKS - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_NEW_HIRE_TASKS: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_NEW_HIRE_TASKS table');					
		INSERT INTO DSS_NEW_HIRE_TASKS					
			(NEW_HIRE_NUMBER				
			,BCKGRND_INVSTGTN_ACTIVE_DATE				
			,BCKGRND_INVSTGTN_COMPLT_DATE				
			,ARRIVAL_VERIFIED_COMPLT_DATE				
			,SEND_OFFICL_OFFER_ACTIVE_DATE				
			,SEND_OFFICL_OFFER_COMPLT_DATE				
			,SEND_TENTATV_OFFER_ACTIVE_DATE				
			,SEND_TENTATV_OFFER_COMPLT_DATE)				
		SELECT					
			X.NEW_HIRE_NUMBER				
			, TO_DATE(SUBSTR(X.BCKGRND_INVSTGTN_ACTIVE_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS BCKGRND_INVSTGTN_ACTIVE_DATE				
			, TO_DATE(SUBSTR(X.BCKGRND_INVSTGTN_COMPLT_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS BCKGRND_INVSTGTN_COMPLT_DATE				
			, TO_DATE(SUBSTR(X.ARRIVAL_VERIFIED_COMPLT_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS ARRIVAL_VERIFIED_COMPLT_DATE				
			, TO_DATE(SUBSTR(X.SEND_OFFICL_OFFER_ACTIVE_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS SEND_OFFICL_OFFER_ACTIVE_DATE				
			, TO_DATE(SUBSTR(X.SEND_OFFICL_OFFER_COMPLT_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS SEND_OFFICL_OFFER_COMPLT_DATE				
			, TO_DATE(SUBSTR(X.SEND_TENTATV_OFFER_ACTIVE_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS SEND_TENTATV_OFFER_ACTIVE_DATE				
			, TO_DATE(SUBSTR(X.SEND_TENTATV_OFFER_COMPLT_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS SEND_TENTATV_OFFER_COMPLT_DATE				
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					NEW_HIRE_NUMBER	VARCHAR2(22)	Path 'New__Hire__Number'
					,BCKGRND_INVSTGTN_ACTIVE_DATE	VARCHAR2(50)	Path 'Initiate__Background__Investigation__Active__Date'					
					,BCKGRND_INVSTGTN_COMPLT_DATE	VARCHAR2(50)	Path 'Initiate__Background__Investigation__Complete__Date'					
					,ARRIVAL_VERIFIED_COMPLT_DATE	VARCHAR2(50)	Path 'New__Hire__Arrival__Verified__Complete__Date'					
					,SEND_OFFICL_OFFER_ACTIVE_DATE	VARCHAR2(50)	Path 'Send__Official__Offer__Active__Date'					
					,SEND_OFFICL_OFFER_COMPLT_DATE	VARCHAR2(50)	Path 'Send__Official__Offer__Complete__Date'					
					,SEND_TENTATV_OFFER_ACTIVE_DATE	VARCHAR2(50)	Path 'Send__Tentative__Offer__Active__Date'					
					,SEND_TENTATV_OFFER_COMPLT_DATE	VARCHAR2(50)	Path 'Send__Tentative__Offer__Complete__Date'					
					) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_NEW_HIRE_TASKS: Invalid NEW HIRE TASKS  data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_NEW_HIRE_TASKS - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRE_TASKS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRE_TASKS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRE_TASKS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/


--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_NEW_HIRE_VACNCY_REQ
--------------------------------------------------------
/**
 * Parses WHRSC New Hire Vacancy Request XML data and 
 * stores it into DSS_NEW_HIRE_VACANCY_REQUEST table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_NEW_HIRE_VACNCY_REQ							
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_NEW_HIRE_VACNCY_REQ - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_NEW_HIRE_VACNCY_REQ: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_NEW_HIRE_VACANCY_REQUEST table');					
		INSERT INTO DSS_NEW_HIRE_VACANCY_REQUEST					
			(NEW_HIRE_NUMBER				
			,NH_REQUEST_NUMBER				
			,NH_VACANCY_NUMBER)				
		SELECT					
			X.NEW_HIRE_NUMBER				
			, X.NH_REQUEST_NUMBER				
			, X.NH_VACANCY_NUMBER				
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					NEW_HIRE_NUMBER			VARCHAR2(22)	Path 'New__Hire__Number'
					,NH_REQUEST_NUMBER		VARCHAR2(202)	Path 'New__Hire__Request__Number'					
					,NH_VACANCY_NUMBER		NUMBER(10)		Path 'New__Hire__Vacancy__Number'									
					) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_NEW_HIRE_VACNCY_REQ: Invalid NEW HIRE VACNCY REQUEST  data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_NEW_HIRE_VACNCY_REQ - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRE_VACNCY_REQ -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRE_VACNCY_REQ -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRE_VACNCY_REQ -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/



--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_NEW_HIRES
--------------------------------------------------------
/**
 * Parses WHRSC New Hires XML data and 
 * stores it into DSS_NEW_HIRES table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_NEW_HIRES							
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_NEW_HIRES - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_NEW_HIRES: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_NEW_HIRES table');					
		INSERT INTO DSS_NEW_HIRES					
			(	NEW_HIRE_NUMBER			
				, NH_ACTUAL_START_DATE						
				, NH_APPLICANT_ID						
				, NH_APPLICANT_NAME						
				, NH_APPLICATION_NUMBER						
				, NH_CREATION_DATE						
				, NH_DUTY_LOCATION						
				, NH_DUTY_LOCATION_CODE						
				, NH_EMAIL						
				, NH_FIRST_NAME						
				, NH_GRADE						
				, NH_LAST_NAME						
				, NH_LAST_UPDATE_DATE						
				, NH_MAIDEN_NAME						
				, NH_MIDDLE_NAME						
				, NH_NAME						
				, NH_ONBOARDING_PROCESS_OWNER						
				, NH_PAY_PLAN						
				, NH_POSITION_DESCRIPTION_NUMBER						
				, NH_POSITION_TITLE						
				, NH_PROJECTED_START_DATE						
				, NH_PROLONGED_START_DATE_REASON						
				, NH_SERIES						
				, NH_STAFFING_CUSTOMER						
				, NH_STATUS						
				, NH_VETERANS_PREFERENCE_STATUS)						
		SELECT					
				X.NEW_HIRE_NUMBER			
				, TO_DATE(SUBSTR(X.NH_ACTUAL_START_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS NH_ACTUAL_START_DATE							
				, X.NH_APPLICANT_ID							
				, X.NH_APPLICANT_NAME							
				, X.NH_APPLICATION_NUMBER							
				, TO_DATE(SUBSTR(X.NH_CREATION_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS NH_CREATION_DATE							
				, X.NH_DUTY_LOCATION							
				, X.NH_DUTY_LOCATION_CODE							
				, X.NH_EMAIL							
				, X.NH_FIRST_NAME							
				, X.NH_GRADE							
				, X.NH_LAST_NAME							
				, TO_DATE(SUBSTR(X.NH_LAST_UPDATE_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS NH_LAST_UPDATE_DATE							
				, X.NH_MAIDEN_NAME							
				, X.NH_MIDDLE_NAME							
				, X.NH_NAME							
				, X.NH_ONBOARDING_PROCESS_OWNER							
				, X.NH_PAY_PLAN							
				, X.NH_POSITION_DESCRIPTION_NUMBER							
				, X.NH_POSITION_TITLE							
				, TO_DATE(SUBSTR(X.NH_PROJECTED_START_DATE, 1, 19), 'YYYY-MM-DD"T"HH24:MI:SS') AS NH_PROJECTED_START_DATE							
				, X.NH_PROLONGED_START_DATE_REASON							
				, X.NH_SERIES							
				, X.NH_STAFFING_CUSTOMER							
				, X.NH_STATUS							
				, X.NH_VETERANS_PREFERENCE_STATUS							
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					NEW_HIRE_NUMBER						VARCHAR2(22)	Path 'New__Hire__Number'
					,NH_ACTUAL_START_DATE				VARCHAR2(50)	Path 'New__Hire__Actual__Start__Date'					
					,NH_APPLICANT_ID					NUMBER(20)		Path 'New__Hire__Applicant__ID'					
					,NH_APPLICANT_NAME					VARCHAR2(620)	Path 'New__Hire__Applicant__Name'					
					,NH_APPLICATION_NUMBER				VARCHAR2(22)	Path 'New__Hire__Application__Number'					
					,NH_CREATION_DATE					VARCHAR2(50)	Path 'New__Hire__Creation__Date'					
					,NH_DUTY_LOCATION					VARCHAR2(2050)	Path 'New__Hire__Duty__Location'					
					,NH_DUTY_LOCATION_CODE				VARCHAR2(2050)	Path 'New__Hire__Duty__Location__Code'					
					,NH_EMAIL							VARCHAR2(2050)	Path 'New__Hire__Email'					
					,NH_FIRST_NAME						VARCHAR2(2050)	Path 'New__Hire__First__Name'					
					,NH_GRADE							VARCHAR2(2050)	Path 'New__Hire__Grade'					
					,NH_LAST_NAME						VARCHAR2(2050)	Path 'New__Hire__Last__Name'					
					,NH_LAST_UPDATE_DATE				VARCHAR2(50)	Path 'New__Hire__Last__Update__Date_x002fTime'					
					,NH_MAIDEN_NAME						VARCHAR2(2050)	Path 'New__Hire__Maiden__Name'					
					,NH_MIDDLE_NAME						VARCHAR2(2050)	Path 'New__Hire__Middle__Name'					
					,NH_NAME							VARCHAR2(2050)	Path 'New__Hire__Name'					
					,NH_ONBOARDING_PROCESS_OWNER		VARCHAR2(204)	Path 'New__Hire__Onboarding__Process__Owner'					
					,NH_PAY_PLAN						VARCHAR2(2050)	Path 'New__Hire__Pay__Plan'					
					,NH_POSITION_DESCRIPTION_NUMBER		VARCHAR2(2050)	Path 'New__Hire__Position__Description__Number'					
					,NH_POSITION_TITLE					VARCHAR2(2050)	Path 'New__Hire__Position__Title'					
					,NH_PROJECTED_START_DATE			VARCHAR2(50)	Path 'New__Hire__Projected__Start__Date'					
					,NH_PROLONGED_START_DATE_REASON		VARCHAR2(2050)	Path 'New__Hire__Prolonged__Start__Date__Reason'					
					,NH_SERIES							VARCHAR2(2050)	Path 'New__Hire__Series'					
					,NH_STAFFING_CUSTOMER				VARCHAR2(202)	Path 'New__Hire__Staffing__Customer'					
					,NH_STATUS							VARCHAR2(1002)	Path 'New__Hire__Status'					
					,NH_VETERANS_PREFERENCE_STATUS		VARCHAR2(2050)	Path 'New__Hire__Veterans__Preference__Status'					
												
					) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_NEW_HIRES: Invalid NEW HIRES  data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_NEW_HIRES - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRES -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRES -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_NEW_HIRES -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/



--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_PERMISSION_PROFILES
--------------------------------------------------------
/**
 * Parses WHRSC Permission Profiles XML data and 
 * stores it into DSS_PERMISSION_PROFILES table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_PERMISSION_PROFILES							
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_PERMISSION_PROFILES - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_PERMISSION_PROFILES: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_PERMISSION_PROFILES table');					
		INSERT INTO DSS_PERMISSION_PROFILES					
			(	ACCOUNT_USER_EMAIL			
				, STAFFING_CUSTOMER_NAME						
				, STAFFING_OFFICE_CODE						
				, STAFFING_ORGANIZATION_CODE						
				, PERMISSION_PROFILE_NAME						
				, CURRENT_INDICATOR)						
		SELECT					
				X.ACCOUNT_USER_EMAIL			
				, X.STAFFING_CUSTOMER_NAME							
				, X.STAFFING_OFFICE_CODE							
				, X.STAFFING_ORGANIZATION_CODE							
				, X.PERMISSION_PROFILE_NAME							
				, X.CURRENT_INDICATOR							
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					ACCOUNT_USER_EMAIL			VARCHAR2(242)	Path 'Account__User__Email'
					,STAFFING_CUSTOMER_NAME		VARCHAR2(202)	Path 'Staffing__Customer__Name'					
					,STAFFING_OFFICE_CODE		VARCHAR2(10)	Path 'Staffing__Office__Code'					
					,STAFFING_ORGANIZATION_CODE	VARCHAR2(10)	Path 'Staffing__Organization__Code'					
					,PERMISSION_PROFILE_NAME	VARCHAR2(82)	Path 'Permission__Profile__Name'					
					,CURRENT_INDICATOR			VARCHAR2(8)		Path 'Permission__Profile__Current__Indicator'					
					) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_PERMISSION_PROFILES: Invalid PERMISSION PROFILES  data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_PERMISSION_PROFILES - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_PERMISSION_PROFILES -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_PERMISSION_PROFILES -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_PERMISSION_PROFILES -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/



--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_REQUEST_LOCATIONS
--------------------------------------------------------
/**
 * Parses WHRSC Request Locations XML data and 
 * stores it into DSS_REQUEST_LOCATIONS table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_REQUEST_LOCATIONS							
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_REQUEST_LOCATIONS - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_REQUEST_LOCATIONS: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_REQUEST_LOCATIONS table');					
		INSERT INTO DSS_REQUEST_LOCATIONS					
			(	REQUEST_NUMBER			
				, LOCATION_OPENINGS						
				, LOCATION_CODE						
				, LOCATION_CITY						
				, LOCATION_STATE_ABBR						
				, LOCATION_COUNTRY)						
		SELECT					
				X.REQUEST_NUMBER			
				, X.LOCATION_OPENINGS							
				, X.LOCATION_CODE							
				, X.LOCATION_CITY							
				, X.LOCATION_STATE_ABBR							
				, X.LOCATION_COUNTRY							
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					REQUEST_NUMBER			VARCHAR2(202)	Path 'Request__Number'
					,LOCATION_OPENINGS		VARCHAR2(12)	Path 'Request__Location__Openings'					
					,LOCATION_CODE			VARCHAR2(34)	Path 'Request__Location__Code'					
					,LOCATION_CITY			VARCHAR2(122)	Path 'Request__Location__City'					
					,LOCATION_STATE_ABBR	VARCHAR2(8)		Path 'Request__Location__State__Abbreviation'					
					,LOCATION_COUNTRY		VARCHAR2(202)	Path 'Request__Location__Country'					
					) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_REQUEST_LOCATIONS: Invalid REQUEST LOCATIONS  data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_REQUEST_LOCATIONS - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_REQUEST_LOCATIONS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_REQUEST_LOCATIONS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_REQUEST_LOCATIONS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/

			


--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_REQUEST_RATING_COMB
--------------------------------------------------------
/**
 * Parses WHRSC Request Rating Combinations XML data and 
 * stores it into DSS_REQUEST_RATING_COMBINATION table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_REQUEST_RATING_COMB							
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_REQUEST_RATING_COMB - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_REQUEST_RATING_COMB: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_REQUEST_RATING_COMBINATION table');					
		INSERT INTO DSS_REQUEST_RATING_COMBINATION					
			(	REQUEST_NUMBER			
				, POSITION_DESCRIPTION_TITLE						
				, PAY_PLAN						
				, SERIES						
				, GRADE)						
		SELECT					
				X.REQUEST_NUMBER			
				, X.POSITION_DESCRIPTION_TITLE							
				, X.PAY_PLAN							
				, X.SERIES							
				, X.GRADE							
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					REQUEST_NUMBER				VARCHAR2(202)	Path 'Request__Number'
					,POSITION_DESCRIPTION_TITLE	VARCHAR2(202)	Path 'Request__Position__Description__Title'					
					,PAY_PLAN					VARCHAR2(102)	Path 'Pay__Plan'					
					,SERIES						VARCHAR2(22)	Path 'Series'					
					,GRADE						VARCHAR2(6)	Path 'Grade'					
					) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_REQUEST_RATING_COMB: Invalid REQUEST RATING COMBINATION  data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_REQUEST_RATING_COMB - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_REQUEST_RATING_COMB -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_REQUEST_RATING_COMB -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_REQUEST_RATING_COMB -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/



--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_REQUEST_VACNCY_COMB
--------------------------------------------------------
/**
 * Parses WHRSC Request Vacancy Combinations XML data and 
 * stores it into DSS_REQUEST_VACNCY_COMBINATION table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_REQUEST_VACNCY_COMB						
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_REQUEST_VACNCY_COMB - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_REQUEST_VACNCY_COMB: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_REQUEST_VACNCY_COMBINATION table');					
		INSERT INTO DSS_REQUEST_VACNCY_COMBINATION					
			(	REQUEST_NUMBER			
				, VACANCY_NUMBER						
				, VCNCY_STAFFG_ORGANIZATN_CODE)						
		SELECT					
				X.REQUEST_NUMBER			
				, X.VACANCY_NUMBER							
				, X.VCNCY_STAFFG_ORGANIZATN_CODE							
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					REQUEST_NUMBER					VARCHAR2(202)	Path 'Request__Number'
					,VACANCY_NUMBER					NUMBER(10)		Path 'Vacancy__Number'					
					,VCNCY_STAFFG_ORGANIZATN_CODE	VARCHAR2(10)	Path 'Vacancy__Staffing__Organization__Code'
					) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_REQUEST_VACNCY_COMB: Invalid REQUEST VACANCY COMBINATION  data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_REQUEST_VACNCY_COMB - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_REQUEST_VACNCY_COMB -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_REQUEST_VACNCY_COMB -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_REQUEST_VACNCY_COMB -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/



--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_REQUESTS
--------------------------------------------------------
/**
 * Parses WHRSC Requests XML data and 
 * stores it into DSS_REQUESTS table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_REQUESTS						
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_REQUESTS - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_REQUESTS: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_REQUESTS table');					
		INSERT INTO DSS_REQUESTS					
			(	REQUEST_NUMBER			
				,CLEARANCE_LEVEL_REQUIRED							
				,REQUEST_TYPE							
				,CUSTOMER_NAME							
				,REQUESTER_NAME							
				,SUPERVISORY_POSITION							
				,TRAVEL_PREFERENCE							
				,DESCRIPTION)							
		SELECT					
				X.REQUEST_NUMBER			
				, X.CLEARANCE_LEVEL_REQUIRED							
				, X.REQUEST_TYPE							
				, X.CUSTOMER_NAME							
				, X.REQUESTER_NAME							
				, X.SUPERVISORY_POSITION							
				, X.TRAVEL_PREFERENCE							
				, X.DESCRIPTION							
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					REQUEST_NUMBER				VARCHAR2(202)	Path 'Request__Number'
					,CLEARANCE_LEVEL_REQUIRED	VARCHAR2(1002)	Path 'Clearance__Level__Required__for__Position'					
					,REQUEST_TYPE				VARCHAR2(1002)	Path 'Request__Type'					
					,CUSTOMER_NAME				VARCHAR2(202)	Path 'Request__Customer__Name'					
					,REQUESTER_NAME				VARCHAR2(206)	Path 'Requester__Name'					
					,SUPERVISORY_POSITION		VARCHAR2(8)		Path 'Request__Supervisory__Position'					
					,TRAVEL_PREFERENCE			VARCHAR2(1002)	Path 'Request__Travel__Preference'					
					,DESCRIPTION				VARCHAR2(4000)	Path 'Request__Description'					
					) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_REQUESTS: Invalid REQUESTS  data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_REQUESTS - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_REQUESTS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_REQUESTS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_REQUESTS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/



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

			


--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_VACANCY_ELIGIBILITIS
--------------------------------------------------------
/**
 * Parses WHRSC Vacancy Eligibilities XML data and 
 * stores it into DSS_VACANCY_ELIGIBILITIES table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_VACANCY_ELIGIBILITIS							
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_VACANCY_ELIGIBILITIS - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_VACANCY_ELIGIBILITIS: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_VACANCY_ELIGIBILITIES table');					
		INSERT INTO DSS_VACANCY_ELIGIBILITIES					
			(	VACANCY_IDENTIFICATION_NUMBER			
				, VACANCY_ELIGIBILITY)						
		SELECT					
				X.VACANCY_IDENTIFICATION_NUMBER			
				, X.VACANCY_ELIGIBILITY							
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					VACANCY_IDENTIFICATION_NUMBER	NUMBER(10)		Path 'Vacancy__Identification__Number'
					,VACANCY_ELIGIBILITY			VARCHAR2(22)	Path 'Vacancy__Eligibility'					
					) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_VACANCY_ELIGIBILITIS: Invalid VACANCY ELIGIBILITIES data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_VACANCY_ELIGIBILITIS - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VACANCY_ELIGIBILITIS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VACANCY_ELIGIBILITIS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VACANCY_ELIGIBILITIS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/

			

--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_VACANCY_LOCATIONS
--------------------------------------------------------
/**
 * Parses WHRSC Vacancy Locations XML data and 
 * stores it into DSS_VACANCY_LOCATIONS table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_VACANCY_LOCATIONS							
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_VACANCY_LOCATIONS - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_VACANCY_LOCATIONS: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_VACANCY_LOCATIONS table');					
		INSERT INTO DSS_VACANCY_LOCATIONS					
			(	VACANCY_IDENTIFICATION_NUMBER			
				, LOCATION_OPENINGS						
				, LOCATION_CODE						
				, LOCATION_CITY						
				, LOCATION_STATE_ABBR						
				, LOCATION_COUNTRY)						
		SELECT					
				 X.VACANCY_IDENTIFICATION_NUMBER			
				, X.LOCATION_OPENINGS							
				, X.LOCATION_CODE							
				, X.LOCATION_CITY							
				, X.LOCATION_STATE_ABBR							
				, X.LOCATION_COUNTRY							
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					VACANCY_IDENTIFICATION_NUMBER	NUMBER(10)		Path 'Vacancy__Identification__Number'
					,LOCATION_OPENINGS				VARCHAR2(12)	Path 'Announcement__Location__Openings'					
					,LOCATION_CODE					VARCHAR2(34)	Path 'Announcement__Location__Code'					
					,LOCATION_CITY					VARCHAR2(122)	Path 'Announcement__Location__City'					
					,LOCATION_STATE_ABBR			VARCHAR2(8)		Path 'Announcement__Location__State__Abbreviation'					
					,LOCATION_COUNTRY				VARCHAR2(202)	Path 'Announcement__Location__Country'					
					) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_VACANCY_LOCATIONS: Invalid VACANCY LOCATIONS data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_VACANCY_LOCATIONS - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VACANCY_LOCATIONS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VACANCY_LOCATIONS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VACANCY_LOCATIONS -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/



--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_VACANCY_RATING_COMB
--------------------------------------------------------
/**
 * Parses WHRSC Vacancy Rating Combinations XML data and 
 * stores it into DSS_VACANCY_RATING_COMBINATION table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_VACANCY_RATING_COMB							
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_VACANCY_RATING_COMB - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_VACANCY_RATING_COMB: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_VACANCY_RATING_COMBINATION table');					
		INSERT INTO DSS_VACANCY_RATING_COMBINATION					
			(	VACANCY_IDENTIFICATION_NUMBER			
				, SERIES						
				, GRADE						
				, PAY_PLAN)						
		SELECT					
				X.VACANCY_IDENTIFICATION_NUMBER			
				, X.SERIES							
				, X.GRADE							
				, X.PAY_PLAN							
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					VACANCY_IDENTIFICATION_NUMBER	NUMBER(10)		Path 'Vacancy__Identification__Number'
					,SERIES							VARCHAR2(22)	Path 'Series'					
					,GRADE							VARCHAR2(6)		Path 'Grade'					
					,PAY_PLAN						VARCHAR2(102)	Path 'Pay__Plan'					
					) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_VACANCY_RATING_COMB: Invalid VACANCY RATING COMBINATION data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_VACANCY_RATING_COMB - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VACANCY_RATING_COMB -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VACANCY_RATING_COMB -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VACANCY_RATING_COMB -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/

			
--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_VAC_MISSN_CRITCL_OCC
--------------------------------------------------------
/**
 * Parses WHRSC Vacancy Mission Critical Occupations XML data and 
 * stores it into DSS_VAC_MISSION_CRITCL_OCCUPTN table.
 *
 * @param I_ID - Record ID
 */
 CREATE OR REPLACE PROCEDURE SP_UPDATE_VAC_MISSN_CRITCL_OCC							
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
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_VAC_MISSN_CRITCL_OCC - BEGIN ============================');						
	--DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');						
	--DBMS_OUTPUT.PUT_LINE('    I_ID IS NULL?  = ' || (CASE WHEN I_ID IS NULL THEN 'YES' ELSE 'NO' END));						
	--DBMS_OUTPUT.PUT_LINE('    I_ID           = ' || TO_CHAR(I_ID));						
	--DBMS_OUTPUT.PUT_LINE(' ----------------');						
							
	--DBMS_OUTPUT.PUT_LINE('Starting xml data retrieval and table update ----------');						
							
	IF I_ID IS NULL THEN						
		RAISE_APPLICATION_ERROR(-20920, 'SP_UPDATE_VAC_MISSN_CRITCL_OCC: Input Record ID is invalid.  I_ID = '	|| TO_CHAR(I_ID) );				
	END IF;						
							
	BEGIN						
							
		--DBMS_OUTPUT.PUT_LINE('    DSS_VAC_MISSION_CRITCL_OCCUPTN table');					
		INSERT INTO DSS_VAC_MISSION_CRITCL_OCCUPTN					
			(	VACANCY_NUMBER			
				, VCNCY_MISSION_CRITICAL_OCCUPTN						
				, TAG_LEVEL)						
		SELECT					
				 X.VACANCY_NUMBER			
				, X.VCNCY_MISSION_CRITICAL_OCCUPTN							
				, X.TAG_LEVEL							
		FROM INTG_DATA_DTL IDX					
			, XMLTABLE(XMLNAMESPACES(DEFAULT 'http://www.ibm.com/xmlns/prod/cognos/dataSet/201006'), '/dataSet/dataTable/row[../id/text() = "List1"]'				
				PASSING IDX.FIELD_DATA			
				COLUMNS			
					VACANCY_NUMBER					NUMBER(10)		Path 'Vacancy__Number'
					,VCNCY_MISSION_CRITICAL_OCCUPTN	VARCHAR2(22)	Path 'Vacancy__Mission__Critical__Occupation'					
					,TAG_LEVEL						VARCHAR2(6)		Path 'Vacancy__Mission__Critical__Occupation__Tag__Level'					
) X							
		WHERE IDX.ID = I_ID;					
							
	EXCEPTION						
		WHEN OTHERS THEN					
			RAISE_APPLICATION_ERROR(-20921, 'SP_UPDATE_VAC_MISSN_CRITCL_OCC: Invalid VACANCY MISSION CRITICAL OCCUPATION data.  I_ID = ' || TO_CHAR(I_ID) );				
	END;						
							
	--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_VAC_MISSN_CRITCL_OCC - END ==========================');						
							
							
EXCEPTION							
	WHEN E_INVALID_REC_ID THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VAC_MISSN_CRITCL_OCC -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Record ID is not valid');					
	WHEN E_INVALID_DATA THEN						
		SP_ERROR_LOG();					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VAC_MISSN_CRITCL_OCC -------------------');					
		--DBMS_OUTPUT.PUT_LINE('ERROR message = ' || 'Invalid data');					
	WHEN OTHERS THEN						
		SP_ERROR_LOG();					
		V_ERRCODE := SQLCODE;					
		V_ERRMSG := SQLERRM;					
		--DBMS_OUTPUT.PUT_LINE('ERROR occurred while executing SP_UPDATE_VAC_MISSN_CRITCL_OCC -------------------');					
		--DBMS_OUTPUT.PUT_LINE('Error code    = ' || V_ERRCODE);					
		--DBMS_OUTPUT.PUT_LINE('Error message = ' || V_ERRMSG);					
END;
/

			
--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_INTG_DATA
--------------------------------------------------------

 CREATE OR REPLACE PROCEDURE SP_UPDATE_INTG_DATA
(
	IO_ID               IN OUT  NUMBER
	, I_INTG_TYPE       IN      VARCHAR2
	, I_FIELD_DATA      IN      CLOB
	, I_USER            IN      VARCHAR2
)
IS
	V_ID                        NUMBER(20);
	V_INTG_TYPE                 VARCHAR2(50);
	V_USER                      VARCHAR2(50);
	V_REC_CNT                   NUMBER(10);
	V_MAX_ID                    NUMBER(20);
	V_XMLDOC                    XMLTYPE;
BEGIN
--	DBMS_OUTPUT.PUT_LINE('PARAMETERS ----------------');
--	DBMS_OUTPUT.PUT_LINE('    ID IS NULL?  = ' || (CASE WHEN IO_ID IS NULL THEN 'YES' ELSE 'NO' END));
--	DBMS_OUTPUT.PUT_LINE('    ID           = ' || TO_CHAR(IO_ID));
--	DBMS_OUTPUT.PUT_LINE('    I_INTG_TYPE  = ' || I_INTG_TYPE);
--	DBMS_OUTPUT.PUT_LINE('    I_FIELD_DATA = ' || I_FIELD_DATA);
--	DBMS_OUTPUT.PUT_LINE('    I_USER       = ' || I_USER);
--	DBMS_OUTPUT.PUT_LINE(' ----------------');


	V_ID := IO_ID;

	DBMS_OUTPUT.PUT_LINE('ID to be used is determined: ' || TO_CHAR(V_ID));


	BEGIN
		SELECT COUNT(*) INTO V_REC_CNT FROM INTG_DATA_DTL WHERE ID = V_ID;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			V_REC_CNT := -1;
	END;

	V_INTG_TYPE := I_INTG_TYPE;
	V_USER := I_USER;

--	DBMS_OUTPUT.PUT_LINE('Inspected existence of same record.');
--	DBMS_OUTPUT.PUT_LINE('    V_ID       = ' || TO_CHAR(V_ID));
--	DBMS_OUTPUT.PUT_LINE('    V_REC_CNT  = ' || TO_CHAR(V_REC_CNT));

	V_XMLDOC := XMLTYPE(I_FIELD_DATA);

	IF V_REC_CNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('Record found so that field data will be updated on the same record.');

		UPDATE INTG_DATA_DTL
		SET
			INTG_TYPE = V_INTG_TYPE
			, FIELD_DATA = V_XMLDOC
			, MOD_DT = SYSDATE
			, MOD_USR = V_USER
		WHERE ID = V_ID
		;

	ELSE
		DBMS_OUTPUT.PUT_LINE('No record found so that new record will be inserted.');

		INSERT INTO INTG_DATA_DTL
		(
			INTG_TYPE
			, FIELD_DATA
			, CRT_DT
			, CRT_USR
		)
		VALUES
		(
			V_INTG_TYPE
			, V_XMLDOC
			, SYSDATE
			, V_USER
		)
		RETURNING ID INTO V_ID
		;
	END IF;

	--------------------------------------------
	-- Parse XML data into respective tables
	--------------------------------------------
	IF V_INTG_TYPE = 'APPNOTIF'	THEN	
		SP_UPDATE_APPLICANT_NOTIFICTNS(V_ID);
	ELSIF V_INTG_TYPE = 'CERTLOC' THEN	
		SP_UPDATE_CERTIFICATE_LOCATION(V_ID);
	ELSIF V_INTG_TYPE = 'CERTS' THEN	
		SP_UPDATE_CERTIFICATES(V_ID);
	ELSIF V_INTG_TYPE = 'NEWHIREFORMS' THEN	
		SP_UPDATE_NEW_HIRE_FORMS(V_ID);
	ELSIF V_INTG_TYPE = 'NEWHIREONDOCS' THEN	
		SP_UPDATE_NEW_HIRE_ONBRDNG_DOC(V_ID);
	ELSIF V_INTG_TYPE = 'NEWHIRETASK' THEN	
		SP_UPDATE_NEW_HIRE_TASKS(V_ID);
	ELSIF V_INTG_TYPE = 'NEWHIREVACREQ' THEN	
		SP_UPDATE_NEW_HIRE_VACNCY_REQ(V_ID);
	ELSIF V_INTG_TYPE = 'NEWHIRES' THEN	
		SP_UPDATE_NEW_HIRES(V_ID);
	ELSIF V_INTG_TYPE = 'PERMPROFILE' THEN	
		SP_UPDATE_PERMISSION_PROFILES(V_ID);
	ELSIF V_INTG_TYPE = 'REQLOC' THEN	
		SP_UPDATE_REQUEST_LOCATIONS(V_ID);
	ELSIF V_INTG_TYPE = 'REQRATNGCOMB' THEN	
		SP_UPDATE_REQUEST_RATING_COMB(V_ID);
	ELSIF V_INTG_TYPE = 'REQVACNCYCOMB' THEN	
		SP_UPDATE_REQUEST_VACNCY_COMB(V_ID);
	ELSIF V_INTG_TYPE = 'REQUESTS' THEN	
		SP_UPDATE_REQUESTS(V_ID);
	ELSIF V_INTG_TYPE = 'VACNCY' THEN	
		SP_UPDATE_VACANCY(V_ID);
	ELSIF V_INTG_TYPE = 'VACNCYELIG' THEN	
		SP_UPDATE_VACANCY_ELIGIBILITIS(V_ID);
	ELSIF V_INTG_TYPE = 'VACNCYLOC' THEN	
		SP_UPDATE_VACANCY_LOCATIONS(V_ID);
	ELSIF V_INTG_TYPE = 'VACNCYMISSNCRITCL' THEN	
		SP_UPDATE_VAC_MISSN_CRITCL_OCC(V_ID);
	ELSIF V_INTG_TYPE = 'VACNCYRATNGCOMB' THEN	
		SP_UPDATE_VACANCY_RATING_COMB(V_ID);
	END IF;
	

	COMMIT;

EXCEPTION
	WHEN OTHERS THEN
		SP_ERROR_LOG();
--		DBMS_OUTPUT.PUT_LINE('Error occurred while executing UPDATE_INTG_DATA -------------------');
END;
/