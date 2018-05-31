
--=============================================================================
-- Create TABLESPACE, USER for IHS project to be run by system admin account
-------------------------------------------------------------------------------

-- Make sure the directory to store the datafile actually exists on the server where DBMS is installed.
CREATE TABLESPACE HHS_WHRSC_HR_TS DATAFILE 'D:\bizflowdb\HHS_WHRSC_HR_TS.dbf' SIZE 30M AUTOEXTEND ON NEXT 3M MAXSIZE UNLIMITED;

CREATE USER HHS_WHRSC_HR IDENTIFIED BY <replace_with_password>
	DEFAULT TABLESPACE HHS_WHRSC_HR_TS
	QUOTA UNLIMITED ON HHS_WHRSC_HR_TS;

CREATE USER WHRSCADMIN IDENTIFIED BY <replace_with_password>;
GRANT CONNECT, RESOURCE, DBA TO WHRSCADMIN;

-- create role and grant privilege
CREATE ROLE HHS_WHRSC_HR_RW_ROLE;

-- grant WHRSC role to WHRSC user
GRANT CONNECT, RESOURCE, HHS_WHRSC_HR_RW_ROLE TO HHS_WHRSC_HR;

-- grant WHRSC database privileges to WHRSC role
GRANT ALTER SESSION, CREATE CLUSTER, CREATE DATABASE LINK
	, CREATE SEQUENCE, CREATE SESSION, CREATE SYNONYM, CREATE TABLE, CREATE VIEW
	, CREATE PROCEDURE
	TO HHS_WHRSC_HR_RW_ROLE
;

---------------------------------
-- CROSS schema access
---------------------------------

-- grant the WHRSC database access role to bizflow database user

GRANT HHS_WHRSC_HR_RW_ROLE TO BIZFLOW;






