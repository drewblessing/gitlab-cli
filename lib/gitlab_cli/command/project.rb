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
        project = GitlabCli::Util.project_get(project)

        printf "Project ID: %s\n", project.id
        printf "Name: %s\n", project.name
        printf "Path w/ Namespace: %s\n", project.path_with_namespace
        printf "Project URL: %s\n", project.project_url
        printf "Description: %s\n", project.description.nil? || project.description.empty? ? "N/A" : project.description
        printf "Default Branch: %s\n", project.default_branch.nil? ? "N/A" : project.default_branch
        printf "Owner: %s <%s>\n", project.owner.name, project.owner.email
        printf "Public?: %s\n", project.public.to_s
        printf "Issues enabled?: %s\n", project.issues_enabled.to_s
        printf "Merge Requests enabled?: %s\n", project.merge_requests_enabled.to_s
        printf "Wall enabled?: %s\n", project.wall_enabled.to_s
        printf "Wiki enabled?: %s\n", project.wiki_enabled.to_s
        printf "Created at: %s\n", Time.parse(project.created_at)
      end
    end
  end
end
