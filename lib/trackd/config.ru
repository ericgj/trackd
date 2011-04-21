require File.join(File.dirname(__FILE__),'..','trackd')
Trackd::App.run! :port => 2003

at_exit { Trackd::App.at_exit }

