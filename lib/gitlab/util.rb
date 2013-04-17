require 'json'

class Gitlab
  class Util

    ## Projects
    def self.projects
      gitlab = Gitlab.new
      begin 
        response = RestClient.get URI.join(Config[:gitlab_url],"api/v3/projects#{url_token}").to_s
      rescue Exception => e
        check_response_code(e.response)
      end

      data = JSON.parse(response)
      projects = data.map do |p|
        Project.new(p['id'],p['name'],p['description'],p['default_branch'],p['public'],p['path'],p['path_with_namespace'],p['issues_enabled'],p['merge_requests_enabled'],p['wall_enabled'],p['wiki_enabled'],p['created_at'])
      end
    end

    ## Snippets
    def self.snippets(project)
      gitlab = Gitlab.new

      id = numeric?(project) ? project : get_project_id(project)

      begin 
        response = RestClient.get URI.join(Config[:gitlab_url],"api/v3/projects/#{id}/snippets#{url_token}").to_s
      rescue Exception => e
        check_response_code(e.response)
      end

      data = JSON.parse(response)
      snippets = data.map do |s|
        Snippet.new(s['id'],s['title'],s['file_name'],s['expires_at'],s['updated_at'],s['created_at'],id)
      end
    end

    ## Snippet
    # Snippet - Get snippet object
    def self.snippet_get(project, snippet)
      gitlab = Gitlab.new

      id = numeric?(project) ? project : get_project_id(project)

      begin 
        response = RestClient.get URI.join(Config[:gitlab_url],"api/v3/projects/#{id}/snippets/#{snippet}#{url_token}").to_s
      rescue Exception => e
        check_response_code(e.response)
      end
      data = JSON.parse(response)
      Snippet.new(data['id'],data['title'],data['file_name'],data['expires_at'],data['updated_at'],data['created_at'],id)
    end

    # Snippet - Create
    def self.snippet_create(project, title, file_name, code)
      gitlab = Gitlab.new

      ## Adapted from https://github.com/ripienaar/snipper/blob/master/lib/snipper/util.rb
      if STDIN.tty?
        if File.readable?(code)
          content = File.read(code)
        else
          STDERR.puts "Cannot read the specified file."
          exit 1
        end
      else
        content = STDIN.read
      end
      ##
      
      id = numeric?(project) ? project : get_project_id(project)

      url = "api/v3/projects/%s/snippets%s" % [id, url_token]
      payload = {:title => title, :file_name => file_name, :code => content}

      begin 
        response = RestClient.post URI.join(Config[:gitlab_url],url).to_s, payload
      rescue Exception => e
        check_response_code(e.response)
      end
      data = JSON.parse(response)
      Snippet.new(data['id'],data['title'],data['file_name'],data['expires_at'],data['updated_at'],data['created_at'],id)
    end

    # Snippet - View
    def self.snippet_view(project, snippet_id)
      gitlab = Gitlab.new

      id = numeric?(project) ? project : get_project_id(project)

      url = "api/v3/projects/%s/snippets/%s/raw%s" % [id, snippet_id, url_token]

      begin 
        response = RestClient.get URI.join(Config[:gitlab_url],url).to_s
      rescue Exception => e
        check_response_code(e.response)
      end
    end
    
    # Snippet - Update 
    def self.snippet_update(project, snippet, content)
      gitlab = Gitlab.new

      id = numeric?(project) ? project : get_project_id(project)

      url = "api/v3/projects/%s/snippets/%s%s" % [id, snippet.id, url_token]
      payload = {:title => snippet.title, :file_name => snippet.file_name, :code => content}

      begin 
        response = RestClient.put URI.join(Config[:gitlab_url],url).to_s, payload
      rescue Exception => e
        check_response_code(e.response)
      end

      data = JSON.parse(response)
      Snippet.new(data['id'],data['title'],data['file_name'],data['expires_at'],data['updated_at'],data['created_at'],id)
    end

    # Snippet - Delete
    def self.snippet_delete(project, snippet)
      gitlab = Gitlab.new

      id = numeric?(project) ? project : get_project_id(project)
      
      begin
        snippet_get = snippet_get(project, snippet)
      rescue Exception => e
        check_response_code(e.response)
      end

      if snippet_get
        begin 
          response = RestClient.delete URI.join(Config[:gitlab_url],"api/v3/projects/#{id}/snippets/#{snippet}#{url_token}").to_s
        rescue Exception => e
          check_response_code(e.response)
        end
      end
    end

    # Get a project's path with namespace
    def self.get_project_path_with_namespace(project_id)
      projects = self.projects
      projects.each do |p|
        # Return id of matching project. Return statement must be used for proper return here.
        return p.path_with_namespace if p.id.to_i == project_id.to_i
      end
    end

    ## Internal methods
    # Get project id
    private
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
    private
    def self.url_token
      "?private_token=#{Config[:private_token]}"
    end

    private
    def self.numeric?(string)
      Float(string) != nil rescue false
    end

    # Check RestClient response code
    private
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
