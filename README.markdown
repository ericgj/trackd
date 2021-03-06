# trackd

A rewrite of the command-line ReinH-track (voxdolo/track)
as a skinny daemon + command-line client.

## Usage

    # start server daemon
    trackd -d start
    
    # start time  => POST /1/projects/my-project/logs?task=config%20dbase
    track start my-project config dbase
    
    # or simply
    track my-project config dbase
    
    # stop time on current  => PUT /1/current/logs
    track stop
    
    # stop time with message  => PUT /1/current/logs?message=I%20did%20some%20work
    track stop "I did some work"
    
    # restart last   => POST /1/last/logs
    track restart
    
    # print report of times by project and task  => GET /1/projects
    track cat
    
    # print summary report by project   => GET /1/status
    track status
    
    # print summary report for project by task   => GET /1/projects/my-project/status
    track status my-project
    
    # print summary report by project and task   => GET /1/projects/my-project/status?task=config%20dbase
    track status my-project config dbase
    
    # add time to named task    =>  PUT /1/projects/my-project/logs?task=config%20dbase&time=30
    track add 00:30 my-project config dbase
    
    # subtract time from last  => PUT /1/last/logs?time=-60
    track sub 01:00
    
    # add shortcut
    track shortcut add mp my-project
    

## REST API 
(v1 draft - not fully implemented)


<table><tbody>
<tr>
  <td> Command         </td><td> Verb </td><td> URL                     </td><td> Params         </td><td> Redirect to              </td>
</tr>
<tr>
  <td> start x y       </td><td> POST </td><td> /1/projects/x/logs      </td><td> task=y         </td><td> /1/logs/:id (1)            </td>
</tr>
<tr>
  <td> restart         </td><td> POST </td><td> /1/last/logs      </td><td> -         </td><td> /1/logs/:id                </td>
</tr>
<tr>
  <td> stop            </td><td> PUT  </td><td> /1/current/logs             </td><td> -              </td><td> /1/logs/:id                </td>
</tr>
<tr>
  <td> stop m          </td><td> PUT  </td><td> /1/current/logs/?message=m  </td><td> -              </td><td> /1/logs/:id                </td>
</tr>
<tr>
  <td> add t x y       </td><td> PUT  </td><td> /1/projects/x/logs      </td><td> task=y&time=t  </td><td> /1/logs/:id                </td>
</tr>
<tr>
  <td> add t           </td><td> PUT  </td><td> /1/last/logs      </td><td> time=t  </td><td> /1/logs/:id                </td>
</tr>
<tr>
  <td> sub t x y       </td><td> PUT  </td><td> /1/projects/x/logs      </td><td> task=y&time=-t </td><td> /1/logs/:id                </td>
</tr>
<tr>
  <td> sub t           </td><td> PUT  </td><td> /1/last/logs      </td><td> time=-t  </td><td> /1/logs/:id                </td>
</tr>
<tr>
  <td> cat             </td><td> GET  </td><td> /1/logs (2)         </td><td> -              </td><td> -                        </td>
</tr>
<tr>
  <td> status          </td><td> GET  </td><td> /1/status (3)           </td><td> -              </td><td> -                        </td>
</tr>
<tr>
  <td> status x        </td><td> GET  </td><td> /1/projects/x/status (4)</td><td> -              </td><td> -                        </td>
</tr>
<tr>
  <td> status x y      </td><td> GET  </td><td> /1/projects/x/status (5)</td><td> task=y         </td><td> -                        </td>
</tr>
</tbody></table>

All messages are in JSON format.

(1) log message:

    id: <int>
    task : <string>
    started_at : <time>
    stopped_at : <time>
    adjusted : <int>
    duration : <int>
    message : <string>
    project :
      id: <int>
      name: <string>
    
(2) logs message (order by started_at desc)
    
    -
      id: <int>
      task : <string>
      started_at : <time>
      stopped_at : <time>
      adjusted : <int>
      duration : <int>
      message : <string>
      project :
        id: <int>
        name: <string>
    -
      # ...

project-logs message -- not currently used, GET /1/projects

    -
      name : <string>
      logs :
        - 
          task : <string>
          started_at : <time>
          stopped_at : <time>
          adjusted : <int>
          duration : <int>
          message : <string>
        -
          # ...
      name : <string>
      logs :
        - # ...
    # ...
  
(3) server status message (note projects are ordered by last_started_at desc, project name)

    server_uptime : <int>
    total_duration : <int>
    current_log:
      id: <int>
      task : <string>
      started_at : <time>
      stopped_at : <time>
      adjusted : <int>
      duration : <int>
      message : <string>
      project :
        id: <int>
        name: <string>
    projects :
      -
        name : <string>
        last_task : <string>
        last_started_at : <time>
        last_stopped_at : <time>
        last_duration : <int>
        total_duration : <int>
      -
        # ...
    
    
(4) project status message:  (not yet implemented)

    name : <string>
    total_duration : <int>
    tasks :
      -
        task : <string>
        last_started_at : <time>
        last_stopped_at : <time>
        last_duration : <int>
        total_duration : <int>
      -
        # ...
      
(5) project-task status message:   (not yet implemented)
    
    task : <string>
    last_started_at : <time>
    last_stopped_at : <time>
    last_duration : <int>
    total_duration : <int>
    project :
      id: <int>
      name: <string>
     


