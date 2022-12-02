CREATE OR REPLACE FORCE EDITIONABLE VIEW "EBA_PROJECTS_V" ("ID", "NAME", "STATUS", "PROJECT_LEAD", "COMPLETED_DATE", "BUDGET", "COST", "BUDGET_V_COST", "MILESTONES", "TASKS") AS 
  select p.id
,      p.name
,      s.description status
,      p.project_lead
,      p.completed_date
,      p.budget
,      (select sum(t.cost)
        from eba_project_tasks t
        where t.project_id = p.id
       ) cost
,       p.budget - (select sum(t.cost)
                   from eba_project_tasks t
                   where t.project_id = p.id
       ) budget_v_cost
,      (select count(*)
        from eba_project_milestones m
        where m.project_id = p.id
       ) milestones 
,      (select count(*)
        from eba_project_tasks t
        where t.project_id = p.id
       ) tasks
from eba_projects p
,    eba_project_status s
where s.id = p.status_id
/
