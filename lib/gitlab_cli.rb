require 'yaml'

module GitlabCli
  autoload :Command,          'gitlab_cli/command'
  autoload :Config,           'gitlab_cli/config'
  autoload :Project,          'gitlab_cli/project'
  autoload :Snippet,          'gitlab_cli/snippet'
  autoload :User,             'gitlab_cli/user'
  autoload :Util,             'gitlab_cli/util'
  autoload :Version,          'gitlab_cli/version'

  config = File.expand_path('~/.gitlab.yml')
  GitlabCli::Config.load(config)

  # 3rd Party Gems
  autoload :Shellwords,       'shellwords'
end
