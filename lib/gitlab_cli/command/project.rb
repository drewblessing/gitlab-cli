module GitlabCli
  module Command
    class Project < Thor
      class_option :verbose, :type => :boolean, :aliases => ['-v']

      def self.banner(task, namespace = true, subcommand = true)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end

      ## ADD
      desc "add [PROJECT_NAME] [OPTIONS]", "add a project"
      long_desc <<-D
        Add a project. The only required parameter is the project name
      D
      option :description, :desc => "The project's description", :type => :string, :aliases => ["-d"]
      option :branch, :desc => "The project's default branch", :type => :string, :aliases => ["-b"]
      option :issues, :desc => "Enable issues for the project", :type => :boolean
      option :wall, :desc => "Enable issues for the project", :type => :boolean
      option :merge_requests, :desc => "Enable merge_requests for the project", :type => :boolean
      option :wiki, :desc => "Enable wiki for the project", :type => :boolean
      def add(project_name)
        ui = GitlabCli.ui
        begin
          project = GitlabCli::Util::Project.create project, options['description'], options['branch'], options['public'], options['issues'], options['merge_requests'], options['wall'], options['wiki']
        
          ui.success "Project %s created successfully" % [project.name]
          ui.info "ID: %s" % [project.id]
          ui.info "URL: %s" % [project.project_url]
        rescue => e
          ui.error "Unable to create project \'%s\'" % [project_name]
          ui.handle_error e, options[:verbose]
        end
      end

      ## INFO
      desc "info [PROJECT]", "view detailed info for a project"
      long_desc <<-D
        View detailed information about a project.\n
        [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [PROJECT_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id.
      D
      def info(project)
        ui = GitlabCli.ui
        project = GitlabCli::Util::Project.get(project)

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
