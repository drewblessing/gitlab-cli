require 'yaml'

module GitlabCli
  class << self
    attr_accessor :ui
  end
  
  autoload :Command,          'gitlab_cli/command'
  autoload :Config,           'gitlab_cli/config'
  autoload :Project,          'gitlab_cli/project'
  autoload :Snippet,          'gitlab_cli/snippet'
  autoload :User,             'gitlab_cli/user'
  autoload :UI,               'gitlab_cli/ui'
  autoload :Util,             'gitlab_cli/util'
  autoload :Version,          'gitlab_cli/version'

  GitlabCli.ui = GitlabCli::UI::Color.new

  CONFIG_PATH = '~/.gitlab.yml'
  config = File.expand_path(CONFIG_PATH)
  unless File.exist?(config)
    File.open(File.expand_path(File.dirname(__FILE__) + "/../config.yml.sample", "r") )do |sample|
      puts "Create a '#{CONFIG_PATH}' as following sample config"
      puts "=" * 40
      while (line = sample.gets)
        puts line
      end
      puts "=" * 40
    end
    exit(-1)
  end
  GitlabCli::Config.load(config)

  # 3rd Party Gems
  autoload :Shellwords,       'shellwords'
end
