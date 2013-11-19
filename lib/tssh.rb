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
    case num
    when 1
      return 1
    when 2
      return 2
    when 7..9
      return 0
    when 17..20
      return 20
    when 21..25
      return 25
    when 26..30
      return 30
    when 31..36
      return 36
    when 37..Float::INFINITY
      return calc_num_panes(num - 36) + 36
    when ->(n) { n.even? }
      return num
    else
      sqrt_num = Math.sqrt(num)
      if sqrt_num - sqrt_num.floor == 0
        return num
      else
        return sqrt_num.ceil ** 2
      end
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
