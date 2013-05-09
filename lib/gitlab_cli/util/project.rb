module GitlabCli
  module Util
    class Snippet
      # Get project object
      def self.project_get(project)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)
        url = "api/v3/projects/%s%s" % [id,GitlabCli::Util.url_token]

        begin
          response = RestClient.get URI.join(GitlabCli::Config[:gitlab_url],url).to_s
        rescue SocketError => e
          STDERR.puts "Could not contact the GitLab server. Please check connectivity and verify the 'gitlab_url' configuration setting."
          exit 1
        rescue Exception => e
          GitlabCli::Util.check_response_code(e.response)
        end

        data = JSON.parse(response)
        GitlabCli::Project.new(data['id'],data['name'],data['description'],data['default_branch'],data['public'],data['path'],data['path_with_namespace'],data['issues_enabled'],data['merge_requests_enabled'],data['wall_enabled'],data['wiki_enabled'],data['created_at'],data['owner'])
      end
    end
  end
end
