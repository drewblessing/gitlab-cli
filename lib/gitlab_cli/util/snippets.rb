module GitlabCli
  module Util
    class Snippets
      def self.get_all(project)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)

        begin 
          response = Array.new
          page = 1
          while true do
            url = "api/v3/projects/%s/snippets%s&page=%s&per_page=100" % [id, GitlabCli::Util.url_token, page]
            page_data = RestClient.get URI.join(GitlabCli::Config[:gitlab_url],url).to_s
            # Length of 2 indicates empty Array (represented as a string)
            break if page_data.length == 2         
            response.concat JSON.parse(page_data)
            page += 1
          end
        rescue SocketError => e
          GitlabCli.ui.error "Could not contact the GitLab server. Please check connectivity and verify the 'gitlab_url' configuration setting."
          exit 1
        rescue Exception => e
          GitlabCli::Util.check_response_code(e.response)
        end

        snippets = response.map do |s|
          GitlabCli::Snippet.new(s['id'],s['title'],s['file_name'],s['expires_at'],s['updated_at'],s['created_at'],id,s['author'])
        end
      end
    end
  end
end
