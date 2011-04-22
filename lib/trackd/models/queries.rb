# not used yet
module Queries
  extend self
  
  def project_logs(proj_opts = {}, logs_opts = {})
    DataMapper.repository(:default).adapter.select(
      %q{ SELECT a.*, b.* 
          FROM trackd_projects a INNER JOIN trackd_logs b ON a.id = b.project_id
          ORDER BY a.name        
        }
    )
  end
  
  def project_status
    DataMapper.repository(:default).adapter.select(
      %q{ SELECT a.name, b.total_duration, c.last_started_at, c.last_stopped_at, c.last_task, c.last_duration
          FROM trackd_projects as a 
          INNER JOIN
            (SELECT t.project_id, SUM(t.dur) as total_duration 
             FROM 
               (SELECT project_id, ( coalesce(strftime('%s',stopped_at), strftime('%s','now')) - strftime('%s',started_at) + adjusted ) AS dur 
                FROM trackd_logs
               ) as t
             GROUP BY t.project_id
            ) as b 
          ON a.id = b.project_id 
          LEFT OUTER JOIN
            (SELECT t.project_id, t.started_at as last_started_at, t.stopped_at as last_stopped_at, t.task as last_task, t.dur as last_duration
             FROM
               (SELECT *, ( coalesce(strftime('%s',stopped_at), strftime('%s','now')) - strftime('%s',started_at) + adjusted ) AS dur 
                FROM trackd_logs
               ) as t 
             INNER JOIN
               (SELECT project_id, MAX(started_at) as last_started_at FROM trackd_logs
                GROUP BY project_id
                HAVING started_at = MAX(started_at)
               ) as last
             ON t.project_id = last.project_id AND t.started_at = last.last_started_at
            ) as c
          ON a.id = c.project_id
          ORDER BY c.last_started_at DESC, a.name
        }
    )
  end
end
