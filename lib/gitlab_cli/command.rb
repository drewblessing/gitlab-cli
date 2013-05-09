module GitlabCli
  module Command
    autoload :Project,             'gitlab_cli/command/project'
    autoload :Snippet,             'gitlab_cli/command/snippet'

    autoload :Time,                'time'
  end
end

