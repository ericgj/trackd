# trackd

A rewrite of the command-line ReinH-track (voxdolo/track)
as a skinny daemon + command-line client.

## Usage

    # start server daemon
    trackd -d start
    
    # start time  => POST /1/projects/FooProject/logs?task=baz%20task
    track FooProject baz task
    # or
    track start FooProject baz task
    
    # stop time on current  => PUT /1/logs/1
    track stop
    
    # restart current   => POST /1/projects/FooProject/logs?task=baz%20task
    track restart
    
    # print report of times by project and task  => GET /1/projects
    track cat
    
    # print summary report by project   => GET /1/status
    track status
    
    # print summary report for project by task   => GET /1/projects/FooProject/status
    track status FooProject
    
    # print summary report by project and task   => GET /1/projects/FooProject/status?task=baz%20task
    track status FooProject baz task
    
    # add time to named task    =>  PUT /1/projects/FooProject/logs?task=baz%20task&time=30
    track add 00:30 FooProject baz task
    
    # subtract time from current  => PUT /1/projects/FooProject/logs?task=baz%20task&time=-60
    track sub 01:00
    
    # add shortcut
    track shortcut add fp FooProject
    

## REST API 
(v1 draft - not fully implemented)

| Command         | Verb | URL                     | Params         | Redirect to              |
| start x y       | POST | /1/projects/x/logs      | task=y         | /logs/:id (1)            |
| restart         | POST | /1/projects/x/logs      | task=y         | /logs/:id                |
| stop            | PUT  | /1/logs/:id             | -              | /logs/:id                |
| add t x y       | PUT  | /1/projects/x/logs      | task=y&time=t  | /logs/:id                |
| sub t x y       | PUT  | /1/projects/x/logs      | task=y&time=-t | /logs/:id                |
| cat             | GET  | /1/projects (2)         | -              | -                        |
| status          | GET  | /1/status (3)           | -              | -                        |
| status x        | GET  | /1/projects/x/status (4)| -              | -                        |
| status x y      | GET  | /1/projects/x/status (5)| task=y         | -                        |

(1) project-log message:

    id: <int>
    task : <string>
    started_at : <time>
    stopped_at : <time>
    adjusted : <int>
    duration : <int>
    project :
      id: <int>
      name: <string>
    
(2) logs message:

    -
      name : <string>
      logs :
        - 
          task : <string>
          started_at : <time>
          stopped_at : <time>
          adjusted : <int>
          duration : <int>
        -
          # ...
      name : <string>
      logs :
        - # ...
    # ...
  
(3) server status message:

    total_duration : <int>
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
    
    
(4) project status message:

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
      
(5) project-task status message:
    
    task : <string>
    last_started_at : <time>
    last_stopped_at : <time>
    last_duration : <int>
    total_duration : <int>
    project :
      id: <int>
      name: <string>
     

## Client state - proposal

For _restart_ and _stop_, client needs to persist _current log_ between calls.  In addition there are the shortcuts.
Since it's not a web client I propose writing these to a text file in ~/, or to a PStore.

Note that my workflow is really one project-task at a time, so no need to get complicated.
When `track start y` and there's a current log, it should `track stop` first.
Or I suppose this could be handled by the server.

