# not used yet
module Queries
  extend self
  
  def select_project_logs(proj_opts = {}, logs_opts = {})
    DataMapper.repository(:default).adapter.select(
      %q{ SELECT a.*, b.* 
          FROM trackd_projects a INNER JOIN trackd_logs b ON a.id = b.project_id
          ORDER BY a.name        
        }
    )
  end
  
end
