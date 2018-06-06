UPDATE HHS_WHRSC_HR.type_values SET type_value ='01' WHERE type_name = 'gradeList' and type_value = '1';
UPDATE HHS_WHRSC_HR.type_values SET type_value ='02' WHERE type_name = 'gradeList' and type_value = '2';
UPDATE HHS_WHRSC_HR.type_values SET type_value ='03' WHERE type_name = 'gradeList' and type_value = '3';
UPDATE HHS_WHRSC_HR.type_values SET type_value ='04' WHERE type_name = 'gradeList' and type_value = '4';
UPDATE HHS_WHRSC_HR.type_values SET type_value ='05' WHERE type_name = 'gradeList' and type_value = '5';
UPDATE HHS_WHRSC_HR.type_values SET type_value ='06' WHERE type_name = 'gradeList' and type_value = '6';
UPDATE HHS_WHRSC_HR.type_values SET type_value ='07' WHERE type_name = 'gradeList' and type_value = '7';
UPDATE HHS_WHRSC_HR.type_values SET type_value ='08' WHERE type_name = 'gradeList' and type_value = '8';
UPDATE HHS_WHRSC_HR.type_values SET type_value ='09' WHERE type_name = 'gradeList' and type_value = '9';

UPDATE HHS_WHRSC_HR.type_values SET disp_order =1001 WHERE type_name = 'payPlanList' and type_value = 'ZZ';

UPDATE HHS_WHRSC_HR.type_values SET disp_order = 6 WHERE type_name = 'Type Of Preference' and type_value = '6-10-Point/Compensable 30%';
UPDATE HHS_WHRSC_HR.type_values SET disp_order = 5 WHERE type_name = 'Type Of Preference' and type_value = '5-10-Point/Other';
UPDATE HHS_WHRSC_HR.type_values SET disp_order = 4 WHERE type_name = 'Type Of Preference' and type_value = '4-10-Point/Compensable';
UPDATE HHS_WHRSC_HR.type_values SET disp_order = 3 WHERE type_name = 'Type Of Preference' and type_value = '3-10-Point/Disability';
UPDATE HHS_WHRSC_HR.type_values SET disp_order = 2 WHERE type_name = 'Type Of Preference' and type_value = '2-5-Point';
UPDATE HHS_WHRSC_HR.type_values SET disp_order = 1 WHERE type_name = 'Type Of Preference' and type_value = '1-None';

UPDATE HHS_WHRSC_HR.type_values SET type_value = 'WHRSC' WHERE type_name = 'Program' and type_value = 'HHS_WHRSC_HR';
UPDATE HHS_WHRSC_HR.rdr_approval SET program = 'WHRSC' WHERE program = 'HHS_WHRSC_HR';

Insert into HHS_WHRSC_HR.TYPE_VALUES (REPL_ID,TYPE_NAME,TYPE_VALUE,CONDITION_1,CONDITION_2,DISP_ORDER,TYPE_CODE) values (null,'hireTypeList','Reappointment',null,';ALL;',null,null);

Delete FROM HHS_WHRSC_HR.type_values Where type_name = 'hireTypeList' And type_value = 'Reappointment';
