
module ServerRunnerHelper
  
  def start_server
    puts '-------------- server daemon starting ------------------'
    `bin/trackd -d start -e test -l log/thin.log`
    # monitor the log until server starts or error
    th = tail_wait('log/thin.log', /^>>\s+Listening\s+on/)
    th.join(15)
    if block_given?
      yield
      stop_server
    end
  end
  
  def stop_server
    puts '-------------- server daemon stopping ------------------'
    `bin/trackd -d stop`
  end
  
  private
  
    # Acts like GNU tail command. Adapted from Thin which took from Rails.
    def tail_wait(file, pattern = nil)
      cursor = File.exist?(file) ? File.size(file) : 0
      last_checked = Time.now
      tail_thread = Thread.new do
        Thread.pass until File.exist?(file)
        File.open(file, 'r') do |f|
          loop do
            f.seek cursor
            if f.mtime > last_checked
              last_checked = f.mtime
              contents = f.read
              cursor += contents.length
              puts contents
              break if pattern && contents =~ pattern || contents =~ /.rb:\d+:in\s/
            end
            sleep 0.1
          end
        end
      end
      sleep 1 if File.exist?(file) # HACK Give the thread a little time to open the file
      tail_thread
    end
        
end