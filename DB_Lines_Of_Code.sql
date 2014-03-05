-- Find the total number of lines of user written code in the database as a whole
select sum(t.lines_of_code) as lines_ofcode
from
(
    select o.name as sp_name
		,(len(c.text) - len(replace(c.text, char(10), ''))) as lines_of_code
		,case when o.xtype = 'P' then 'Stored Procedure'
			 when o.xtype in ('FN', 'IF', 'TF') then 'Function'
		end as type_desc
    from sysobjects o
    join syscomments c on c.id = o.id
    where o.xtype in ('P', 'FN', 'IF', 'TF')
    and o.category = 0
    and o.name not in ('fn_diagramobjects', 'sp_alterdiagram', 'sp_creatediagram', 'sp_dropdiagram', 'sp_helpdiagramdefinition', 'sp_helpdiagrams', 'sp_renamediagram', 'sp_upgraddiagrams', 'sysdiagrams')
) t

-- List the number of lines of code for each user created object in the database
select t.sp_name as name, sum(t.lines_of_code) - 1 as lines_ofcode, t.type_desc as typedesc
from
(
    select o.name as sp_name
		,(len(c.text) - len(replace(c.text, char(10), ''))) as lines_of_code
		,case when o.xtype = 'P' then 'Stored Procedure'
			 when o.xtype in ('FN', 'IF', 'TF') then 'Function'
		end as type_desc
    from sysobjects o
    join syscomments c on c.id = o.id
    where o.xtype in ('P', 'FN', 'IF', 'TF')
    and o.category = 0
    and o.name not in ('fn_diagramobjects', 'sp_alterdiagram', 'sp_creatediagram', 'sp_dropdiagram', 'sp_helpdiagramdefinition', 'sp_helpdiagrams', 'sp_renamediagram', 'sp_upgraddiagrams', 'sysdiagrams')
) t
group by t.sp_name, t.type_desc
--having sum(t.lines_of_code) - 1 > 500 --This line is useful to display only the items with more lines than specified
order by sum(t.lines_of_code) - 1 desc
