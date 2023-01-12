
create or replace view vw_충북연구원
as
SELECT x, y, timezn_cd,substr(age_cd, 1,1) mf, substr(age_cd, 2) age_cd, data
  FROM (
         SELECT *
           FROM 충북연구원
        )
UNPIVOT (data for age_cd in (
                            M00 AS 'M00', 
                            M10 AS 'M10', 
                            M15 AS 'M15', 
                            M20 AS 'M20', 
                            M25 AS 'M25',
                            M30 AS 'M30', 
                            M35 AS 'M35', 
                            M40 AS 'M40',
                            M45 AS 'M45',
                            M50 AS 'M50', 
                            M55 AS 'M55', 
                            M60 AS 'M60', 
                            M65 AS 'M65',
                            M70 AS 'M70',
                            F00 AS 'F00', 
                            F10 AS 'F10', 
                            F15 AS 'F15', 
                            F20 AS 'F20', 
                            F25 AS 'F25',
                            F30 AS 'F30', 
                            F35 AS 'F35', 
                            F40 AS 'F40',
                            F45 AS 'F45',
                            F50 AS 'F50', 
                            F55 AS 'F55', 
                            F60 AS 'F60', 
                            F65 AS 'F65',
                            F70 AS 'F70'
                            )
);

select mf, age_cd, count(*)
from vw_충북연구원
group by mf, age_cd


