module GitlabCli
  module Util
    class Snippet
      # Snippet - Get snippet object
      def self.get(project, snippet)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)

        begin 
          response = RestClient.get URI.join(GitlabCli::Config[:gitlab_url],"api/v3/projects/#{id}/snippets/#{snippet}#{GitlabCli::Util.url_token}").to_s
        rescue SocketError => e
          GitlabCli.ui.error "Could not contact the GitLab server. Please check connectivity and verify the 'gitlab_url' configuration setting."
          exit 1
        rescue Exception => e
          GitlabCli::Util.check_response_code(e.response)
        end
        data = JSON.parse(response)
        GitlabCli::Snippet.new(data['id'],data['title'],data['file_name'],data['expires_at'],data['updated_at'],data['created_at'],id,data['author'])
      end

      # Snippet - Create
      def self.create(project, title, file_name, code)
        ## Adapted from https://github.com/ripienaar/snipper/blob/master/lib/snipper/util.rb
        if STDIN.tty?
          if File.readable?(code)
            content = File.read(code)
          else
            GitlabCli.ui.error "Cannot read the specified file."
            exit 1
          end
        else
          content = STDIN.read
        end
        ##
        
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)

        url = "api/v3/projects/%s/snippets%s" % [id, GitlabCli::Util.url_token]
        payload = {:title => title, :file_name => file_name, :code => content}

        begin 
          response = RestClient.post URI.join(GitlabCli::Config[:gitlab_url],url).to_s, payload
        rescue SocketError => e
          GitlabCli.ui.error "Could not contact the GitLab server. Please check connectivity and verify the 'gitlab_url' configuration setting."
          exit 1
        rescue Exception => e
          GitlabCli::Util.check_response_code(e.response)
        end
        data = JSON.parse(response)
        GitlabCli::Snippet.new(data['id'],data['title'],data['file_name'],data['expires_at'],data['updated_at'],data['created_at'],id,data['author'])
      end

      # Snippet - View
      def self.view(project, snippet)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)

        url = "api/v3/projects/%s/snippets/%s/raw%s" % [id, snippet, GitlabCli::Util.url_token]

        begin 
          response = RestClient.get URI.join(GitlabCli::Config[:gitlab_url],url).to_s
        rescue SocketError => e
          GitlabCli.ui.error "Could not contact the GitLab server. Please check connectivity and verify the 'gitlab_url' configuration setting."
          exit 1
        rescue Exception => e
          GitlabCli::Util.check_response_code(e.response)
        end
      end
      
      # Snippet - Update 
      def self.update(project, snippet, content)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)

        url = "api/v3/projects/%s/snippets/%s%s" % [id, snippet.id, GitlabCli::Util.url_token]
        payload = {:title => snippet.title, :file_name => snippet.file_name, :code => content}

        begin 
          response = RestClient.put URI.join(GitlabCli::Config[:gitlab_url],url).to_s, payload
        rescue SocketError => e
          GitlabCli.ui.error "Could not contact the GitLab server. Please check connectivity and verify the 'gitlab_url' configuration setting."
          exit 1
        rescue Exception => e
          GitlabCli::Util.check_response_code(e.response)
        end

        data = JSON.parse(response)
        GitlabCli::Snippet.new(data['id'],data['title'],data['file_name'],data['expires_at'],data['updated_at'],data['created_at'],id,data['author'])
      end

      # Snippet - Delete
      def self.delete(project, snippet)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)

        snippet_get = get(project, snippet)
        
        if snippet_get
          begin 
            response = RestClient.delete URI.join(GitlabCli::Config[:gitlab_url],"api/v3/projects/#{id}/snippets/#{snippet}#{GitlabCli::Util.url_token}").to_s
          rescue SocketError => e
            GitlabCli.ui.error "Could not contact the GitLab server. Please check connectivity and verify the 'gitlab_url' configuration setting."
            exit 1
          rescue Exception => e
            GitlabCli::Util.check_response_code(e.response)
          end
        end
      end

      # /snippet - Download/Save
      def self.download(project, snippet, file_path)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)
        snippet_content = view(project, snippet)
        
        begin
          File.open(file_path, 'w') { |file| file.write(snippet_content) }
        rescue IOError => e
          GitlabCli.ui.error "Cannot save snippet as file. Please check permissions for %s" % [file_path]
          exit 1
        rescue Errno::ENOENT => e
          GitlabCli.ui.error "Specified directory does not exist.  Directory must exist to save the snippet file."
          exit 1
        end
      end
    end
  end
end
