
--------------------------------------------------------
--  DDL for Function FN_GET_BRANCH_FOR_AN_IC
--------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_GET_BRANCH_FOR_AN_IC (I_IC VARCHAR2, I_STATUS_DATE DATE, I_STATUS VARCHAR2)
RETURN VARCHAR2 
AS
 V_BRANCH VARCHAR2(2);
BEGIN

	SELECT CASE WHEN I_STATUS = 'ACTIVE' THEN 
			(SELECT DISTINCT CURRENT_BRANCH
             FROM BRANCHES
             WHERE NVL(IC, 'UNKNOWN') = I_IC
             AND EFF_END_DATE = TO_DATE('9/9/9999', 'MM/DD/YYYY'))
           ELSE 		
            (SELECT DISTINCT CURRENT_BRANCH
             FROM BRANCHES
             WHERE NVL(IC, 'UNKNOWN') = I_IC
             AND I_STATUS_DATE BETWEEN EFF_START_DATE AND EFF_END_DATE)
           END  
    INTO V_BRANCH FROM DUAL;
	RETURN V_BRANCH;
END;
/

--------------------------------------------------------
--  DDL for Function FN_GET_DEPUTY_FOR_AN_IC
--------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_GET_DEPUTY_FOR_AN_IC (I_IC VARCHAR2, I_SSB VARCHAR2)
RETURN VARCHAR2 
AS
	V_BRANCH VARCHAR2(3);
	V_DDEMAIL VARCHAR2(100);
BEGIN

	IF I_SSB IN ('Yes') THEN V_BRANCH := 'GRU';
	ELSE SELECT DISTINCT CURRENT_BRANCH
		INTO V_BRANCH
		FROM BRANCHES
		WHERE NVL(IC, 'UNKNOWN') = I_IC
		AND EFF_END_DATE = TO_DATE('9/9/9999', 'MM/DD/YYYY');
	END IF;	
  
	IF V_BRANCH  IN ('A') THEN V_DDEMAIL := 'xxx@nih.gov';
	ELSE IF V_BRANCH  IN ('C') THEN V_DDEMAIL := 'xxx@od.nih.gov';
	ELSE IF V_BRANCH IN ('B') THEN V_DDEMAIL := 'xxx@mail.nih.gov';
	ELSE IF V_BRANCH IN ('SSB', 'DEU') THEN V_DDEMAIL := 'xxx@nih.gov';
	ELSE V_DDEMAIL := 'xxx@od.nih.gov'; 
	END IF;  
	END IF;
	END IF;  
	END IF;
		
	RETURN V_DDEMAIL;
END FN_GET_DEPUTY_FOR_AN_IC;
/

--------------------------------------------------------
--  DDL for Function FN_GET_RECRUITMENT_PRE_VAL
--------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_GET_RECRUITMENT_PRE_VAL 
(
  I_TRANS_ID IN VARCHAR2, I_POS_TYPE IN VARCHAR2
) RETURN VARCHAR2 AS 

V_TABLETOP VARCHAR2(5000);
V_TABLEBOTTOM VARCHAR2(5000);
V_RYBSTATUS VARCHAR2(500);
V_INITIATED VARCHAR2(50);
V_WITSNUMBER VARCHAR2(10);
V_ADMINOFFICERNAME VARCHAR2(100);
V_SELECTINGOFFICIALNAME VARCHAR2(100);
V_IC VARCHAR2(10);
V_ORGINITS VARCHAR2(50);
V_ADMINCODE VARCHAR2(50);
V_POSITIONTITLE VARCHAR2(100);
V_PAYPLAN VARCHAR2(100);
V_SERIES VARCHAR2(100);
V_GRADE VARCHAR2(100);
V_CAN VARCHAR2(100);
V_POSITIONS VARCHAR2(100);
V_ALL_POSITIONS VARCHAR2(8000) := ''; 
V_INTCOUNT INT;
V_TYPE VARCHAR2(10);

CURSOR CUR_RECIPIENTS IS	 

    SELECT distinct
		NVL(A.RYB_STATUS, '') || ' /<br> ' || NVL(A.RYB_DESCRIPTION, ''),
        TO_CHAR(A.DATE_RECEIVED,'MM/DD/YYYY'),
		A.TRANSACTION_ID,
		UPPER (NVL(D.FTE_LIAISON_FIRST_NAME, '')) || ' ' || UPPER (NVL(D.FTE_LIAISON_LAST_NAME, 'Not Available')),
		UPPER (NVL(D.PROGRAM_MGR_FIRST_NAME, '')) || ' ' || UPPER (NVL(D.PROGRAM_MGR_LAST_NAME, 'Not Available')),
		NVL(O.IC, ''),
		NVL(O.ORG_INITS, ''),
		NVL(O.ADMIN_CODE, ''),
		NVL(C.POSITION_TITLE, '[Not Available]'),
		NVL(C.PAY_PLAN, '[Not Available]'),
		NVL(C.SERIES,  '[Not Available]'),
		NVL(C.GRADE, '[Not Available]'),
		NVL(C1.CAN_NO, 'Not Available')
		FROM 
		MAIN A /*(NOLOCK)*/
		INNER JOIN ORGS O /*(NOLOCK)*/ ON O.ADMIN_CODE = A.ADMIN_CODE
		LEFT JOIN NEW_POSITION C /*(NOLOCK)*/
		ON A.TRANSACTION_ID = C.TRANSACTION_ID
		AND C.TYPE = 'New'
		LEFT JOIN NEW_POSITION C1 /*(NOLOCK)*/
		ON A.TRANSACTION_ID = C1.TRANSACTION_ID
		AND C1.TYPE = 'New' AND C1.SEQUENCE = '0' 
		LEFT JOIN IC_REQUEST_INFO D
		ON A.TRANSACTION_ID = D.TRANSACTION_ID
		WHERE A.TRANSACTION_ID = I_TRANS_ID
;

BEGIN
    OPEN CUR_RECIPIENTS;  
    
    LOOP
      FETCH CUR_RECIPIENTS INTO
        V_RYBSTATUS,
        V_INITIATED,
        V_WITSNUMBER,
        V_ADMINOFFICERNAME,
        V_SELECTINGOFFICIALNAME,
        V_IC,
        V_ORGINITS,
        V_ADMINCODE,
        V_POSITIONTITLE,
        V_PAYPLAN,
        V_SERIES,
        V_GRADE,
        V_CAN;

      EXIT WHEN CUR_RECIPIENTS%NOTFOUND;    
            
      --IF V_ALL_POSITIONS > '' THEN
        V_ALL_POSITIONS := V_ALL_POSITIONS || '<html>  ' ||
		'<body>   ' ||
		'<table border="1" bordercolor="#BDBDBD" style="background-color:#FFFFFF" cellpadding="2" cellspacing="2"><font face=" Calibri" size="2">' ||
		'<tr>    												' ||
		'<td style="width: 170px">        						' ||
		'<font face=" Calibri" size="2"><strong>Current Status</strong></td>						' ||
		'<td style="width: 200px;"><font face=" Calibri" size="2">' || V_RYBSTATUS || '</td>			' ||
		'</tr>													' ||
		'<tr>    												' ||
		'<td style="width: 170px">        						' ||
		'<font face=" Calibri" size="2"><strong>Initiated</strong></td>					' ||
		'<td style="width: 200px;"><font face=" Calibri" size="2">' || V_INITIATED || '</td>			' ||
		'</tr>													' ||
		'<tr>    												' ||
		'<td style="width: 170px">        						' ||
		'<font face=" Calibri" size="2"><strong>Request #</strong></td>					' ||
		'<td style="width: 200px;"><font face=" Calibri" size="2">' || V_WITSNUMBER || '</td>			' ||
		'</tr>													' ||
		'<tr>    												' ||
		'<td style="width: 170px">        						' ||
		'<font face=" Calibri" size="2"><strong>Submitted By/Org</strong></td>					' ||
		'<td style="width: 200px;"><font face=" Calibri" size="2">' || V_ADMINOFFICERNAME || ' /<br> ' || V_IC || ' ' || V_ORGINITS || '</td>	' ||
		'</tr>													' ||
		'<tr>    												' ||
		'<td style="width: 170px">    							' ||
		'<font face=" Calibri" size="2"><strong>Admin Code</strong></td>							' ||
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_ADMINCODE || '</td>			' ||
		'</tr>													' ||
		'<tr>													' ||
		'<td style="width: 170px">    							' ||
		'<font face=" Calibri" size="2"><strong> Position Title</strong></td>							' ||	
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_POSITIONTITLE || '</td>			' ||
		'</tr>													' ||
		'<tr>													' ||
		'<td style="width: 170px">    							' ||
		'<font face=" Calibri" size="2"><strong>Pay Plan/Series/Grade(s)</strong></td>							' ||	
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_PAYPLAN || '/' || V_SERIES || '/' || V_GRADE || '</td>			' ||
		'</tr>													' ||
		'<tr>													' ||
		'<td style="width: 170px">    							' ||
		'<font face=" Calibri" size="2"><strong> CAN</strong></td>							' ||	
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_CAN || '</td>			' ||
		'</tr>													' ||
		'<!--<tr>													' ||
		'<td style="width: 170px">    							' ||
		'<font face=" Calibri" size="2"><strong> SO</strong></td>							' ||
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_SELECTINGOFFICIALNAME || '</td>			' ||
		'</tr>-->													' ||
		'<tr>													' ||
		'<td style="width: 170px">    							' ||
		'<font face=" Calibri" size="2"><strong> HR Liaison</strong></td>							' ||	
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_ADMINOFFICERNAME || '</td>			' ||
		'</tr>													' ||
		'</table>												' ||
		'<br>'   ||
		'</table></body></html>';
      --ELSE
      --  V_ALL_POSITIONS := V_ALL_POSITIONS;
      --END IF;
          
    END LOOP;  
CLOSE CUR_RECIPIENTS;
  RETURN V_ALL_POSITIONS;
END FN_GET_RECRUITMENT_PRE_VAL;
/

--------------------------------------------------------
--  DDL for Function FN_GET_RECRUITMENT_EMAIL_TBL
--------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_GET_RECRUITMENT_EMAIL_TBL 
(I_WITS_ID IN VARCHAR2, 
 I_POS_TYPE IN VARCHAR2, 
 I_ANNCERTNUMS IN VARCHAR2)
RETURN VARCHAR2 AS 

V_TABLETOP VARCHAR2(4000);
V_TABLEBOTTOM VARCHAR2(4000);
V_WITSNUMBER VARCHAR2(10);
V_ADMINOFFICERNAME VARCHAR2(100);
V_SELECTINGOFFICIALNAME VARCHAR2(100);
V_IC VARCHAR2(10);
V_ORGINITS VARCHAR2(50);
V_ADMINCODE VARCHAR2(50);
V_POSITIONTITLE VARCHAR2(100);
V_PAYPLAN VARCHAR2(100);
V_SERIES VARCHAR2(100);
V_GRADE VARCHAR2(100);
V_ANNNUMBER VARCHAR2(100);
V_POSITIONS VARCHAR2(100);
V_ALL_POSITIONS VARCHAR2(8000) := '';
V_COUNT INT;
V_TYPE VARCHAR2(10);

CURSOR CUR_POSITIONS IS	 

    SELECT DISTINCT 
		A.TRANSACTION_ID,
		UPPER (NVL(D.IC_CONTACT_FIRST_NAME, '')) || ' ' || UPPER (NVL(D.IC_CONTACT_LAST_NAME, 'Not Available')),
		UPPER (NVL(D.PROGRAM_MGR_FIRST_NAME, '')) || ' ' || UPPER (NVL(D.PROGRAM_MGR_LAST_NAME, 'Not Available')),
		NVL(O.IC, ''),
		NVL(O.ORG_INITS, ''),
		NVL(O.ADMIN_CODE, ''),
		NVL(C.POSITION_TITLE, '[Not Available]'),
		NVL(C.PAY_PLAN, '[Not Available]'),
		NVL(C.SERIES,  '[Not Available]'),
		NVL(C.GRADE, '[Not Available]'),
		NVL(B.ANN_NUMBER, '[Announcement Number Not Available]' )
        

		FROM 
		MAIN A /*(NOLOCK)*/
		INNER JOIN ORGS O /*(NOLOCK)*/ ON O.ADMIN_CODE = A.ADMIN_CODE
		LEFT JOIN NEW_POSITION C /*(NOLOCK)*/
		ON A.TRANSACTION_ID = C.TRANSACTION_ID
		AND C.TYPE = 'New'
		LEFT JOIN ANNOUNCEMENT B /*(NOLOCK)*/
		ON A.TRANSACTION_ID = B.TRANSACTION_ID
		LEFT JOIN IC_REQUEST_INFO D
		ON A.TRANSACTION_ID = D.TRANSACTION_ID
		
		WHERE A.TRANSACTION_ID = I_WITS_ID;

BEGIN

    OPEN CUR_POSITIONS;  
    
    LOOP
      FETCH CUR_POSITIONS INTO
        V_WITSNUMBER ,
        V_ADMINOFFICERNAME ,
        V_SELECTINGOFFICIALNAME ,
        V_IC ,
        V_ORGINITS ,
        V_ADMINCODE ,
        V_POSITIONTITLE ,
        V_PAYPLAN ,
        V_SERIES ,
        V_GRADE ,
        V_ANNNUMBER;
      EXIT WHEN CUR_POSITIONS%NOTFOUND;
      
      V_ALL_POSITIONS := V_ALL_POSITIONS ||	
		'<html>  ' ||
		'<body>   ' ||
		'<table border="1" bordercolor="#BDBDBD" style="background-color:#FFFFFF" cellpadding="2" cellspacing="2"><font face=" Calibri" size="2">									' ||
		'<tr>    												'||
		'<td style="width: 170px">        						'||
		'<font face=" Calibri" size="2"><strong>Request #</strong></td>						'||
		'<td style="width: 200px;"><font face=" Calibri" size="2">' || V_WITSNUMBER || '</td>			'||
		'</tr>													'||
		'<tr>    												'||
		'<td style="width: 170px">        						'||
		'<font face=" Calibri" size="2"><strong>Announcement #</strong></td>					'||
		'<td style="width: 200px;"><font face=" Calibri" size="2">'|| V_ANNNUMBER ||'</td>			'||
		'</tr>													'||
		'<tr>    												'||
		'<td style="width: 170px">        						'||
		'<font face=" Calibri" size="2"><strong>Organization</strong></td>					'||
		'<td style="width: 200px;"><font face=" Calibri" size="2"><!--'|| V_ADMINOFFICERNAME || ' /<br> ' || V_IC || ' -->' || V_ORGINITS || '</td>			'||
		'</tr>													'||
		'<tr>    												'||
		'<td style="width: 170px">        						'||
		'<font face=" Calibri" size="2"><strong>Admin Code</strong></td>					'||
		'<td style="width: 200px;"><font face=" Calibri" size="2">'|| V_ADMINCODE ||'</td>	'||
		'</tr>													'||
		'<!--<tr>													'||
		'<td style="width: 170px">    							'||
		'<font face=" Calibri" size="2"><strong> Position Title</strong></td>							'||	
		'<td style="width: 200px"><font face=" Calibri" size="2">'|| V_POSITIONTITLE || '</td>			'||
		'</tr>													'||
		'<tr>													'||
		'<td style="width: 170px">    							'||
		'<font face=" Calibri" size="2"><strong>Pay Plan/Series/Grade(s)</strong></td>							'||	
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_PAYPLAN || '/' || V_SERIES || '/' || V_GRADE || '</td>			'||
		'</tr>-->													'||
		'</table>												'||	
		'<br>'   ||

		'</table></body></html>';

      
      
	END LOOP;  
	CLOSE CUR_POSITIONS;


  RETURN V_ALL_POSITIONS;
END FN_GET_RECRUITMENT_EMAIL_TBL;
/

--------------------------------------------------------
--  DDL for Function FN_GET_RECRUITMENT_SLA_VACAN
--------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_GET_RECRUITMENT_SLA_VACAN 
(I_WITS_ID VARCHAR2) RETURN VARCHAR2 AS 

V_VACANCIES VARCHAR2(500);
V_ALL_VACANCIES VARCHAR2(8000) := '';
V_VACANCIESLIST VARCHAR2(500);


CURSOR CUR_VACANCIES IS

    SELECT 
		NVL(ANN_NUMBER, '[Announcement Number not Available]')
	FROM ANNOUNCEMENT
	WHERE TRANSACTION_ID = I_WITS_ID;
BEGIN
	OPEN CUR_VACANCIES;   
	LOOP 
	FETCH CUR_VACANCIES INTO V_VACANCIESLIST;
	EXIT WHEN CUR_VACANCIES%NOTFOUND;
		IF V_ALL_VACANCIES > '' THEN
			V_ALL_VACANCIES := V_VACANCIESLIST || ',' || V_ALL_VACANCIES;
		ELSE
			V_ALL_VACANCIES := V_VACANCIESLIST;
		END IF;

	END LOOP;     
	CLOSE CUR_VACANCIES;

	RETURN V_ALL_VACANCIES;
END FN_GET_RECRUITMENT_SLA_VACAN;
/

--------------------------------------------------------
--  DDL for Function FN_GET_RECRUITMENT_EMAIL_TB_AP
--------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_GET_RECRUITMENT_EMAIL_TB_AP 
(I_WITS_ID IN VARCHAR2, 
 I_POS_TYPE IN VARCHAR2, 
 I_ANNCERTNUMS IN VARCHAR2)
RETURN VARCHAR2 AS 

V_TABLETOP VARCHAR2(4000);
V_TABLEBOTTOM VARCHAR2(4000);
V_WITSNUMBER VARCHAR2(10);
V_ADMINOFFICERNAME VARCHAR2(100);
V_SELECTINGOFFICIALNAME VARCHAR2(100);
V_IC VARCHAR2(10);
V_ORGINITS VARCHAR2(50);
V_ADMINCODE VARCHAR2(50);
V_POSITIONTITLE VARCHAR2(100);
V_PAYPLAN VARCHAR2(100);
V_SERIES VARCHAR2(100);
V_GRADE VARCHAR2(100);
V_ANNNUMBER VARCHAR2(100);
V_POSITIONS VARCHAR2(100);
V_ALL_POSITIONS VARCHAR2(8000) := '';
V_COUNT INT;
V_TYPE VARCHAR2(10);

CURSOR CUR_POSITIONS IS	 

    SELECT DISTINCT 
		A.TRANSACTION_ID,
		UPPER (NVL(D.IC_CONTACT_FIRST_NAME, '')) || ' ' || UPPER (NVL(D.IC_CONTACT_LAST_NAME, 'Not Available')),
		UPPER (NVL(D.PROGRAM_MGR_FIRST_NAME, '')) || ' ' || UPPER (NVL(D.PROGRAM_MGR_LAST_NAME, 'Not Available')),
		NVL(O.IC, ''),
		NVL(O.ORG_INITS, ''),
		NVL(O.ADMIN_CODE, ''),
		NVL(C.POSITION_TITLE, '[Not Available]'),
		NVL(C.PAY_PLAN, '[Not Available]'),
		NVL(C.SERIES,  '[Not Available]'),
		NVL(C.GRADE, '[Not Available]'),
		NVL(B.ANN_NUMBER, '[Announcement Number Not Available]' )

		FROM 
		MAIN A /*(NOLOCK)*/
		INNER JOIN ORGS O /*(NOLOCK)*/ ON O.ADMIN_CODE = A.ADMIN_CODE
		LEFT JOIN NEW_POSITION C /*(NOLOCK)*/ ON C.TRANSACTION_ID = A.TRANSACTION_ID /*AND C.[TYPE] = 'Approved'*/
		LEFT JOIN IC_REQUEST_INFO D ON A.TRANSACTION_ID = D.TRANSACTION_ID
		LEFT JOIN CERTIFICATE B ON B.TRANSACTION_ID = A.TRANSACTION_ID 
		WHERE A.TRANSACTION_ID = I_WITS_ID;

BEGIN

    OPEN CUR_POSITIONS;  

    LOOP
      FETCH CUR_POSITIONS INTO
        V_WITSNUMBER ,
        V_ADMINOFFICERNAME ,
        V_SELECTINGOFFICIALNAME ,
        V_IC ,
        V_ORGINITS ,
        V_ADMINCODE ,
        V_POSITIONTITLE ,
        V_PAYPLAN ,
        V_SERIES ,
        V_GRADE ,
        V_ANNNUMBER;
      EXIT WHEN CUR_POSITIONS%NOTFOUND;

      V_ALL_POSITIONS := V_ALL_POSITIONS ||	
		'<html>  ' ||
		'<body>   ' ||
		'<table border="1" bordercolor="#BDBDBD" style="background-color:#FFFFFF" cellpadding="2" cellspacing="2"><font face=" Calibri" size="2">									' ||
		'<tr>    												'||
		'<td style="width: 170px">        						'||
		'<font face=" Calibri" size="2"><strong>Request #</strong></td>						'||
		'<td style="width: 200px;"><font face=" Calibri" size="2">' || V_WITSNUMBER || '</td>			'||
		'</tr>													'||
		'<tr>    												'||
		'<td style="width: 170px">        						'||
		'<font face=" Calibri" size="2"><strong>Vacancy Announcement #</strong></td>					'||
		'<td style="width: 200px;"><font face=" Calibri" size="2">'|| V_ANNNUMBER ||'</td>			'||
		'</tr>													'||
		'<tr>    												'||
		'<td style="width: 170px">        						'||
		'<font face=" Calibri" size="2"><strong>Submitted By/Org</strong></td>					'||
		'<td style="width: 200px;"><font face=" Calibri" size="2">'|| V_ADMINOFFICERNAME || ' /<!--<br> ' || V_IC || ' -->' || V_ORGINITS || '</td>			'||
		'</tr>													'||
		'<tr>    												'||
		'<td style="width: 170px">        						'||
		'<font face=" Calibri" size="2"><strong>Admin Code</strong></td>					'||
		'<td style="width: 200px;"><font face=" Calibri" size="2">'|| V_ADMINCODE ||'</td>	'||
		'</tr>													'||
		'<!--<tr>													'||
		'<td style="width: 170px">    							'||
		'<font face=" Calibri" size="2"><strong> Position Title</strong></td>							'||	
		'<td style="width: 200px"><font face=" Calibri" size="2">'|| V_POSITIONTITLE || '</td>			'||
		'</tr>													'||
		'<tr>													'||
		'<td style="width: 170px">    							'||
		'<font face=" Calibri" size="2"><strong>Pay Plan/Series/Grade(s)</strong></td>							'||	
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_PAYPLAN || '/' || V_SERIES || '/' || V_GRADE || '</td>			'||
		'</tr>-->													'||
		'</table>												'||	
		'<br>'   ||

		'</table></body></html>';



	END LOOP;  
	CLOSE CUR_POSITIONS;


  RETURN V_ALL_POSITIONS;
END FN_GET_RECRUITMENT_EMAIL_TB_AP;

/

--------------------------------------------------------
--  DDL for Function FN_GET_RECRUITMENT_SLA_POSI
--------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_GET_RECRUITMENT_SLA_POSI 
(I_WITS_ID IN VARCHAR2, 
 I_POS_TYPE IN VARCHAR2, 
 I_ANNCERTNUMS IN VARCHAR2)
RETURN VARCHAR2 AS

V_TABLETOP VARCHAR2(4000);
V_TABLEBOTTOM VARCHAR2(4000);
V_WITSNUMBER VARCHAR2 (10);
V_ORGINITS VARCHAR2 (50);
V_ADMINCODE VARCHAR2 (50);
V_POSITIONTITLE VARCHAR2 (100);
V_PAYPLAN VARCHAR2 (100);
V_SERIES VARCHAR2 (100);
V_GRADE VARCHAR2 (100);
V_POSITIONS VARCHAR2(100);
V_ALL_POSITIONS VARCHAR2(4000);
V_COUNT INT;
V_TYPE VARCHAR2(10);
V_CERTNUM VARCHAR2 (100);
V_DATETOSO VARCHAR2 (100);
V_TARGET DATE ;
V_DATEEXPIRES VARCHAR2(100);

CURSOR CUR_POSITIONS IS	 
    SELECT 
            A.TRANSACTION_ID,
            NVL(A.ORG_INITS, '')ORGINITS,
            NVL(A.ADMIN_CODE, '')ADMIN_CODE,
            NVL(C.POSITION_TITLE, '[Not Available]'),
            NVL(C.PAY_PLAN, '[Not Available]'),
            NVL(C.SERIES,  '[Not Available]'),
            NVL(C.GRADE, '[Not Available]'),
            NVL(CERT_NUMBER, '[Certificate Number not Available]') CERT_NUMBER,
            NVL(TO_CHAR(DATE_CERT_TO_SO,'MM/DD/YYYY'),'') DATETOSO,
            NVL(DATE_NEW_CERT_EXPIRES, DATE_CERT_EXPIRES),
            NVL(TO_CHAR(NVL(DATE_NEW_CERT_EXPIRES, DATE_CERT_EXPIRES),'MM/DD/YYYY'),'[Date Not Available]')
    FROM 
            MAIN A /*(NOLOCK)*/
            INNER JOIN NEW_POSITION C /*(NOLOCK)*/ ON A.TRANSACTION_ID = C.TRANSACTION_ID 
            INNER JOIN CERTIFICATE B ON A.TRANSACTION_ID = B.TRANSACTION_ID /*AND B.SEQUENCE = C.RELATED_ID AND C.TYPE = 'Cert'*/
    WHERE A.TRANSACTION_ID = I_WITS_ID
            --AND B.CERT_ISSUED IN ('Yes', 'Y')
            AND B.DATE_HIRING_DEC_RECD_IN_HR IS NULL
    ORDER BY DATE_CERT_TO_SO ASC;

BEGIN
    OPEN CUR_POSITIONS;  

    LOOP
      FETCH CUR_POSITIONS INTO
        V_WITSNUMBER,
        V_ORGINITS ,
        V_ADMINCODE ,
        V_POSITIONTITLE,
        V_PAYPLAN,
        V_SERIES,
        V_GRADE,
        V_CERTNUM,
        V_DATETOSO,
        V_TARGET ,
        V_DATEEXPIRES;      
      EXIT WHEN CUR_POSITIONS%NOTFOUND;
      
      V_ALL_POSITIONS := V_ALL_POSITIONS || 
		'<table border="1" bordercolor="#BDBDBD" style="background-color:#FFFFFF" cellpadding="2" cellspacing="2"><font face=" Calibri" size="2">									' ||
		'<tr>    												'||
		'<td style="width: 170px">        						'||
		'<font face=" Calibri" size="2"><strong>Request #</strong></td>						'||
		'<td style="width: 200px;"><font face=" Calibri" size="2">' || V_WITSNUMBER || '</td>			'||
		'</tr>													'||
		'<tr>    												'||
		'<td style="width: 170px">        						'||
		'<font face=" Calibri" size="2"><strong>Certificate#</strong></td>					'||
		'<td style="width: 200px;"><font face=" Calibri" size="2">' || V_CERTNUM || '</td>			'||
		'</tr>													'||
		'<tr>    												'||
		'<td style="width: 170px">        						'||
		'<font face=" Calibri" size="2"><strong>Cert Issue Date<!--Date Cert Sent --></strong></td>					'||
		'<td style="width: 200px;"><font face=" Calibri" size="2">' || V_DATETOSO || '</td>	        '||
		'</tr>													'||
		'<tr>    												'||
		'<td style="width: 170px">    							'||
		'<font face=" Calibri" size="2"><strong>Certificate Expiration Date</strong></td>							'||
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_DATEEXPIRES || '</td>			'||
		'</tr>													'||
		'<tr>													'||
		'<td style="width: 170px">    							'||
		'<font face=" Calibri" size="2"><strong>Organization<!--Org/SAC--></strong></td>							'||	
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_ORGINITS || '<!--, ' || V_ADMINCODE || '--></td>			'||
		'</tr>													'||
		'<!--<tr>													'||
		'<td style="width: 170px">    							'||
		'<font face=" Calibri" size="2"><strong> Position Title</strong></td>							'||	
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_POSITIONTITLE || '</td>			'||
		'</tr>													'||
		'<tr>													'||
		'<td style="width: 170px">    							'||
		'<font face=" Calibri" size="2"><strong> Pay Plan/Series/Grade</strong></td>							'||	
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_PAYPLAN || '/' || V_SERIES || '/' || V_GRADE || '</td>			'||
		'</tr>-->													'||
		'</table>												'||	
		'<br>													';

    END LOOP;  
	CLOSE CUR_POSITIONS;
  RETURN V_ALL_POSITIONS;
END FN_GET_RECRUITMENT_SLA_POSI;

/

--------------------------------------------------------
--  DDL for Procedure SP_SEND_MAIL
--------------------------------------------------------

SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE SP_SEND_MAIL (I_TO        IN VARCHAR2,
                                       I_CC        IN VARCHAR2 DEFAULT NULL,
                                       I_BCC       IN VARCHAR2 DEFAULT NULL,
                                       I_FROM      IN VARCHAR2,
                                       I_SUBJECT   IN VARCHAR2,
                                       I_TEXT_MSG  IN VARCHAR2 DEFAULT NULL,
                                       I_HTML_MSG  IN VARCHAR2 DEFAULT NULL)
AS
  V_MAIL_CONN   UTL_SMTP.CONNECTION;
  V_SMTP_HOST VARCHAR2(50) := 'localhost';
  V_SMTP_PORT NUMBER := 25;
  V_BOUNDARY    VARCHAR2(50) := '----=*#abc1234321cba#*=';
  V_PARTIES VARCHAR2(2000);
  
--    PROCEDURE PROCESS_RECIPIENTS(I_MAIL_CONN IN OUT UTL_SMTP.CONNECTION,
--                               I_LIST      IN     VARCHAR2)
--  AS
--    V_TAB STRING_API.T_SPLIT_ARRAY;
--  BEGIN
--    IF TRIM(I_LIST) IS NOT NULL THEN
--      V_TAB := STRING_API.SPLIT_TEXT(I_LIST);
--      FOR I IN 1 .. V_TAB.COUNT LOOP
--        UTL_SMTP.RCPT(V_MAIL_CONN, TRIM(V_TAB(I)));
--      END LOOP;
--    END IF;
--  END;
  
BEGIN
FOR I IN (SELECT LEVEL AS ID, REGEXP_SUBSTR(I_TO || ';' || I_CC || ';' || I_BCC, '[^;]+', 1, LEVEL) AS TO_EMAIL_NAME
  FROM DUAL
  CONNECT BY REGEXP_SUBSTR(I_TO || ';' || I_CC || ';' || I_BCC, '[^;]+', 1, LEVEL) IS NOT NULL) LOOP
  
  V_MAIL_CONN := UTL_SMTP.OPEN_CONNECTION(V_SMTP_HOST, V_SMTP_PORT);
  UTL_SMTP.HELO(V_MAIL_CONN, V_SMTP_HOST);
  UTL_SMTP.MAIL(V_MAIL_CONN, I_FROM);
  UTL_SMTP.RCPT(V_MAIL_CONN, I.TO_EMAIL_NAME);
  /* IF TRIM(I_CC) IS NOT NULL THEN 
      
   FOR I IN (SELECT LEVEL AS ID, REGEXP_SUBSTR(I_CC, '[^;]+', 1, LEVEL) AS CC_EMAIL_NAME
               FROM DUAL
               CONNECT BY REGEXP_SUBSTR(I_CC, '[^;]+', 1, LEVEL) IS NOT NULL) LOOP
        V_PARTIES := V_PARTIES||';'|| I.CC_EMAIL_NAME;
      UTL_SMTP.RCPT(V_MAIL_CONN,I.CC_EMAIL_NAME);
    END LOOP;  
 
  
  UTL_SMTP.RCPT(V_MAIL_CONN, I_CC);
  END IF;
  IF TRIM(I_BCC) IS NOT NULL THEN
  UTL_SMTP.RCPT(V_MAIL_CONN, I_BCC);
  END IF;*/ 
--    PROCESS_RECIPIENTS(V_MAIL_CONN, I_TO);
--  PROCESS_RECIPIENTS(V_MAIL_CONN, I_CC);
--  PROCESS_RECIPIENTS(V_MAIL_CONN, I_BCC);

  UTL_SMTP.OPEN_DATA(V_MAIL_CONN);
  
  UTL_SMTP.WRITE_DATA(V_MAIL_CONN, 'Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.CRLF);
  UTL_SMTP.WRITE_DATA(V_MAIL_CONN, 'To: ' || I_TO || UTL_TCP.CRLF);
  IF TRIM(I_CC) IS NOT NULL THEN
    UTL_SMTP.WRITE_DATA(V_MAIL_CONN, 'CC: ' || REPLACE(I_CC, ',', ';') || UTL_TCP.CRLF);
    --UTL_SMTP.WRITE_DATA(V_MAIL_CONN, 'CC: ' || V_PARTIES || UTL_TCP.CRLF);
  END IF;
  IF TRIM(I_BCC) IS NOT NULL THEN
    UTL_SMTP.WRITE_DATA(V_MAIL_CONN, 'BCC: ' || REPLACE(I_BCC, ',', ';') || UTL_TCP.CRLF);
  END IF;
  UTL_SMTP.WRITE_DATA(V_MAIL_CONN, 'From: ' || I_FROM || UTL_TCP.CRLF);
  UTL_SMTP.WRITE_DATA(V_MAIL_CONN, 'Subject: ' || I_SUBJECT || UTL_TCP.CRLF);
  UTL_SMTP.WRITE_DATA(V_MAIL_CONN, 'MIME-Version: 1.0' || UTL_TCP.CRLF);
  UTL_SMTP.WRITE_DATA(V_MAIL_CONN, 'Content-Type: multipart/alternative; boundary="' || V_BOUNDARY || '"' || UTL_TCP.CRLF || UTL_TCP.CRLF);
  
  IF I_TEXT_MSG IS NOT NULL THEN
    UTL_SMTP.WRITE_DATA(V_MAIL_CONN, '--' || V_BOUNDARY || UTL_TCP.CRLF);
    UTL_SMTP.WRITE_DATA(V_MAIL_CONN, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.CRLF || UTL_TCP.CRLF);

    UTL_SMTP.WRITE_DATA(V_MAIL_CONN, I_TEXT_MSG);
    UTL_SMTP.WRITE_DATA(V_MAIL_CONN, UTL_TCP.CRLF || UTL_TCP.CRLF);
  END IF;

  IF I_HTML_MSG IS NOT NULL THEN
    UTL_SMTP.WRITE_DATA(V_MAIL_CONN, '--' || V_BOUNDARY || UTL_TCP.CRLF);
    UTL_SMTP.WRITE_DATA(V_MAIL_CONN, 'Content-Type: text/html; charset="iso-8859-1"' || UTL_TCP.CRLF || UTL_TCP.CRLF);

    UTL_SMTP.WRITE_DATA(V_MAIL_CONN, I_HTML_MSG);
    UTL_SMTP.WRITE_DATA(V_MAIL_CONN, UTL_TCP.CRLF || UTL_TCP.CRLF);
  END IF;

  UTL_SMTP.WRITE_DATA(V_MAIL_CONN, '--' || V_BOUNDARY || '--' || UTL_TCP.CRLF);
  UTL_SMTP.CLOSE_DATA(V_MAIL_CONN);

  UTL_SMTP.QUIT(V_MAIL_CONN);
END LOOP;  
END;
/

--------------------------------------------------------
--  DDL for Procedure SP_JOB_RECRUITMENT_PRE_VALID
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_JOB_RECRUITMENT_PRE_VALID AS

V_SENDER VARCHAR2(100);
V_TORECIPIENTS VARCHAR2(500);
V_CCRECIPIENTS VARCHAR2(500);
V_BCRECIPIENTS VARCHAR2(500);
V_SUBJECT VARCHAR2(2000);
V_CONTENTTOP VARCHAR2(8000);
V_CONTENTBOTTOM VARCHAR2(8000);
V_BODY CLOB;
V_WITSNUMBER VARCHAR2(10);
V_HRSNAME VARCHAR2(100);
V_HRSEMAIL VARCHAR2(100);
V_TEAMLEADEMAIL VARCHAR2(100);
V_BRANCHCHIEFEMAIL VARCHAR2(100);
V_ADMINOFFICERNAME VARCHAR2(100);
V_ADMINOFFICEREMAIL VARCHAR2(100);
V_LIAISONEMAIL VARCHAR2(100);
V_IC VARCHAR2(10);
V_ORGINITS VARCHAR2(50);
V_ADMINCODE VARCHAR2(50);
V_TABLE VARCHAR2(8000);
V_COUNT INT;
V_DAYS VARCHAR2(50);
V_GRU VARCHAR2(10);
V_BRANCH VARCHAR2(50);
V_CSDDEMAIL VARCHAR2(100);
V_RYBSTATUS VARCHAR2(500);
V_COMMENTS VARCHAR2(8000);
V_INITIATED VARCHAR2(50);
V_PRERECRUITMTG VARCHAR2(100);
V_PRERECRUITFORM VARCHAR2(100);
V_POSTITLE VARCHAR2(100);
V_PAYPLAN VARCHAR2(100);
V_SERIES VARCHAR2(100);
V_GRADE VARCHAR2(100);
V_REMINDERS VARCHAR2(1000);

--BEGIN
--

CURSOR CUR_RECIPIENTS IS	 
---------Query----------------
	SELECT DISTINCT
		A.TRANSACTION_ID,
		--NVL(H.SHORTNAME,'') + ' '  + dbo.fn_GET_NAME_FROM_MEMBERTBL (h.name)HRSName, 
		NVL(H.NAME,'') HRSNAME,
		NVL((SELECT NVL(EMAIL, '') EMAIL  FROM BIZFLOW.MEMBER WHERE MEMBERID = HR_SPECIALIST_ID),'unassigned@mail.nih.gov') HRSEMAIL,
		NVL((SELECT NVL(EMAIL, '') EMAIL  FROM BIZFLOW.MEMBER WHERE MEMBERID = TEAM_LEADER_ID),'unassignedTL@mail.nih.gov') TEAMLEADEREMAIL,
		NVL((SELECT NVL(EMAIL, '') EMAIL  FROM BIZFLOW.MEMBER WHERE MEMBERID = BRANCH_CHIEF_ID),'unassignedBC@mail.nih.gov') BRANCHCHIEFEMAIL,
		NVL(D.IC_CONTACT_FIRST_NAME, '') || ' ' || NVL(IC_CONTACT_LAST_NAME, '[Unknown AO]') ADMINOFFICERNAME,
		--NVL(D.IC_CONTACT_EMAIL, 'unassignedAO@mail.nih.gov') AdminOfficeremail,
		NVL((SELECT NVL(EMAIL, '') EMAIL  FROM BIZFLOW.MEMBER WHERE MEMBERID = 
				(SELECT MAX(X.HR_SENIOR_ADVISOR_ID)
				 FROM TBL_FORM_DTL FD  
					, XMLTABLE('/DOCUMENT'
					PASSING FD.FIELD_DATA
						COLUMNS
							TRANSACTION_ID			NUMBER(10)  PATH 'MAIN/TRANSACTION_ID',
                            HR_SENIOR_ADVISOR_ID	VARCHAR2(10) PATH 'TRANSACTION/HR_SENIOR_ADVISOR_ID' ) X
				 WHERE X.TRANSACTION_ID = A.TRANSACTION_ID)),'unassignedAO@mail.nih.gov') ADMINOFFICEREMAIL,
		NVL(D.FTE_LIAISON_EMAIL, 'unassigned@mail.nih.gov') LIAISONEMAIL,
		NVL(O.IC, '') IC,
		NVL(O.ORG_INITS, '') ORGINITS,
		NVL(O.ADMIN_CODE, '') ADMINCODE,
		FN_GET_RECRUITMENT_PRE_VAL(A.TRANSACTION_ID, 'New'),
		NVL(TRUNC((SYSDATE - TO_DATE(A.DATE_RECEIVED,'DD-MON-YY'))),0) INTCOUNT,
		TO_CHAR(NVL(TRUNC((SYSDATE - TO_DATE(A.DATE_RECEIVED,'DD-MON-YY'))),0)) STRDAYS,
		NVL(GLOBAL_RECRUITMENT, 'No') GRU,

		CASE	
			WHEN A.STATUS_DATE < '27-APR-11'/*'4/27/2011'*/ AND A.STATUS NOT IN ('CANCELLED', 'COMPLETED') AND NVL(A.GLOBAL_RECRUITMENT, 'No') IN ('Yes') THEN 'GRU'
			WHEN A.STATUS_DATE >= '27-APR-11'/*'4/27/2011'*/ AND A.STATUS <> 'CANCELLED' AND NVL(A.GLOBAL_RECRUITMENT, 'No') IN ('Yes') THEN 'GRU' 
			ELSE FN_GET_BRANCH_FOR_AN_IC(O.IC, A.STATUS_DATE, A.STATUS)
		END AS BRANCH,
	  
		NVL(FN_GET_DEPUTY_FOR_AN_IC(O.IC,NVL(GLOBAL_RECRUITMENT, 'No')), 'UNKNOWN') as CSD_DEPUTY_EMAIL,
		NVL(A.RYB_STATUS, '') || ' /<br> ' || NVL(A.RYB_DESCRIPTION, '') RYBSTATUS,
		NVL(DBMS_LOB.SUBSTR(A.INTERNAL_COMMENTS, 5000, 1),'No Comments') AS COMMENTS,
		TO_CHAR(A.DATE_RECEIVED,'MM/DD/YYYY') INITIATED,

		CASE 
			WHEN C.DATE_PRERECRUIT_MEETING IS NOT NULL THEN TO_CHAR(C.DATE_PRERECRUIT_MEETING,'MM/DD/YYYY')
			ELSE 'Not Held' 
	
		END AS PRERECRUITMTG,
	
		CASE 
			WHEN C.DATE_PRERECRUIT_SHEET_SIGNED IS NOT NULL THEN TO_CHAR(C.DATE_PRERECRUIT_SHEET_SIGNED,'MM/DD/YYYY')
	
			ELSE 'Not Signed' 
	
		END AS PRERECRUITFORM,
	
	
/* Top 1 for position info is needed for subject line when there is more than 1 position block on the prerecruitment tab
Hanlding of NULLs is required as the position information is not required based on the conditions of this email.
The user is not required to enter any position information for this email to trigger. 
*/

		CASE 
			WHEN NP.POSITION_TITLE IS NULL THEN '--'
		ELSE 
			(SELECT MAX(C.POSITION_TITLE)
			 FROM NEW_POSITION C 
			 INNER JOIN MAIN Q
			 ON C.TRANSACTION_ID = Q.TRANSACTION_ID AND (C.TYPE) = 'New' 
			 WHERE C.TRANSACTION_ID = A.TRANSACTION_ID ) 
		END AS POSITION_TITLE, 

		CASE 
			WHEN NP.PAY_PLAN IS NULL THEN '--' 
		ELSE
			(SELECT MAX(C.PAY_PLAN)
			 FROM NEW_POSITION C 
			 INNER JOIN MAIN Q
			 ON C.TRANSACTION_ID = Q.TRANSACTION_ID AND (C.TYPE) = 'New'  
			 WHERE C.TRANSACTION_ID = A.TRANSACTION_ID ) 
		END AS PAY_PLAN, 

		CASE 
			WHEN NP.SERIES IS NULL THEN '--'
		ELSE 
			(SELECT MAX(C.SERIES)
			 FROM NEW_POSITION C 
			 INNER JOIN MAIN Q
			 ON C.TRANSACTION_ID = Q.TRANSACTION_ID AND (C.TYPE) = 'New' 
			 WHERE C.TRANSACTION_ID = A.TRANSACTION_ID ) 
		END AS SERIES, 
		
		CASE 
			WHEN NP.GRADE IS NULL THEN '--' 
		ELSE 
			(SELECT MAX(P.GRADE)
			 FROM NEW_POSITION P 
			 INNER JOIN MAIN Q
			 ON P.TRANSACTION_ID = Q.TRANSACTION_ID AND (P.TYPE) = 'New' 
			 WHERE P.TRANSACTION_ID = A.TRANSACTION_ID ) 
		END AS GRADE,

		'<font face=" Calibri" size="3"><strong>Scheduled Reminders: <br></strong> ' 
		||'<li>45 Days: '|| NVL(TO_CHAR(TO_DATE(A.DATE_RECEIVED,'DD-MON-YY') + 45,'MM/DD/YYYY'), '')||'</li><br> '
		||'<li>60 Days: '|| NVL(TO_CHAR(TO_DATE(A.DATE_RECEIVED,'DD-MON-YY') + 60,'MM/DD/YYYY'), '')||'</li><br> ' 
		||'<li>75 Days: '|| NVL(TO_CHAR(TO_DATE(A.DATE_RECEIVED,'DD-MON-YY') + 75,'MM/DD/YYYY'), '')||'</li><br> ' 
		||'<li>90 Days: '|| NVL(TO_CHAR(TO_DATE(A.DATE_RECEIVED,'DD-MON-YY') + 90,'MM/DD/YYYY'), '')||'</li>' AS REMINDERS

	FROM MAIN A
	INNER JOIN BIZFLOW.MEMBER H ON H.MEMBERID = HR_SPECIALIST_ID
	LEFT JOIN RECRUITMENT C
	ON A.TRANSACTION_ID = C.TRANSACTION_ID
	LEFT JOIN IC_REQUEST_INFO D
	ON A.TRANSACTION_ID = D.TRANSACTION_ID
	INNER JOIN ORGS O /*(NOLOCK)*/ ON O.ADMIN_CODE = A.ADMIN_CODE
	LEFT JOIN NEW_POSITION NP ON NP.TRANSACTION_ID = A.TRANSACTION_ID AND NP.TYPE = 'New' 

	WHERE
		A.MISSING_DOCS_RECEIPT_DATE IS NULL
	AND 
		A.ACTION_TYPE = 'Recruitment'
	AND A.STATUS = 'ACTIVE'
	--AND DATEDIFF(DAY,A.DATE_RECEIVED,GETDATE()) IN (45, 60, 75, 90)
	AND NVL(TRUNC((SYSDATE - TO_DATE(A.DATE_RECEIVED,'DD-MON-YY'))),0) IN (45, 60, 75, 90)

	AND A.INSTITUTE <> 'TEST'

	AND A.DATE_RECEIVED >= '01-OCT-11' --'10/01/2011'

	AND RYB_STATUS <> 'Hold - Future/Projected Action' 
  
	AND RYB_DESCRIPTION NOT IN ('Applicants Under Review - Program SME','Applicants Under Review - QRB',
							'Cert issued to selecting official','Hold - Shared Certificate/Recruitment in Progress')

-----------------------------------------------------------------------------------------------------------------------

	AND (RECRUITMENT_TYPE = 'Title 5'
	OR  --- prevents users from leaving this field blank and not sending the email---
	RECRUITMENT_TYPE IS NULL ) ;
----------Query End----------------

BEGIN
    OPEN CUR_RECIPIENTS;  
    FETCH CUR_RECIPIENTS INTO
        V_WITSNUMBER ,
        V_HRSNAME ,
        V_HRSEMAIL ,
        V_TEAMLEADEMAIL ,
        V_BRANCHCHIEFEMAIL ,
        V_ADMINOFFICERNAME ,
        V_ADMINOFFICEREMAIL ,
        V_LIAISONEMAIL,
        V_IC ,
        V_ORGINITS,
        V_ADMINCODE ,
        V_TABLE ,
        V_COUNT ,
        V_DAYS ,
        V_GRU ,
        V_BRANCH ,
        V_CSDDEMAIL ,
        V_RYBSTATUS ,
        V_COMMENTS ,
        V_INITIATED ,
        V_PRERECRUITMTG ,
        V_PRERECRUITFORM ,
        V_POSTITLE ,
        V_PAYPLAN ,
        V_SERIES ,
        V_GRADE,
        V_REMINDERS; 
    LOOP
      
		IF V_COUNT = 45  THEN
							
				V_DAYS := '45';
				
				V_TORECIPIENTS := V_TEAMLEADEMAIL;
				V_CCRECIPIENTS := V_HRSEMAIL || ';' || V_ADMINOFFICEREMAIL || ';' || V_LIAISONEMAIL;
	


		ELSIF V_COUNT = 60   THEN
				
				V_DAYS := '60';
				
				V_TORECIPIENTS := V_BRANCHCHIEFEMAIL; 
				V_CCRECIPIENTS := V_TEAMLEADEMAIL || ';' || V_HRSEMAIL || ';' || V_ADMINOFFICEREMAIL || ';' || V_LIAISONEMAIL;
			
				
		ELSIF V_COUNT = 75   THEN
				
				V_DAYS := '75';
				
				V_TORECIPIENTS := V_CSDDEMAIL; 
				V_CCRECIPIENTS := V_BRANCHCHIEFEMAIL  || ';' || V_TEAMLEADEMAIL || ';' || V_HRSEMAIL || ';' || V_ADMINOFFICEREMAIL || ';' || V_LIAISONEMAIL;
			
				
				
		ELSIF V_COUNT = 90   THEN
			
				V_DAYS := '90';
				
				V_TORECIPIENTS := 'martijo@od.nih.gov';
				V_CCRECIPIENTS := V_BRANCHCHIEFEMAIL  || ';' || V_TEAMLEADEMAIL || ';' || V_HRSEMAIL || ';' || V_CSDDEMAIL || ';' || V_ADMINOFFICEREMAIL;	
		
		ELSE
				
				V_DAYS := 'Unknown';
				V_SUBJECT := 'Reminder: Active Recruitment Action (UNKNOWN) Recruitment #' || V_WITSNUMBER || ' - Action Needed';
				V_TORECIPIENTS := 'witsinten@od.nih.gov';
				V_CCRECIPIENTS := 'witsinten@od.nih.gov';
		END IF;

		V_CONTENTTOP := 

		'<html>
			<head>
				<title>Pre-Recruitment Email Alert</title>
			</head>
			<body>

		<font face=" Calibri" size="3"><strong>Suggested Action:</strong> Please contact ' || V_HRSNAME || ' for more information and to move the recruitment process forward. Do not respond to this email address.<br><br>' ||
								
		'<font face=" Calibri" size="3"><strong>Details:</strong> Recruitment Action ' || V_WITSNUMBER || ' has been active for ' || V_DAYS || ' days in the pre-recruitment stage. Please reference the table(s), comments, and pre-recruitment status below for specific information related to this recruitment action.<br><br>
							
			</body>
		</html>';

		V_CONTENTBOTTOM := '<font face=" Calibri" size="3">
		<strong>Date of Pre-Recruitment Meeting:</strong> ' || V_PRERECRUITMTG || '<br>'
		|| '<strong>Date of Pre-Recruitment Form Signed:</strong> ' || V_PRERECRUITFORM || ' <br>'
		|| '<strong> Comments: </strong><br>' || V_COMMENTS || '<br><br>'
		|| V_REMINDERS || '<br><br>'
		|| '<font face=" Calibri" size="3"><!--<p align="left">Please refer to the <a href="http://intrahr.od.nih.gov/hrsystems/staffing/wits/documents/CSD_Reminder_Emails.pdf">CSD Reminder Email Guide</a> for more details about reminder emails.</p>-->';

		V_SENDER := 'donotreply@hhs.gov' /*'WiTS/HRC@mail.nih.gov'*/;
		V_BODY := V_CONTENTTOP || V_TABLE || V_CONTENTBOTTOM;
		V_SUBJECT := 'Action Needed - Move Recruitment Action Forward - ' || V_POSTITLE || ' ' || V_PAYPLAN || '-' || V_SERIES || '-' || V_GRADE;
		V_BCRECIPIENTS := 'witsinten@od.nih.gov';

------------------------------------
-------EMAILSEND---------------
		SP_SEND_MAIL(V_TORECIPIENTS,V_CCRECIPIENTS,'',V_SENDER,V_SUBJECT,'',V_BODY);
------------------------------------


		INSERT INTO AUTO_EMAIL_LOG(EMAIL_SENT_DATE, FROM_EMAIL_ADDRESS,TO_EMAIL_ADDRESS,SUBJECT,BODY,OFFICE, SLA, TRANSACTION_ID, ANN_NUMBER)     
		VALUES
		(SYSDATE, V_SENDER, V_TORECIPIENTS || ';' || V_CCRECIPIENTS, V_SUBJECT, 'From: ' || V_SENDER || '<br>To: ' || V_TORECIPIENTS || '<br>CC: ' || V_CCRECIPIENTS || '<br><br>Subject: ' ||  V_SUBJECT || '<br><br>' || V_BODY,'Rec5','SLA - Pre Validate' || V_DAYS || '', V_WITSNUMBER,'');
--OD SQL USER (NIH/OD)

    FETCH CUR_RECIPIENTS INTO 
        V_WITSNUMBER ,
        V_HRSNAME ,
        V_HRSEMAIL ,
        V_TEAMLEADEMAIL ,
        V_BRANCHCHIEFEMAIL ,
        V_ADMINOFFICERNAME ,
        V_ADMINOFFICEREMAIL ,
        V_LIAISONEMAIL,
        V_IC ,
        V_ORGINITS,
        V_ADMINCODE ,
        V_TABLE ,
        V_COUNT ,
        V_DAYS ,
        V_GRU ,
        V_BRANCH ,
        V_CSDDEMAIL ,
        V_RYBSTATUS ,
        V_COMMENTS ,
        V_INITIATED ,
        V_PRERECRUITMTG ,
        V_PRERECRUITFORM ,
        V_POSTITLE ,
        V_PAYPLAN ,
        V_SERIES ,
        V_GRADE,
        V_REMINDERS; 
    EXIT WHEN CUR_RECIPIENTS%NOTFOUND;

    END LOOP;
	CLOSE CUR_RECIPIENTS;
  NULL;
EXCEPTION
	WHEN OTHERS THEN
		SP_ERROR_LOG();
END SP_JOB_RECRUITMENT_PRE_VALID;
/

--------------------------------------------------------
--  DDL for Procedure SP_JOB_RECRUITMENT_SLA_POST
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_JOB_RECRUITMENT_SLA_POST AS 

V_SENDER VARCHAR2(100);
V_TORECIPIENTS VARCHAR2(500);
V_CCRECIPIENTS VARCHAR2(500);
V_BCRECIPIENTS VARCHAR2(500);
V_SUBJECT VARCHAR2(500);
V_CONTENTTOP VARCHAR2(1000);
V_CONTENTBOTTOM VARCHAR2(1000);
V_TABLE VARCHAR2(8000);
V_BODY VARCHAR2(8000);
V_WITSNUMBER VARCHAR2(10);
V_HRSEMAIL VARCHAR2(100);
V_TEAMLEADEMAIL VARCHAR2(100);
V_BRANCHCHIEFEMAIL VARCHAR2(100);
V_SRHRADVISOR VARCHAR2(100);
V_ADMINOFFICERNAME VARCHAR2(100);
V_IC VARCHAR2(10);
V_ORGINITS VARCHAR2(50);
V_ADMINCODE VARCHAR2(50);
V_DAYS VARCHAR2(50);
V_VACANCIES VARCHAR2(500);
V_POSTITLE VARCHAR2(100);
V_PAYPLAN VARCHAR2(100);
V_SERIES VARCHAR2(100);
V_GRADE VARCHAR2(100);


--v_Days := ' (2 Days Notice) ';

CURSOR CUR_RECIPIENTS IS	 
---------QUERY----------------
	SELECT DISTINCT
		A.TRANSACTION_ID,
		(SELECT NVL(EMAIL, '') EMAIL  FROM BIZFLOW.MEMBER WHERE MEMBERID = HR_SPECIALIST_ID),
		(SELECT NVL(EMAIL, '') EMAIL  FROM BIZFLOW.MEMBER WHERE MEMBERID = TEAM_LEADER_ID),
		(SELECT NVL(EMAIL, '') EMAIL  FROM BIZFLOW.MEMBER WHERE MEMBERID = BRANCH_CHIEF_ID),
		(SELECT NVL(EMAIL, '') EMAIL  FROM BIZFLOW.MEMBER WHERE MEMBERID = HR_SENIOR_ADVISOR_ID),
		NVL(D.IC_CONTACT_FIRST_NAME, '') || ' ' || NVL(IC_CONTACT_LAST_NAME, ''),
		NVL(A.INSTITUTE, ''),
		NVL(A.ORG_INITS, ''),
		NVL(A.ADMIN_CODE, ''),
		FN_GET_RECRUITMENT_EMAIL_TBL(A.TRANSACTION_ID, 'New',''),
		FN_GET_RECRUITMENT_SLA_VACAN(A.TRANSACTION_ID),

/* Top 1 for position info is needed for subject line when there is more than 1 position block on the prerecruitment tab
Hanlding of NULLs is required as the position information is not required based on the conditions of this email.
The user is not required to enter any position information for this email to trigger. */

	
		CASE 
			WHEN NP.POSITION_TITLE IS NULL THEN '--'
			ELSE 
				(SELECT MAX(C.POSITION_TITLE)
				FROM NEW_POSITION C 
				INNER JOIN MAIN Q
				ON C.TRANSACTION_ID = Q.TRANSACTION_ID /*AND (C.TYPE) = 'New'*/ 
				WHERE C.TRANSACTION_ID = A.TRANSACTION_ID ) 
		END AS POSITION_TITLE, 

		CASE 
			WHEN NP.PAY_PLAN IS NULL THEN '--' 
			ELSE
				(SELECT MAX(C.PAY_PLAN)
				FROM NEW_POSITION C 
				INNER JOIN MAIN Q
				ON C.TRANSACTION_ID = Q.TRANSACTION_ID /* AND (C.TYPE) = 'New' */ 
				WHERE C.TRANSACTION_ID = A.TRANSACTION_ID ) 
		END AS PAY_PLAN, 


		CASE 
			WHEN NP.SERIES IS NULL THEN '--'
			ELSE 
				(SELECT MAX(C.SERIES)
				FROM NEW_POSITION C 
				INNER JOIN MAIN Q
				ON C.TRANSACTION_ID = Q.TRANSACTION_ID/* AND (C.TYPE) = 'New'*/ 
				WHERE C.TRANSACTION_ID = A.TRANSACTION_ID ) 
		END AS SERIES, 
				
		CASE 
			WHEN NP.GRADE IS NULL THEN '--' 
			ELSE 
				(SELECT MAX(C.GRADE)
				FROM NEW_POSITION C 
				INNER JOIN MAIN Q
				ON C.TRANSACTION_ID = Q.TRANSACTION_ID/* AND (C.TYPE) = 'New' */
				WHERE C.TRANSACTION_ID = A.TRANSACTION_ID ) 
		END AS GRADE 

	FROM MAIN A
	LEFT JOIN ANNOUNCEMENT B
	ON A.TRANSACTION_ID = B.TRANSACTION_ID
	LEFT JOIN RECRUITMENT C
	ON A.TRANSACTION_ID = C.TRANSACTION_ID
	LEFT JOIN IC_REQUEST_INFO D
	ON A.TRANSACTION_ID = D.TRANSACTION_ID
	LEFT JOIN NEW_POSITION NP ON NP.TRANSACTION_ID = A.TRANSACTION_ID AND NP.TYPE = 'New' 

	WHERE DATE_ANN_POSTED IS NULL 
	AND A.MISSING_DOCS_RECEIPT_DATE IS NOT NULL
	AND A.ACTION_TYPE = 'Recruitment'
	AND A.STATUS NOT IN ('COMPLETED', 'CANCELLED')
	AND NVL(TRUNC((SYSDATE - TO_DATE(A.MISSING_DOCS_RECEIPT_DATE,'DD-MON-YY'))),0) IN (2)
	/*AND A.TRANSACTION_ID NOT IN
	(
	SELECT Z1.TRANSACTION_ID 
	FROM 
	ANNOUNCEMENT Z1
	WHERE
	Z1.DATE_ANN_POSTED IS NOT NULL
	AND
	TRANSACTION_ID = A.TRANSACTION_ID
	)*/
	AND A.INSTITUTE <> 'TEST';
----------Query End----------------

BEGIN
    OPEN CUR_RECIPIENTS;  
    FETCH CUR_RECIPIENTS INTO
        V_WITSNUMBER,
        V_HRSEMAIL,
        V_TEAMLEADEMAIL,
        V_BRANCHCHIEFEMAIL,
        V_SRHRADVISOR,
        V_ADMINOFFICERNAME,
        V_IC,
        V_ORGINITS,
        V_ADMINCODE,
        V_TABLE,
        V_VACANCIES,
        V_POSTITLE ,
        V_PAYPLAN ,
        V_SERIES ,
        V_GRADE;
    LOOP
    
    V_TORECIPIENTS := V_HRSEMAIL; 
    V_CCRECIPIENTS := V_TEAMLEADEMAIL || ';' || V_BRANCHCHIEFEMAIL || ';' || V_SRHRADVISOR; 
    V_SUBJECT := 'REQUEST #' || V_WITSNUMBER || ' - ACTION NEEDED: RELEASE VACANCY ANNOUNCEMENT.'/* || V_POSTITLE || ' ' || V_PAYPLAN || '-' || V_SERIES || '-' || V_GRADE*/;


    V_CONTENTTOP := '<html>
	<head>
		<title>WiTS Post Vacancy Email Alert</title>
	</head>
	<body>

	<font face=" Calibri" size="3"><strong>Suggested Action:</strong> Please post (i.e., release) the announcement in USA Staffing. Do not respond to this email.<br><br>' || 
	'<font face=" Calibri" size="3"><strong>Details:</strong> Action is needed on Request # '|| V_WITSNUMBER || ' in order to meet the OPM Hiring Reform Goals. The vacancy announcement(s) listed below should be released by close of business today. Please reference the table below for specific information related to this action.<br><br>';


--v_ContentBottom := '<br><font face=" Calibri" size="3"><p align="left">Please refer to the <a href="http://intrahr.od.nih.gov/hrsystems/staffing/wits/documents/CSD_Reminder_Emails.pdf">CSD Reminder Email Guide</a> for more details about reminder emails.</p>'		;

	V_CONTENTBOTTOM := '<br><font face=" Calibri" size="3"><p align="left">Do not respond to this email.</p>';
	V_BODY := V_CONTENTTOP || V_TABLE || V_CONTENTBOTTOM;
	V_DAYS := ' (2-day notice) ';

	V_BCRECIPIENTS := 'witsinten@od.nih.gov';
	V_SUBJECT := V_SUBJECT;
	V_SENDER := 'donotreply@hhs.gov'/*'WiTS/HRC@mail.nih.gov'*/;

--SP_SEND_MAIL('dkwak@deloitte.com','dkwak@bizflow.com','',v_Sender,v_Subject,'',v_Body);
	SP_SEND_MAIL(V_TORECIPIENTS,V_CCRECIPIENTS,V_BCRECIPIENTS,V_SENDER,V_SUBJECT,'',V_BODY);

	INSERT INTO AUTO_EMAIL_LOG(EMAIL_SENT_DATE, FROM_EMAIL_ADDRESS,TO_EMAIL_ADDRESS,SUBJECT,BODY,OFFICE, SLA, TRANSACTION_ID, ANN_NUMBER)     
	VALUES
	(SYSDATE, V_SENDER, V_TORECIPIENTS || ';' || V_CCRECIPIENTS, V_SUBJECT, 'From: ' || V_SENDER || '<br>To: ' || V_TORECIPIENTS || '<br>CC: ' || V_CCRECIPIENTS || '<br><br>Subject: ' ||  V_SUBJECT || '<br><br>' || V_BODY,'Rec1','SLA - Post Announcement' || V_DAYS || '', V_WITSNUMBER,V_VACANCIES);

    
    FETCH CUR_RECIPIENTS INTO 
    
        V_WITSNUMBER,
        V_HRSEMAIL,
        V_TEAMLEADEMAIL,
        V_BRANCHCHIEFEMAIL,
        V_SRHRADVISOR,
        V_ADMINOFFICERNAME,
        V_IC,
        V_ORGINITS,
        V_ADMINCODE,
        V_TABLE,
        V_VACANCIES,
        V_POSTITLE ,
        V_PAYPLAN ,
        V_SERIES ,
        V_GRADE;
    
    
    EXIT WHEN CUR_RECIPIENTS%NOTFOUND;

    END LOOP;
    CLOSE CUR_RECIPIENTS;
  NULL;
EXCEPTION
	WHEN OTHERS THEN
		SP_ERROR_LOG();
END SP_JOB_RECRUITMENT_SLA_POST;
/

--------------------------------------------------------
--  DDL for Procedure SP_JOB_RECRUITMENT_SLA_CERT_EX
--------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_JOB_RECRUITMENT_SLA_CERT_EX AS 

V_SENDER VARCHAR2(100);
V_TORECIPIENTS VARCHAR2 (500);
V_CCRECIPIENTS VARCHAR2 (500);
V_BCRECIPIENTS VARCHAR2 (500);
V_SUBJECT VARCHAR2 (500);
V_CONTENTTOP VARCHAR2(4000);
V_CONTENTBOTTOM VARCHAR2(4000);
V_TABLE CLOB;
V_BODY VARCHAR2(4000);
V_DAYS VARCHAR2 (50);
V_WITSNUMBER VARCHAR2 (10);
V_HRSNAME VARCHAR2 (400);
V_HRSEMAIL VARCHAR2 (200);
V_SOEMAIL VARCHAR2 (200);
V_AOEMAIL VARCHAR2 (200);
V_COUNT INT;
V_CERTNUM VARCHAR2 (200);
V_ANNTYPE VARCHAR2 (20);
V_ANNNUM VARCHAR2 (80);
V_DATEISSUED VARCHAR2 (50);
V_DATECERTSENT VARCHAR2 (50);
V_DATEEXPIRES VARCHAR2 (50);
V_DATECLOSE VARCHAR2 (50);
V_POSTITLE VARCHAR2 (400);
V_PAYPLAN VARCHAR2 (100);
V_SERIES VARCHAR2 (100);
V_GRADE VARCHAR2 (100);
V_ADMINCODE VARCHAR2 (100);
V_ORGINITS VARCHAR2 (100);
V_IC VARCHAR2 (100);

CURSOR CUR_RECIPIENTS IS	 
---------QUERY----------------
SELECT DISTINCT 
A.TRANSACTION_ID,
--NVL(H.SHORTNAME,'') || ' '  || DBO.FN_GET_NAME_FROM_MEMBERTBL (H.NAME)HRSNAME, 
H.NAME HRSNAME, 
NVL((SELECT NVL(EMAIL, '') FROM BIZFLOW.MEMBER WHERE MEMBERID = HR_SPECIALIST_ID),'')HRSEMAIL,
NVL(I.PROGRAM_MGR_EMAIL, '') SO,
NVL(I.IC_CONTACT_EMAIL, '') AO,
--DATEDIFF(DAY,GETDATE(), NVL(DATE_NEW_CERT_EXPIRES, DATE_CERT_EXPIRES)) AS DATEDIFFTODAYTOEXPIRE,
TRUNC(((TO_DATE(NVL(DATE_NEW_CERT_EXPIRES, DATE_CERT_EXPIRES),'DD-MON-YY') - SYSDATE) + 1)) DATEDIFFTODAYTOEXPIRE,
NVL(CERT_NUMBER, '[Certificate Number Not Available]') AS CERTIFICATE_NUMBER, 
--NVL(D.ANN_TYPE, '[NOT AVAILABLE]') AS ANNOUNCEMENT_TYPE,
'[Not Available]' AS ANNOUNCEMENT_TYPE,
NVL(X.ANN_NUMBER, '[Not Available]') AS ANNOUNCEMENT_NUMBER, 
NVL(TO_CHAR(DATE_CERT_ISSUED,'MM/DD/YYYY'),'') DATEISSUED,
NVL(TO_CHAR(DATE_CERT_TO_SO,'MM/DD/YYYY'),'') DATESENTTOSO,
NVL(TO_CHAR(NVL(DATE_NEW_CERT_EXPIRES,DATE_CERT_EXPIRES),'MM/DD/YYYY'),'') DATEEXPIRES,
--CONVERT(VARCHAR(10),NVL(D.DATE_ANN_CLOSED, ' ') ,1) DATECLOSE,
' ' DATECLOSE,
NVL (C.POSITION_TITLE, ' '),
NVL (C.PAY_PLAN, ' ') ,
NVL (C.SERIES, ' ') ,
NVL (C.GRADE, ' '),
NVL (O.ADMIN_CODE, ' '), 
NVL (O.ORG_INITS,' '), 
NVL (O.IC, ' ') 

FROM 
MAIN A 
INNER JOIN NEW_POSITION C /*(NOLOCK)*/ ON C.TRANSACTION_ID = A.TRANSACTION_ID /*AND (C.TYPE) = 'Cert'*/ 
INNER JOIN CERTIFICATE X ON A.TRANSACTION_ID = X.TRANSACTION_ID /*AND X.SEQUENCE = C.RELATED_ID*/
INNER JOIN RECRUITMENT B ON B.TRANSACTION_ID = A.TRANSACTION_ID
--INNER JOIN ANNOUNCEMENT D ON A.Transaction_id = D.Transaction_id AND D.ANN_NUMBER = X.ANN_NUMBER 
INNER JOIN IC_REQUEST_INFO I ON I.TRANSACTION_ID = A.TRANSACTION_ID 
INNER JOIN BIZFLOW.MEMBER H ON H.MEMBERID = HR_SPECIALIST_ID
INNER JOIN ORGS O /*(NOLOCK)*/ ON O.ADMIN_CODE = A.ADMIN_CODE

WHERE
A.ACTION_TYPE = 'Recruitment' 


AND A.STATUS NOT IN ('COMPLETED', 'CANCELLED')
--AND X.CERT_ISSUED IN ('Yes', 'Y')
AND NVL(TRUNC(((TO_DATE(DATE_NEW_CERT_EXPIRES,'DD-MON-YY') - SYSDATE) + 1)),0) IN (5)
--AND A.INSTITUTE <> 'TEST'
----AND E.CERT_TYPE <> 'Applicant List' 
;
----------QUERY END----------------

BEGIN
    OPEN CUR_RECIPIENTS;  
    FETCH CUR_RECIPIENTS INTO
        V_WITSNUMBER,
        V_HRSNAME,
        V_HRSEMAIL,
        V_SOEMAIL,
        V_AOEMAIL,
        V_COUNT,
        V_CERTNUM,
        V_ANNTYPE,
        V_ANNNUM ,
        V_DATEISSUED,
        V_DATECERTSENT,
        V_DATEEXPIRES,
        V_DATECLOSE,
        V_POSTITLE,
        V_PAYPLAN,
        V_SERIES,
        V_GRADE ,
        V_ADMINCODE ,
        V_ORGINITS ,
        V_IC;
  LOOP
  
  IF V_COUNT = 5 THEN

    V_TORECIPIENTS := V_HRSEMAIL;
    V_CCRECIPIENTS := V_HRSEMAIL;


    V_SUBJECT := 'NOTICE - CERTIFICATE EXPIRATION - Request #' || V_WITSNUMBER /*V_POSTITLE || ' ' || V_PAYPLAN || '-' || V_SERIES || '-' || V_GRADE*/;
    V_CONTENTTOP := 

'<html>
	<head>
		<title>WiTS - Notice – Certificate Expiration  Email</title>
	</head>
	<body>
		<p>
			<font face=" Calibri" size="3"> <strong>Suggested Action: </strong></p>
		<ul>
			<li>
				<span face="">If you are extending this certificate, review the new expiration date of the action in BizFlow form.&nbsp; </span></li>
			<!--<li>
				<span face="">If you are not extending this certificate, and you have not already done so, please complete the audit process in HHS Careers (USA Staffing) and send the Disposition Letters to your applicant pool.&nbsp; </span></li>-->
			<li>
				<span face="">If you need assistance auditing a certificate in USA Staffing, please reference the</span> <a href="http://intrahr.od.nih.gov/hrsystems/staffing/hhscareers/documents/HHS_Careers_Applicant_Referral_and_Selection_User_Guide.docx"><span face="">Applicant Referral and Selection User Guide</span></a><span face="">.&nbsp; </span></li>
			<!--<li>
				<span face="">For DE Announcements, be sure to send all required documents to the CSD DEU so that they can close out the case file.&nbsp; Remember that even if there is no selection, you must send final Disposition Letters to the applicants notifying them the status of their application.&nbsp; </span></li>-->
		</ul> 

<font face=" Calibri" size="3"><strong>Details:</strong> Your certificate ' || V_CERTNUM || '  will expire on ' || V_DATEEXPIRES || '. Please reference the table below for specific information related to this action.<br><br>

	<table border="1" bordercolor="#BDBDBD" style="background-color:#FFFFFF" cellpadding="2" cellspacing="2"><font face=" Calibri" size="2">									' ||
		'<tr>    												' ||
		'<td style="width: 170px">        						' ||
		'<font face=" Calibri" size="2"><strong>Request #</strong></td>						' ||
		'<td style="width: 200px;"><font face=" Calibri" size="2">' || V_WITSNUMBER || '</td>			' ||
		'</tr>													' ||
		'<tr>    												' ||
		'<td style="width: 170px">        						' ||
		'<font face=" Calibri" size="2"><strong>Certificate #</strong></td>					' ||
		'<td style="width: 200px;"><font face=" Calibri" size="2">' || V_CERTNUM || '</td>			' ||
		'</tr>													' ||
		'<tr>    												' ||
		'<td style="width: 170px">        						' ||
		'<font face=" Calibri" size="2"><strong>Certificate Issue Date </strong></td>					' ||
		'<td style="width: 200px;"><font face=" Calibri" size="2">' || V_DATEISSUED || '</td>	        ' ||
		'</tr>													' ||
		'<tr>    												' ||
		'<td style="width: 170px">    							' ||
		'<font face=" Calibri" size="2"><strong>Certificate Expiration Date</strong></td>							' ||
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_DATEEXPIRES || '</td>			' ||
		'</tr>													' ||
		'<tr>													' ||
		'<td style="width: 170px">    							' ||
		'<font face=" Calibri" size="2"><strong> Organization</strong></td>							' ||	
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_ORGINITS || '</td>			' ||
		'</tr>													' ||
		'<!--<tr>													' ||
		'<td style="width: 170px">    							' ||
		'<font face=" Calibri" size="2"><strong> Position Title</strong></td>							' ||	
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_POSTITLE  || '</td>			' ||
		'</tr>													' ||
		'<tr>													' ||
		'<td style="width: 170px">    							' ||
		'<font face=" Calibri" size="2"><strong> Pay Plan/Series/Grade</strong></td>							' ||
		'<td style="width: 200px"><font face=" Calibri" size="2">' || V_PAYPLAN || '/' || V_SERIES || '/' || V_GRADE || '</td>			' ||
		'</tr>		-->											' ||
		'</table>												' ||
		'<br>													

		</table></body>
</html>';


    V_CONTENTBOTTOM := '<!--<font face=" Calibri" size="3"><br> Please refer to the <a href="http://intrahr.od.nih.gov/hrsystems/staffing/wits/documents/CSD_Reminder_Emails.pdf">CSD Reminder Email Guide</a> for more details about reminder emails.-->'		;

    V_DAYS := ' '; 


 
	V_SENDER := 'donotreply@hhs.gov';   
	V_BCRECIPIENTS := 'witsinten@od.nih.gov';
	V_BODY := V_CONTENTTOP ||  V_CONTENTBOTTOM;

	--SP_SEND_MAIL('dkwak@bizflow.com','dkwak@deloitte.com','','bizflow@bizflow.com',V_SUBJECT,'',V_BODY);


	-------EMAILSEND---------------
	SP_SEND_MAIL(V_TORECIPIENTS,V_CCRECIPIENTS,V_BCRECIPIENTS,V_SENDER,V_SUBJECT,'',V_BODY);

	INSERT INTO AUTO_EMAIL_LOG
	(EMAIL_SENT_DATE, FROM_EMAIL_ADDRESS,TO_EMAIL_ADDRESS,SUBJECT,BODY,OFFICE, SLA, TRANSACTION_ID, CERT_NUMBER)     
	VALUES
	(SYSDATE, V_SENDER, V_TORECIPIENTS || ';' || V_CCRECIPIENTS, V_SUBJECT, 'From: ' || V_SENDER || '<br>To: ' || V_TORECIPIENTS || '<br>CC: ' || V_CCRECIPIENTS || '<br><br>Subject: ' ||  V_SUBJECT || '<br><br>' || V_BODY,'Rec13','SLA - Cert Expires HRS' || V_DAYS || '', V_WITSNUMBER, V_CERTNUM);
	END IF;
  
  FETCH CUR_RECIPIENTS INTO 

        V_WITSNUMBER,
        V_HRSNAME,
        V_HRSEMAIL,
        V_SOEMAIL,
        V_AOEMAIL,
        V_COUNT,
        V_CERTNUM,
        V_ANNTYPE,
        V_ANNNUM ,
        V_DATEISSUED,
        V_DATECERTSENT,
        V_DATEEXPIRES,
        V_DATECLOSE,
        V_POSTITLE,
        V_PAYPLAN,
        V_SERIES,
        V_GRADE ,
        V_ADMINCODE ,
        V_ORGINITS ,
        V_IC ;


    EXIT WHEN CUR_RECIPIENTS%NOTFOUND;

    END LOOP;
    CLOSE CUR_RECIPIENTS;
    
  NULL;
EXCEPTION
	WHEN OTHERS THEN
		SP_ERROR_LOG();
END SP_JOB_RECRUITMENT_SLA_CERT_EX;

/


--------------------------------------------------------
--  DDL for Procedure SP_JOB_RECRUITMENT_JOB_TENT
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_JOB_RECRUITMENT_JOB_TENT AS 
V_SENDER VARCHAR2(100);
V_TORECIPIENTS VARCHAR2 (500);
V_CCRECIPIENTS VARCHAR2 (500);
V_BCRECIPIENTS VARCHAR2 (500);
V_SUBJECT VARCHAR2 (500);
V_CONTENTTOP VARCHAR2(4000);
V_CONTENTBOTTOM VARCHAR2(4000);
V_TABLE VARCHAR2(4000);
V_BODY CLOB;
V_WITSNUMBER VARCHAR2 (10);
V_HRSEMAIL VARCHAR2 (100);
V_TEAMLEADEMAIL VARCHAR2 (100);
V_BRANCHCHIEFEMAIL VARCHAR2 (100);
V_ADMINOFFICERNAME VARCHAR2 (100);
V_IC VARCHAR2 (10);
V_ORGINITS VARCHAR2 (50);
V_ADMINCODE VARCHAR2 (50);
V_COUNT INT;
V_ANNNUM VARCHAR2 (100);
V_ANNTYPE VARCHAR2 (10);
V_CERTNUM VARCHAR2 (100);
V_CERTTYPE VARCHAR2 (20);
V_DAYS VARCHAR2 (50);
V_TARGETDATE VARCHAR2 (50);
V_POSTITLE VARCHAR2 (100);
V_PAYPLAN VARCHAR2 (100);
V_SERIES VARCHAR2 (100);
V_GRADE VARCHAR2 (100);

CURSOR CUR_RECIPIENTS IS	 
---------QUERY----------------
SELECT 
	A.TRANSACTION_ID,
	(SELECT NVL(EMAIL, '') FROM BIZFLOW.MEMBER WHERE MEMBERID = HR_SPECIALIST_ID),
	(SELECT NVL(EMAIL, '') FROM BIZFLOW.MEMBER WHERE MEMBERID = TEAM_LEADER_ID),
	(SELECT NVL(EMAIL, '') FROM BIZFLOW.MEMBER WHERE MEMBERID = BRANCH_CHIEF_ID),
	NVL(A.INSTITUTE, ''),
	NVL(A.ORG_INITS, ''),
	NVL(A.ADMIN_CODE, ''),
	FN_GET_RECRUITMENT_EMAIL_TB_AP(A.TRANSACTION_ID, 'Approved',''),
	NVL(TRUNC((SYSDATE - TO_DATE(E.DATE_HIRING_DEC_RECD_IN_HR,'DD-MON-YY'))),0) INTCOUNT,
	NVL(E.ANN_NUMBER,'') ANN_NUMBER,
	NVL(E.CERT_NUMBER, '') CERT_NUMBER,
	NVL(E.CERT_TYPE, '') CERT_TYPE, 
	--NVL(CONVERT(VARCHAR(10),E.DATE_HIRING_DEC_RECD_IN_HR + 2,1), '') TARGETDATE,
	TO_CHAR(TO_DATE(E.DATE_HIRING_DEC_RECD_IN_HR,'DD-MON-YY')+2) TARGETDATE,
	NVL(C.POSITION_TITLE, 'N/A') POSITION_TITLE,
	NVL(C.PAY_PLAN, 'N/A') PAYPLAN, 
	NVL(C.SERIES, 'N/A') SERIES, 
	NVL(C.GRADE, 'N/A') GRADE 

FROM MAIN A
	INNER JOIN NEW_POSITION C /*(NOLOCK)*/ ON C.TRANSACTION_ID = A.TRANSACTION_ID /*AND (C.TYPE) = 'Approved'*/ 
	INNER JOIN CERTIFICATE E ON A.TRANSACTION_ID = E.TRANSACTION_ID 
	INNER JOIN APPOINTMENT F ON A.TRANSACTION_ID = F.TRANSACTION_ID
WHERE
	A.STATUS NOT IN ('COMPLETED', 'CANCELLED')
AND
	E.DATE_HIRING_DEC_RECD_IN_HR IS NOT NULL
--AND DATEDIFF(DAY,E.DATE_HIRING_DEC_RECD_IN_HR,GETDATE())IN (2)
AND NVL(TRUNC((SYSDATE - TO_DATE(E.DATE_HIRING_DEC_RECD_IN_HR,'DD-MON-YY'))),0) IN (2)
--AND A.RELATED_WITS_TRANS_ID > 0
AND TENTATIVE_JOB_OFFER_DATE IS NULL
--AND A.INSTITUTE <> 'TEST'
;
----------QUERY END----------------
BEGIN
    OPEN CUR_RECIPIENTS;  
    FETCH CUR_RECIPIENTS INTO
        V_WITSNUMBER,
        V_HRSEMAIL,
        V_TEAMLEADEMAIL,
        V_BRANCHCHIEFEMAIL,
        V_IC,
        V_ORGINITS,
        V_ADMINCODE,
        V_TABLE,
        V_COUNT,
        V_ANNNUM,
        V_CERTNUM,
        V_CERTTYPE,
        V_TARGETDATE,
        V_POSTITLE ,
        V_PAYPLAN ,
        V_SERIES ,
        V_GRADE;

    LOOP
    
        V_TORECIPIENTS := V_HRSEMAIL;
        V_CCRECIPIENTS := V_TEAMLEADEMAIL || '; ' || V_BRANCHCHIEFEMAIL; 
        
        V_SUBJECT := 'Action Needed - Extend Tentative Job Offer - Request #' || V_WITSNUMBER/*V_POSTITLE|| ' '||V_PAYPLAN||'-'||V_SERIES||'-'||V_GRADE*/;
        
        V_CONTENTTOP := 
                                                '<html>
                                                    <head>
                                                        <title>WiTS Make Tentative Job Offer</title>
                                                    </head>
                                                    <body>
                                                        <font face=" Calibri" size="3"><strong>Suggested Action:</strong> Please extend the tentative job offer<!-- and complete the “Tentative Job Offer Date” field in the WiTS Appointment Form.--><br><br>'||
        
                                                        '<font face=" Calibri" size="3"><strong>Details:</strong> Action is needed on Request # '||V_WITSNUMBER||' in order to meet OPM Hiring Reform Goals. A tentative job offer needs to be made (a voice mail message is acceptable) to the selected candidate by close of business today. Please reference the table below for specific information related to this action.<br><br>
                                                        
                                                            </body>
                                                                </html>';
        
        
                                        V_CONTENTBOTTOM := '<br><font face=" Calibri" size="3"><p align="left">Do not respond to this email address.<!--Please refer to the <a href="http://intrahr.od.nih.gov/hrsystems/staffing/wits/documents/CSD_Reminder_Emails.pdf">CSD Reminder Email Guide</a> for more details about reminder emails.--></p>'		;
        
        
        V_BODY := V_CONTENTTOP || V_TABLE || V_CONTENTBOTTOM;
        
        V_DAYS := ' (2-day notice) ';
        
        V_SUBJECT := V_SUBJECT;
        
        V_SENDER := 'donotreply@hhs.gov';
        
        V_BCRECIPIENTS := 'witsinten@od.nih.gov';
        
        --SP_SEND_MAIL('dkwak@bizflow.com','dkwak@deloitte.com','','bizflow@bizflow.com',V_SUBJECT,'',V_BODY);


        -------EMAILSEND---------------
        SP_SEND_MAIL(V_TORECIPIENTS,V_CCRECIPIENTS,V_BCRECIPIENTS,V_SENDER,V_SUBJECT,'',V_BODY);


    INSERT INTO AUTO_EMAIL_LOG
    (EMAIL_SENT_DATE, FROM_EMAIL_ADDRESS,TO_EMAIL_ADDRESS,SUBJECT,BODY,OFFICE, SLA, TRANSACTION_ID)     
    VALUES
    (SYSDATE, V_SENDER, V_TORECIPIENTS || ';' || V_CCRECIPIENTS, V_SUBJECT, 'From: ' || V_SENDER || '<br>To: ' || V_TORECIPIENTS || '<br>CC: ' || V_CCRECIPIENTS || '<br><br>Subject: ' ||  V_SUBJECT || '<br><br>' || V_BODY,'Rec3','SLA - Make Job Offer - Tentative ' || V_DAYS || '', V_WITSNUMBER);
        
    FETCH CUR_RECIPIENTS INTO 
        V_WITSNUMBER,
        V_HRSEMAIL,
        V_TEAMLEADEMAIL,
        V_BRANCHCHIEFEMAIL,
        V_IC,
        V_ORGINITS,
        V_ADMINCODE,
        V_TABLE,
        V_COUNT,
        V_ANNNUM,
        V_CERTNUM,
        V_CERTTYPE,
        V_TARGETDATE,
        V_POSTITLE ,
        V_PAYPLAN ,
        V_SERIES ,
        V_GRADE;
    
    EXIT WHEN CUR_RECIPIENTS%NOTFOUND;

    END LOOP;
    CLOSE CUR_RECIPIENTS;
  NULL;
EXCEPTION
	WHEN OTHERS THEN
		SP_ERROR_LOG();
END SP_JOB_RECRUITMENT_JOB_TENT;

/

--------------------------------------------------------
--  DDL for Procedure SP_JOB_RECRUITMENT_SLA_DECS_EX
--------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_JOB_RECRUITMENT_SLA_DECS_EX AS 
V_SENDER VARCHAR2(100);
V_TORECIPIENTS VARCHAR2 (500);
V_CCRECIPIENTS VARCHAR2 (500);
V_BCRECIPIENTS VARCHAR2 (500);
V_SUBJECT VARCHAR2 (500);
V_CONTENTTOP VARCHAR2(1000);
V_CONTENTBOTTOM VARCHAR2(1000);
V_TABLE VARCHAR2 (4000);
V_BODY CLOB;
V_WITSNUMBER VARCHAR2 (10);
V_HRSEMAIL VARCHAR2 (100);
V_HRSNAME VARCHAR2 (100);
V_SOEMAIL VARCHAR2 (100);
V_AOEMAIL VARCHAR2 (100);
V_SAEMAIL VARCHAR2 (100);
V_COUNT INT;
V_COUNT2 INT;
V_ANNTYPE VARCHAR2 (10);
V_CERTNUM VARCHAR2 (100);
V_DAYS VARCHAR2 (50);
V_BRANCH VARCHAR2 (50);
V_TARGETDATE VARCHAR2 (50);
V_DATETOSO VARCHAR2 (50);
V_ORGINITS VARCHAR2 (50);
V_ADMINCODE VARCHAR2 (50);
V_POSTITLE VARCHAR2 (100);
V_PAYPLAN VARCHAR2 (100);
V_SERIES VARCHAR2 (100);
V_GRADE VARCHAR2 (100);

CURSOR CUR_RECIPIENTS IS	 
---------QUERY----------------
SELECT 
    A.TRANSACTION_ID,
    SUBSTR(NVL(H.NAME, ''),(INSTR(NVL(H.NAME, ''),', ')+2),LENGTH(NVL(H.NAME, ''))) || ' ' || SUBSTR(NVL(H.NAME, ''),1,(INSTR(NVL(H.NAME, ''),', ')-1)) HRSNAME,
    NVL((SELECT NVL(EMAIL, '') FROM BIZFLOW.MEMBER WHERE MEMBERID = HR_SPECIALIST_ID),''),
    NVL(R.PROGRAM_MGR_EMAIL, '') SO,
    NVL(R.FTE_LIAISON_EMAIL, '') AO,
    NVL((SELECT NVL(EMAIL, '') EMAIL  FROM BIZFLOW.MEMBER WHERE MEMBERID = 
				(SELECT MAX(X.HR_SENIOR_ADVISOR_ID)
				 FROM TBL_FORM_DTL FD  
					, XMLTABLE('/DOCUMENT'
					PASSING FD.FIELD_DATA
						COLUMNS
							TRANSACTION_ID			NUMBER(10)  PATH 'MAIN/TRANSACTION_ID',
                            HR_SENIOR_ADVISOR_ID	VARCHAR2(10) PATH 'TRANSACTION/HR_SENIOR_ADVISOR_ID' ) X
				 WHERE X.TRANSACTION_ID = A.TRANSACTION_ID)),'') SA,
    NVL(FN_GET_RECRUITMENT_SLA_POSI(A.TRANSACTION_ID, 'CERTALL',''), ''),
    NVL(A.ORG_INITS, '')ORGINITS,
    NVL(A.ADMIN_CODE, '')ADMIN_CODE,
    
    (SELECT COUNT(*) FROM CERTIFICATE V
        WHERE V.TRANSACTION_ID = A.TRANSACTION_ID
        --AND V.CERT_ISSUED IN ('Yes', 'Y')
        AND V.DATE_HIRING_DEC_RECD_IN_HR IS NULL) AS INTCOUNT2,
    
    /* Top 1 for position info is needed for subject line when there is more than 1 position block on the announcement tab
    Position Title, Pay Plan, Series, Grade, and FPL are required on the user form when they indicate an announcement
    was posted, opened, or closed. Therefore, handling NULLs is not needed. 
    */
    
    (SELECT MAX(C.POSITION_TITLE) 
            FROM NEW_POSITION C 
            INNER JOIN MAIN Q
            ON C.TRANSACTION_ID = Q.TRANSACTION_ID/* AND (C.TYPE) = 'Announced'*/ 
            WHERE C.TRANSACTION_ID = A.TRANSACTION_ID ) AS POSITION_TITLE, 
    
    (SELECT MAX(C.PAY_PLAN) 
            FROM NEW_POSITION C 
            INNER JOIN MAIN Q
            ON C.TRANSACTION_ID = Q.TRANSACTION_ID/* AND (C.TYPE) = 'Announced'*/ 
            WHERE C.TRANSACTION_ID = A.TRANSACTION_ID ) AS PAY_PLAN, 
    
    (SELECT MAX(C.SERIES) 
            FROM NEW_POSITION C 
            INNER JOIN MAIN Q
            ON C.TRANSACTION_ID = Q.TRANSACTION_ID/* AND (C.TYPE) = 'Announced'*/ 
            WHERE C.TRANSACTION_ID = A.TRANSACTION_ID ) AS SERIES, 
            
    (SELECT MAX(C.GRADE)
            FROM NEW_POSITION C 
            INNER JOIN MAIN Q
            ON C.TRANSACTION_ID = Q.TRANSACTION_ID/* AND (C.TYPE) = 'Announced'*/ 
            WHERE C.TRANSACTION_ID = A.TRANSACTION_ID ) AS GRADE 

FROM MAIN A
    INNER JOIN IC_REQUEST_INFO R ON A.TRANSACTION_ID  = R.TRANSACTION_ID
    INNER JOIN BIZFLOW.MEMBER H ON H.MEMBERID = HR_SPECIALIST_ID
WHERE A.ACTION_TYPE LIKE '%Recruit%'
    AND A.STATUS NOT IN ('COMPLETED', 'CANCELLED')
    --AND A.INSTITUTE <> 'TEST'
    -------
    /*AND A.TRANSACTION_ID IN
    (
        SELECT W.TRANSACTION_ID FROM
        ANNOUNCEMENT W
        WHERE 
        W.ANN_TYPE IN ('DE', 'MP', 'DH')
    )*/
    -----
    AND A.TRANSACTION_ID NOT IN
    (
        SELECT X.TRANSACTION_ID FROM AUTO_EMAIL_LOG X
        WHERE
        OFFICE = 'Rec16' 
    )
    -----
    AND A.TRANSACTION_ID IN
    (
        SELECT Y.TRANSACTION_ID FROM 
        CERTIFICATE Y WHERE
        (Y.DATE_HIRING_DEC_RECD_IN_HR IS NULL)
        --AND DATEDIFF(DAY,GETDATE(), NVL(DATE_NEW_CERT_EXPIRES, DATE_CERT_EXPIRES)) IN (0)
        AND NVL(TRUNC((SYSDATE - TO_DATE(NVL(DATE_NEW_CERT_EXPIRES, DATE_CERT_EXPIRES),'DD-MON-YY'))),0) IN (1)
    )
    -------
    /*AND A.TRANSACTION_ID IN
    (
        SELECT Z.TRANSACTION_ID FROM 
        CERTIFICATE Z WHERE
        Z.CERT_ISSUED IN ('Yes', 'Y')
    )*/
;
----------QUERY END----------------
BEGIN
    OPEN CUR_RECIPIENTS;  
    FETCH CUR_RECIPIENTS INTO
        V_WITSNUMBER,
        V_HRSNAME,
        V_HRSEMAIL,
        V_SOEMAIL,
        V_AOEMAIL,
        V_SAEMAIL,
        V_TABLE,
        V_ORGINITS,
        V_ADMINCODE,
        V_COUNT2,
        V_POSTITLE ,
        V_PAYPLAN ,
        V_SERIES ,
        V_GRADE;
    
    LOOP
    IF V_COUNT2 = 1  THEN-- langauge in the content top is not plural

        V_TORECIPIENTS := V_SOEMAIL || ';' || V_AOEMAIL;
        V_CCRECIPIENTS := V_HRSEMAIL || ';' || V_SAEMAIL;
        V_SUBJECT := 'Action Needed - Hiring Decision Needed Cert Expiring - Request # ' || V_WITSNUMBER/*|| V_POSTITLE || ' ' || V_PAYPLAN || '-' || V_SERIES || '-' || V_GRADE*/;
        
        V_CONTENTTOP := 
        
        '<html>
            <head>
                <title>WiTS Certificate Expire</title>
            </head>
            <body>
        
        <font face=" Calibri" size="3"><strong>Suggested Action:</strong> Please contact ' || V_HRSNAME || ' regarding your Hiring Decision (selection/non-selection) or to request an extension.<br><br>' ||
                             '<font face=" Calibri" size="3"><strong>Details:</strong> The certificate for the position listed below is set to expire. Please reference the table below for the expiration date and other details of the certificate.<br><br>
        
        
        </body>
        </html>';
    

    
    ELSE  -- langauge in the content top is plural
 
    
        V_TORECIPIENTS := V_SOEMAIL || ';' || V_AOEMAIL;
        V_CCRECIPIENTS := V_HRSEMAIL || ';' || V_SAEMAIL;
        V_SUBJECT := 'Action Needed - Hiring Decision Needed Certs Expiring – ' || V_POSTITLE || ' ' || V_PAYPLAN || '-' || V_SERIES || '-' || V_GRADE;
        
        V_CONTENTTOP := 
        
        '<html>
            <head>
                <title>WiTS Certificate Expire</title>
            </head>
            <body>
        
        <font face=" Calibri" size="3"><strong>Suggested Action:</strong> Please contact ' || V_HRSNAME || ' regarding your Hiring Decision (selection/non-selection) or to request an extension.<br><br>' ||
                             '<font face=" Calibri" size="3"><strong>Details:</strong> The certificates for the positions listed below are set to expire. Please reference the tables below for the expiration dates and other details of the certificates.<br><br>
        
        
        </body>
        </html>';
    
    END IF;
    
    
    V_CONTENTBOTTOM :=  '<br><font face=" Calibri" size="3"><p align="left">Do not respond to this email.<!--Please refer to the <a href="http://intrahr.od.nih.gov/hrsystems/staffing/wits/documents/CSD_Reminder_Emails.pdf">CSD Reminder Email Guide</a> for more details about reminder emails.--></p>'		;
    V_DAYS := ' ';
    V_SENDER := 'donotreply@hhs.gov';
    V_BCRECIPIENTS := 'witsinten@od.nih.gov';
    
    V_BODY := V_CONTENTTOP ||  V_TABLE || V_CONTENTBOTTOM;
    
    --SP_SEND_MAIL('dkwak@bizflow.com','dkwak@deloitte.com','','bizflow@bizflow.com',V_SUBJECT,'',V_BODY);


    -------EMAILSEND---------------
    SP_SEND_MAIL(V_TORECIPIENTS,V_CCRECIPIENTS,V_BCRECIPIENTS,V_SENDER,V_SUBJECT,'',V_BODY);


    INSERT INTO AUTO_EMAIL_LOG
    (EMAIL_SENT_DATE, FROM_EMAIL_ADDRESS,TO_EMAIL_ADDRESS,SUBJECT,BODY,OFFICE, SLA, TRANSACTION_ID)     
    VALUES
    (SYSDATE, V_SENDER, V_TORECIPIENTS || ';' || V_CCRECIPIENTS, V_SUBJECT, 'From: ' || V_SENDER || '<br>To: ' || V_TORECIPIENTS || '<br>CC: ' || V_CCRECIPIENTS || '<br><br>Subject: ' ||  V_SUBJECT || '<br><br>' || V_BODY,'Rec16','SLA - Cert Expires SO', V_WITSNUMBER);
     
    
    FETCH CUR_RECIPIENTS INTO
        V_WITSNUMBER,
        V_HRSNAME,
        V_HRSEMAIL,
        V_SOEMAIL,
        V_AOEMAIL,
        V_SAEMAIL,
        V_TABLE,
        V_ORGINITS,
        V_ADMINCODE,
        V_COUNT2,
        V_POSTITLE ,
        V_PAYPLAN ,
        V_SERIES ,
        V_GRADE;
    EXIT WHEN CUR_RECIPIENTS%NOTFOUND;

    END LOOP;
    CLOSE CUR_RECIPIENTS;
  NULL;
  EXCEPTION
	WHEN OTHERS THEN
		SP_ERROR_LOG();
END SP_JOB_RECRUITMENT_SLA_DECS_EX;

/
