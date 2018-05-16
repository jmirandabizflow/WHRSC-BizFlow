ALTER TABLE CHR_EMPLOYEE_INFO 
modify
   (
   GRADE VARCHAR2 (30)
   );

ALTER TABLE RDR_ATTACH 
modify
   (
   PROGRAM VARCHAR2(20)
   );


delete type_values where type_name = 'Incentives Offered' and type_value = 'N/A';

delete type_values where type_name = 'Additional Recruit Channels'  and type_value in ('N/A','Slideshow Job on Jobs@NIH');

