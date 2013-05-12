module GitlabCli
  module Command
    class Project < Thor
      def self.banner(task, namespace = true, subcommand = true)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end

      ## INFO
      desc "info [PROJECT]", "view detailed info for a project"
      long_desc <<-D
        View detailed information about a project.\n
        [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [PROJECT_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id.
      D
      def info(project)
        project = GitlabCli::Util::Project.get(project)

        ui = GitlabCli.ui

        ui.info "Project ID: %s" % [project.id]
        ui.info "Name: %s" % [project.name]
        ui.info "Path w/ Namespace: %s" % [project.path_with_namespace]
        ui.info "Project URL: %s" % [project.project_url]
        ui.info "Description: %s" % [project.description.nil? || project.description.empty? ? "N/A" : project.description]
        ui.info "Default Branch: %s" % [project.default_branch.nil? ? "N/A" : project.default_branch]
        ui.info "Owner: %s <%s>" % [project.owner.name, project.owner.email]
        ui.info "Public?: %s" % [project.public.to_s]
        ui.info "Issues enabled?: %s" % [project.issues_enabled.to_s]
        ui.info "Merge Requests enabled?: %s" % [project.merge_requests_enabled.to_s]
        ui.info "Wall enabled?: %s" % [project.wall_enabled.to_s]
        ui.info "Wiki enabled?: %s" % [project.wiki_enabled.to_s]
        ui.info "Created at: %s" % [Time.parse(project.created_at)]
      end
    end
  end
end
