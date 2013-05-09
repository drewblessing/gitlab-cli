module GitlabCli
  module Util
    class Project
      # Get project object
      def self.get(project)
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

      # Get a project's path with namespace
      def self.get_project_path_with_namespace(project_id)
        projects = GitlabCli::Util::Projects.get_all
        projects.each do |p|
          # Return id of matching project. Return statement must be used for proper return here.
          return p.path_with_namespace if p.id.to_i == project_id.to_i
        end
      end
    end
  end
end
