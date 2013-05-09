require 'json'
require 'rest-client'

module GitlabCli
  module Util
    autoload :Projects,      'gitlab_cli/util/projects'
    autoload :Snippets,      'gitlab_cli/util/snippets'
    autoload :Project,       'gitlab_cli/util/project'
    autoload :Snippet,       'gitlab_cli/util/snippet'

    ## Internal methods
    # Get project id
    def self.get_project_id(project)
      projects = self.projects
      project = projects.detect do |p|
        p.path_with_namespace == project
      end
      
      unless project
        STDERR.puts "Invalid project name or id."
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
        STDERR.puts "User token was not present or is not valid."
        exit 1
      elsif response =~ /403/
        ## Forbidden
        STDERR.puts "You are not authorized to complete this action"
        exit 1
      elsif response =~ /404/
        ## Not found
        STDERR.puts "Resource could not be found."
        exit 1
      elsif response =~ /405/
        ## Method not allowed
        STDERR.puts "This request is not supported."
        exit 1
      elsif response =~ /409/
        ## Conflicting resource
        STDERR.puts "A conflicting resource already exists."
        exit 1
      elsif response =~ /500/
        ## Server error
        STDERR.puts "Oops.  Something went wrong. Please try again."
      end
      response
    end
  end
end
