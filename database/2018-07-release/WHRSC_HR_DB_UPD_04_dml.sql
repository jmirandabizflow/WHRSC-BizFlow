SET DEFINE OFF;

Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'C','ACF',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'A','ACL',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'A','AHRQ',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'C','ASA',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'A','ASFR',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'A','ASL',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'B','ASPA',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'A','ASPE',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'B','ASPR',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'B','DAB',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'A','IEA',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'A','IOS',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'B','OASH',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'A','OCIO',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'C','OCR',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'B','OGA',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'C','OGC',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'A','ONC',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'A','OSSI',null,null,null,null);
Insert into HHS_WHRSC_HR.BRANCHES (REPL_ID,ID,BRANCH,IC,EFF_START_DATE,EFF_END_DATE,CURRENT_BRANCH,OLD_BRANCH) values (null,null,'B','PSC',null,null,null,null);

--===================================================
--UPDATE RECORDS FOR HHS_WHRSC_HR.TYPE_VALUES
--===================================================
DELETE HHS_WHRSC_HR.TYPE_VALUES WHERE TYPE_NAME = 'statList';

Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList',null,null,';Hide;Cache-ALL:OA:rybCodeList:statusList-icStatList:OA:icRybCodeList:icStatusList;',null,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Active with Program',';Yellow;',';ALL;',2,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Pending Committee Review',';Tan;',';ALL;!icStatList;',null,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Pending Bldg 1 Decision',';Tan;',';ALL;!icStatList;',null,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Incomplete Package Received',';Yellow;',';ALL;icStatList;',null,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Completed',';Blue;',';ALL;',5,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Announcement Released/Open',';Green;',';ALL;',4,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Active in HR',';Red;',';ALL;',1,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Pending Posting',';Red;',';ALL;!icStatList;',null,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Certificate Pending in HR',';Red;',';ALL;!icStatList;',null,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Pending Additional Approval',';Tan;',';ALL;!icStatList;',null,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Incomplete Package Received by HR',';Yellow;',';ALL;!icStatList;',null,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Pending Program Action',';Yellow;',';ALL;!icStatList;',null,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Pending Planned Management Action',';Yellow;',';ALL;!icStatList;',null,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Hold - Future/Projected Action',';Yellow;',';ALL;!icStatList;',null,null);
Insert into HHS_WHRSC_HR.TYPE_values (TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values('statList','Active with DEU',';Yellow;',';ALL;',3,null);



COMMIT;