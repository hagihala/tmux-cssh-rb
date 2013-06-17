class TmuxClusterSSH
  def initialize options, hosts, logger
    @options = options
    @hosts = hosts
    raise "No hosts specified" if @hosts.count == 0
  end

  def ssh_command host
    if @options[:login].nil?
      "#{@options[:ssh]} #{@options[:ssh_args]} #{host}"
    else
      "#{@options[:ssh]} #{@options[:ssh_args]} #{@options[:login]}@#{host}"
    end
  end

  def run
    num_panes =
      @hosts.count > 2 ? Math.sqrt(@hosts.count).ceil ** 2 : @hosts.count
    session_name = "tssh-#{$$}"
    (0..num_panes-1).each do |i|
      host = @hosts[i]
      if host.nil?
        command = "'echo;echo empty'"
      else
        command = "'echo #{host};exec #{ssh_command(host)}'"
      end
      STDERR.puts command if @options[:debug] > 0
      if i == 0
        system("tmux new -d -s #{session_name} #{command}")
      elsif i  % @options[:panes_per_window] == 0
        system("tmux setw -t #{session_name} synchronize-panes on > /dev/null")
        system("tmux setw -t #{session_name} remain-on-exit on > /dev/null")
        system("tmux neww -t #{session_name} #{command}")
      else
        system("tmux splitw -t #{session_name} #{command}")
        system("tmux selectl -t #{session_name} tiled > /dev/null")
      end
    end

    system("tmux setw -t #{session_name} synchronize-panes on > /dev/null")
    system("tmux setw -t #{session_name} remain-on-exit on > /dev/null")
    exec("tmux attach -t #{session_name}")
  end
end
