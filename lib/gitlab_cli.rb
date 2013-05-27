require 'yaml'

module GitlabCli
  class << self
    attr_accessor :ui
  end
  
  autoload :Command,                  'gitlab_cli/command'
  autoload :Config,                   'gitlab_cli/config'
  autoload :Group,                    'gitlab_cli/group'
  autoload :Project,                  'gitlab_cli/project'
  autoload :ResponseCodeException,    'gitlab_cli/exception/response_code_exception'
  autoload :Snippet,                  'gitlab_cli/snippet'
  autoload :User,                     'gitlab_cli/user'
  autoload :UI,                       'gitlab_cli/ui'
  autoload :Util,                     'gitlab_cli/util'
  autoload :Version,                  'gitlab_cli/version'

  GitlabCli.ui = STDOUT.tty? ? GitlabCli::UI::Color.new : GitlabCli::UI::Basic.new

  CONFIG_PATH = '~/.gitlab.yml'
  config = File.expand_path(CONFIG_PATH)
  unless File.exist?(config)
    File.open(File.expand_path(File.dirname(__FILE__) + "/../config.yml.sample", "r") )do |sample|
      GitlabCli.ui.error "Could not find a config file. Create a config file, '#{CONFIG_PATH}', from the following sample config"
      GitlabCli.ui.error "=" * 15 + " BEGIN (Do not copy this line) " + "=" * 15, :cyan
      while (line = sample.gets)
        GitlabCli.ui.error line, :white, false
      end
      GitlabCli.ui.error "=" * 15 + " END (Do not copy this line) " + "=" * 15, :cyan
    end
    exit(-1)
  end
  GitlabCli::Config.load(config)

  # 3rd Party Gems
  autoload :Shellwords,       'shellwords'
end
