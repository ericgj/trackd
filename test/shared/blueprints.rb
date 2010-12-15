require 'machinist/data_mapper'
require 'sham'

Sham.name {  (1..10).map { ('a'..'z').to_a.rand }.join }

Project.blueprint do
  name { Sham.name }
end

Log.blueprint do
  project
  task { Sham.name }
  adjusted { 0 }
  adjusted_start { 0 }
  started_at
  stopped_at
  message
end