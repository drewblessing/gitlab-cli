module GitlabCli
  module Util
    class Projects
      def self.get_all
        begin 
          response = Array.new
          page = 1
          while true do
            url = "api/v3/projects%s&page=%s&per_page=100" % [GitlabCli::Util.url_token, page]
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

        projects = response.map do |p|
          GitlabCli::Project.new(p['id'],p['name'],p['description'],p['default_branch'],p['public'],p['path'],p['path_with_namespace'],p['issues_enabled'],p['merge_requests_enabled'],p['wall_enabled'],p['wiki_enabled'],p['created_at'],p['owner'])
        end
      end
    end
  end
end

