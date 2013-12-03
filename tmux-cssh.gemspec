Gem::Specification.new do |s|
  s.name = 'tmux-cssh'
  s.summary = 'Cluster-SSH on tmux'
  s.homepage = 'https://github.com/yshh/tmux-cssh-rb'
  s.version = '0.2.0'
  s.authors = ['Yusuke Hagihara']
  s.email = 'yusuke.hagihara@gmail.com'
  s.files = `git ls-files`.split($/)
  s.executables = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.add_dependency 'inifile', '~> 2.0.0'
  s.required_ruby_version = '>= 1.9.3'
end
