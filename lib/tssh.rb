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

  def calc_num_panes(num)
    # XXX should read tmux implementation
    if num == 1
      return 1
    elsif num == 2
      return 2
    elsif num > 6 and num <= 9
      return 9
    elsif num > 20 and num <= 25
      return 25
    elsif num > 25 and num <= 30
      return 30
    elsif num > 30 and num <= 36
      return 36
    elsif num > 36
      return calc_num_panes(num - 36) + 36
    elsif num.even?
      return num
    end

    sqrt_num = Math.sqrt(num)
    if sqrt_num - sqrt_num.floor == 0
      return num
    else
      return sqrt_num.ceil ** 2
    end
  end

  def run
    num_panes = calc_num_panes(@hosts.count)
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
        # create new session
        system("tmux new -d -s #{session_name} #{command}")
        system("tmux setw -t #{session_name} synchronize-panes on > /dev/null")
        system("tmux setw -t #{session_name} remain-on-exit on > /dev/null")
      elsif i  % @options[:panes_per_window] == 0
        # create new window on existing session
        system("tmux neww -t #{session_name} #{command}")
        system("tmux setw -t #{session_name} synchronize-panes on > /dev/null")
        system("tmux setw -t #{session_name} remain-on-exit on > /dev/null")
      else
        # add pane to active window
        system("tmux splitw -t #{session_name} #{command}")
        system("tmux selectl -t #{session_name} tiled > /dev/null")
      end
    end

    # attach to the session
    exec("tmux attach -t #{session_name}")
  end
end
