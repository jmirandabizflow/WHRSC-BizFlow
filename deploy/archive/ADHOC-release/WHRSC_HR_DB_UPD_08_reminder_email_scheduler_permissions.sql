----------------------------------------------------------------------------
--  Permission for HHS_WHRSC_HR user to create, execute & manage Oracle Jobs
----------------------------------------------------------------------------

GRANT CREATE ANY JOB TO HHS_WHRSC_HR;
GRANT EXECUTE ON DBMS_SCHEDULER TO HHS_WHRSC_HR;
GRANT MANAGE SCHEDULER TO HHS_WHRSC_HR;
