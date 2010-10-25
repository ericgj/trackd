# Note not sure subprocesses are the best route...

module ServerRunnerHelper
  
  def self.run
    puts '-------------- server subprocess starting ------------------'
    begin
      svr = Kernel.open('| bin/trackd start -e test')
      #line = ''
      #while line = svr.gets
      #  print line
      #  break if line =~ /Listening on/
      #end
    ensure
      svr.close if svr
    end
  end
  
#  def self.kill(pid)
#    Process.kill("INT", pid)
#  end
  
end