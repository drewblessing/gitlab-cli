module GitlabCli
  module Util
    class Project
      # Get
      def self.get(project)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)
        url = "projects/%s" % [id]

        begin
          response = GitlabCli::Util.rest "get", url

        rescue Exception => e
          raise e

        else
          data = JSON.parse(response)
          GitlabCli::Project.new(data['id'],data['name'],data['description'],data['default_branch'],data['public'],data['path'],data['path_with_namespace'],data['issues_enabled'],data['merge_requests_enabled'],data['wall_enabled'],data['wiki_enabled'],data['created_at'],data['owner'])

        end
      end

      # Create
      def self.create(name, description, branch, issues, merge_requests, wall, wiki, snippets)
        payload = {
          :name                     => name, 
          :description              => description, 
          :default_branch           => branch,
          :issues_enabled           => issues,
          :merge_requests_enabled   => merge_requests, 
          :wall_enabled             => wall,
          :wiki_enabled             => wiki,
          #:snippets_enabled         => snippets,
        }

        begin
          response = GitlabCli::Util.rest "post", "projects", payload

        rescue Exception => e
          raise e

        else
          data = JSON.parse(response)
          GitlabCli::Project.new(data['id'],data['name'],data['description'],data['default_branch'],data['public'],data['path'],data['path_with_namespace'],data['issues_enabled'],data['merge_requests_enabled'],data['wall_enabled'],data['wiki_enabled'],data['created_at'],data['owner'])

        end
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
