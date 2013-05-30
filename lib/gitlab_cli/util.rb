module GitlabCli
  module Util
    autoload :Groups,        'gitlab_cli/util/groups'
    autoload :Projects,      'gitlab_cli/util/projects'
    autoload :Snippets,      'gitlab_cli/util/snippets'
    autoload :Users,         'gitlab_cli/util/users'
    autoload :Group,         'gitlab_cli/util/group'
    autoload :Project,       'gitlab_cli/util/project'
    autoload :Snippet,       'gitlab_cli/util/snippet'
    autoload :User,          'gitlab_cli/util/user'

    autoload :RestClient,    'rest-client'
    autoload :JSON,          'json'
    autoload :URI,           'uri'

    ## Internal methods
    # Rest Call
    def self.rest(method, url, payload=nil)
      endpoint = url_with_token(url)
      full_url = URI.join(GitlabCli::Config[:gitlab_url], endpoint).to_s

      begin
        case method
        when "post"
          response = RestClient.post full_url, payload   
        when "get"
          response = RestClient.get full_url
        when "put"
          response = RestClient.put full_url, payload
        when "delete"
          response = RestClient.delete full_url
        end

      rescue SocketError => e
        raise "Could not find the Gitlab server. Please check DNS and verify the 'gitlab_url' configuration setting"
      
      rescue RestClient::BadGateway => e
        raise "Could not contact the Gitlab server.  Please check that Gitlab server is running, firewalls are not blocking the connection, and verify the 'gitlab_url' configuration setting"

      rescue Exception => e
        if e.response
          resp = check_response_code(e.response)
          raise e 
        else
          raise e
        end
      end
    end

    # Get project id
    def self.get_project_id(project_name)
      projects = GitlabCli::Util::Projects.get_all
      project = projects.detect do |p|
        p.path_with_namespace == project_name
      end
      
      unless project
        raise "Cannot find project with name \"%s\"" % [project_name]
      end
      project.id
    end

    # Construct URL with private token
    # Detect if URL already contains parameters.
    # If so, use an asterisk instead of a question
    def self.url_with_token(url)
      params = url.include? "?"
      char = params ? "&" : "?"
      token = "private_token=#{GitlabCli::Config[:private_token]}"
      "api/v3/%s%s%s" % [url, char, token]
    end

    def self.numeric?(string)
      Float(string) != nil rescue false
    end

    # Check RestClient response code
    def self.check_response_code(response)
      case response
      when /400/
        ## Bad request
        raise "Bad Request. This shouldn't happen. Please file a bug and describe exactly what command you ran to get this error. Include Gitlab version and Gitlab CLI version."
      when /401/
        ## Unauthorized
        raise "User token was not present or is not valid."
      when /403/
        ## Forbidden
        raise "You are not authorized to complete this action"
      when /404/
        ## Not found
        raise ResponseCodeException.new(404), "Resource could not be found"
        #raise "Resource could not be found."
      when /405/
        ## Method not allowed
        raise "This request is not supported."
      when /409/
        ## Conflicting resource
        raise "A conflicting resource already exists."
      when /500/
        ## Server error
        raise "Oops.  Something went wrong. Please try again."
      end
    end
  end
end
