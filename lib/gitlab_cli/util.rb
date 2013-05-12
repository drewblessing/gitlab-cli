module GitlabCli
  module Util
    autoload :Projects,      'gitlab_cli/util/projects'
    autoload :Snippets,      'gitlab_cli/util/snippets'
    autoload :Project,       'gitlab_cli/util/project'
    autoload :Snippet,       'gitlab_cli/util/snippet'

    autoload :RestClient,    'rest-client'
    autoload :JSON,          'json'

    ## Internal methods
    # Get project id
    def self.get_project_id(project)
      projects = GitlabCli::Util::Projects.get_all
      project = projects.detect do |p|
        p.path_with_namespace == project
      end
      
      unless project
        GitlabCli.ui.error "Invalid project name or id."
        exit 1
      end
      project.id
    end

    # Construct private token for URL
    def self.url_token
      "?private_token=#{GitlabCli::Config[:private_token]}"
    end

    def self.numeric?(string)
      Float(string) != nil rescue false
    end

    # Check RestClient response code
    def self.check_response_code(response)
      if response =~ /401/
        ## Unauthorized
        GitlabCli.ui.error "User token was not present or is not valid."
        exit 1
      elsif response =~ /403/
        ## Forbidden
        GitlabCli.ui.error "You are not authorized to complete this action"
        exit 1
      elsif response =~ /404/
        ## Not found
        GitlabCli.ui.error "Resource could not be found."
        exit 1
      elsif response =~ /405/
        ## Method not allowed
        GitlabCli.ui.error "This request is not supported."
        exit 1
      elsif response =~ /409/
        ## Conflicting resource
        GitlabCli.ui.error "A conflicting resource already exists."
        exit 1
      elsif response =~ /500/
        ## Server error
        GitlabCli.ui.error "Oops.  Something went wrong. Please try again."
      end
      response
    end
  end
end
