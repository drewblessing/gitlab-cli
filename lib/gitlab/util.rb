require 'json'

class Gitlab
  class Util

    ## Projects
    def self.projects
      gitlab = Gitlab.new
      begin 
        response = RestClient.get URI.join(Config[:gitlab_url],"api/v3/projects#{url_token}").to_s
      rescue Exception => e
        STDERR.puts "Could not get projects: #{e.class}: #{e}"
        raise
      end
      data = JSON.parse(response)
      projects = data.map do |p|
        Project.new(p['id'],p['name'],p['description'],p['default_branch'],p['public'],p['path'],p['path_with_namespace'],p['issues_enabled'],p['merge_requests_enabled'],p['wall_enabled'],p['wiki_enabled'],p['created_at'])
      end
    end

    ## Snippets
    def self.snippets(project)
      gitlab = Gitlab.new

      # Get project id
      id = numeric?(project) ? project : get_project_id(project)

      begin 
        response = RestClient.get URI.join(Config[:gitlab_url],"api/v3/projects/#{id}/snippets#{url_token}").to_s
      rescue Exception => e
        STDERR.puts "Could not get snippets: #{e.class}: #{e}"
        raise
      end
      data = JSON.parse(response)
      snippets = data.map do |s|
        Snippet.new(s['id'],s['title'],s['file_name'],s['expires_at'],s['updated_at'],s['created_at'],id)
      end
    end

    ## Snippet
    def self.snippet_get(project,snippet)
      gitlab = Gitlab.new

      # Get project id
      id = numeric?(project) ? project : get_project_id(project)

      begin 
        response = RestClient.get URI.join(Config[:gitlab_url],"api/v3/projects/#{id}/snippets/#{snippet}#{url_token}").to_s
      rescue Exception => e
        STDERR.puts "Could not get snippet"
        raise
      end
      data = JSON.parse(response)
      Snippet.new(data['id'],data['title'],data['file_name'],data['expires_at'],data['updated_at'],data['created_at'],id)
    end

    def self.snippet_create(project, title, file_name, code)
      gitlab = Gitlab.new

      ## From https://github.com/ripienaar/snipper/blob/master/lib/snipper/util.rb
      if STDIN.tty?
        # Should check if stuff is kosher

        content = File.read(code)
      else
        content = STDIN.read
      end
      ##
      
      # Get project id
      id = numeric?(project) ? project : get_project_id(project)
      url = "api/v3/projects/%s/snippets%s" % [id, url_token]
      payload = {:title => title, :file_name => file_name, :code => content}

      begin 
        response = RestClient.post URI.join(Config[:gitlab_url],url).to_s, payload
      rescue Exception => e
        STDERR.puts "Could not get snippet: #{e.class}: #{e}"
        raise
      end
      data = JSON.parse(response)
      Snippet.new(data['id'],data['title'],data['file_name'],data['expires_at'],data['updated_at'],data['created_at'],id)
    end

    def self.snippet_view(project, snippet_id)
      gitlab = Gitlab.new

      # Get project id
      id = numeric?(project) ? project : get_project_id(project)
      url = "api/v3/projects/%s/snippets/%s/raw%s" % [id, snippet_id, url_token]

      begin 
        response = RestClient.get URI.join(Config[:gitlab_url],url).to_s
      rescue Exception => e
        STDERR.puts "Could not get snippet: #{e.class}: #{e}"
        raise
      end
    end

    def self.snippet_update(project, snippet, content)
      gitlab = Gitlab.new

      # Get project id
      id = numeric?(project) ? project : get_project_id(project)
      url = "api/v3/projects/%s/snippets/%s%s" % [id, snippet.id, url_token]
      payload = {:title => snippet.title, :file_name => snippet.file_name, :code => content}

      begin 
        response = RestClient.put URI.join(Config[:gitlab_url],url).to_s, payload

      rescue Exception => e
        STDERR.puts "Could not update snippet."
        raise
      end
      data = JSON.parse(response)
      Snippet.new(data['id'],data['title'],data['file_name'],data['expires_at'],data['updated_at'],data['created_at'],id)
    end

    def self.snippet_delete(project, snippet)
      gitlab = Gitlab.new

      # Get project id
      id = numeric?(project) ? project : get_project_id(project)
      
      begin
        snippet_get = snippet_get(project, snippet)
      rescue RestClient::ResourceNotFound => e
        STDERR.puts "Snippet does not exist.  Cannot delete."
      end

      if snippet_get
        begin 
          response = RestClient.delete URI.join(Config[:gitlab_url],"api/v3/projects/#{id}/snippets/#{snippet}#{url_token}").to_s
        rescue Exception => e
          STDERR.puts "Could not delete snippet."
          raise
        end
      end
    end

    def self.get_project_with_namespace(project_id)
      projects = self.projects
      projects.each do |p|
        # Return id of matching project. Return statement must be used for proper return here.
        return p.path_with_namespace if p.id.to_i == project_id.to_i
      end
    end

    ## Internal methods
    private
    def self.get_project_id(project)
      projects = self.projects
      projects.each do |p|
        # Return id of matching project. Return statement must be used for proper return here.
        return p.id if p.path_with_namespace == project
      end
    end

    private
    def self.url_token
      "?private_token=#{Config[:private_token]}"
    end

    private
    def self.numeric?(string)
      Float(string) != nil rescue false
    end
  end
end
