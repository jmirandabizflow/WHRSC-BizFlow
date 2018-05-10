

--=============================================================================
-- Grant privileges on objects under WHRSC schema to roles
-------------------------------------------------------------------------------


-- privilege on BIZFLOW tables to be used in stored procedure of HHS_WHRSC_HR schema
-- NOTE: This cannot be granted through role and should be granted individually and directly to user

GRANT SELECT, INSERT, UPDATE ON BIZFLOW.RLVNTDATA TO HHS_WHRSC_HR;
GRANT SELECT ON BIZFLOW.WITEM TO HHS_WHRSC_HR;
GRANT SELECT ON BIZFLOW.PROCS TO HHS_WHRSC_HR;
GRANT SELECT ON BIZFLOW.MEMBER TO HHS_WHRSC_HR;
GRANT SELECT ON BIZFLOW.ATTACH TO HHS_WHRSC_HR;
GRANT SELECT, UPDATE ON BIZFLOW.DEADLINE TO HHS_WHRSC_HR;
GRANT SELECT ON BIZFLOW.PARENTMEMBER TO HHS_WHRSC_HR;
