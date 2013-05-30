require 'thor'
require 'gitlab_cli'
require 'gitlab_cli/version'

module GitlabCli
  class CLI < Thor
    map "-v" => "version" 
    map "--version" => "version"

    desc "version", "print version"
    long_desc <<-D
      Print the Gitlab CLI tool version
    D
    def version
      GitlabCli.ui.info "Gitlab CLI version %s" % [GitlabCli::VERSION]
    end

    desc "projects [OPTIONS]", "list projects"
    long_desc <<-D
      Get a list of projects. \n
    D
    option :nopager, :desc => "Turn OFF pager output one time for this command", :required => false, :type => :boolean
    option :pager, :desc => "Turn ON pager output one time for this command", :required => false, :type => :boolean
    def projects
      ui = GitlabCli.ui
      begin
        raise "Cannot specify --nopager and --pager options together. Choose one." if options['pager'] && options['nopager']

        projects = GitlabCli::Util::Projects.get_all
        formatted_projects = ""
        pager = ENV['pager'] || 'less'

        projects.each do |p|
          formatted_projects << "%s:\t%s\n" % [p.id, p.path_with_namespace]
        end
    
      rescue Exception => e
        ui.error "Unable to get snippets"
        ui.handle_error e

      else
        if ((GitlabCli::Config[:display_results_in_pager] && !options['nopager']) || options['pager'])
          unless system("echo %s | %s" % [Shellwords.escape(formatted_projects), pager])
            raise "Problem displaying projects in pager"
          end
        else 
          ui.info formatted_projects
        end
      end
    end

    desc "snippets [PROJECT] [OPTIONS]", "list snippets for a project"
    long_desc <<-D
      Get a list of snippets for a particular project. \n
      
      [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [PROJECT_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id.\n
    D
    option :nopager, :desc => "Turn OFF pager output one time for this command", :required => false, :type => :boolean
    option :pager, :desc => "Turn ON pager output one time for this command", :required => false, :type => :boolean
    def snippets(project)
      ui = GitlabCli.ui
      begin
        raise "Cannot specify --nopager and --pager options together. Choose one." if options['pager'] && options['nopager']

        snippets = GitlabCli::Util::Snippets.get_all(project)
        formatted_snippets = ""
        pager = ENV['pager'] || 'less'
  
        snippets.each do |s|
          formatted_snippets << "%s:\t%s - %s\n" % [s.id, s.title, s.file_name]
        end

      rescue ResponseCodeException => e
        case e.response_code
        when 404
          ui.error "Unable to get snippets"
          ui.error "Cannot find project with name or ID \"%s\"" % [project]

        else
          ui.error "Unable to get snippets"
          ui.handle_error e
          
        end

      rescue Exception => e
        ui.error "Unable to get snippets"
        ui.handle_error e

      else
        if snippets.size == 0
          ui.info "This project does not have any snippets.\n"
  
        else
          if ((GitlabCli::Config[:display_results_in_pager] && !options['nopager']) || options['pager'])
            unless system("echo %s | %s" % [Shellwords.escape(formatted_snippets), pager])
              raise "Problem displaying snippets in pager"
            end

          else 
            ui.info formatted_snippets

          end
        end
      end
    end

    desc "groups [OPTIONS]", "list groups"
    long_desc <<-D
      Get a list of groups. \n
    D
    option :nopager, :desc => "Turn OFF pager output one time for this command", :required => false, :type => :boolean
    option :pager, :desc => "Turn ON pager output one time for this command", :required => false, :type => :boolean
    def groups
      ui = GitlabCli.ui
      begin
        raise "Cannot specify --nopager and --pager options together. Choose one." if options['pager'] && options['nopager']

        groups = GitlabCli::Util::Groups.get_all
        formatted_groups = ""
        pager = ENV['pager'] || 'less'

        groups.each do |g|
          formatted_groups << "%s:\t%s\n" % [g.id, g.name]
        end
      
      rescue Exception => e
        ui.error "Unable to get groups"
        ui.handle_error e

      else
        if groups.size == 0
          ui.info "There are no groups"

        else
          if ((GitlabCli::Config[:display_results_in_pager] && !options['nopager']) || options['pager'])
            unless system("echo %s | %s" % [Shellwords.escape(formatted_groups), pager])
              raise "Problem displaying groups in pager"
            end

          else 
            ui.info formatted_groups

          end
        end
      end
    end

    desc "users [OPTIONS]", "list users"
    long_desc <<-D
      Get a list of users.\n
    D
    option :nopager, :desc => "Turn OFF pager output one time for this command", :required => false, :type => :boolean
    option :pager, :desc => "Turn ON pager output one time for this command", :required => false, :type => :boolean
    def users
      ui = GitlabCli.ui
      begin
        raise "Cannot specify --nopager and --pager options together. Choose one." if options['pager'] && options['nopager']

        users = GitlabCli::Util::Users.get_all
        formatted_users = ""
        pager = ENV['pager'] || 'less'

        users.each do |u|
          formatted_users << "%s:\t%s <%s>\n" % [u.id, u.name, u.email]
        end
      
      rescue Exception => e
        ui.error "Unable to get users"
        ui.handle_error e

      else
        if users.size == 0
          ui.info "There are no users"

        else
          if ((GitlabCli::Config[:display_results_in_pager] && !options['nopager']) || options['pager'])
            unless system("echo %s | %s" % [Shellwords.escape(formatted_users), pager])
              raise "Problem displaying users in pager"
            end

          else 
            ui.info formatted_users

          end
        end
      end
    end

    desc "group [SUBCOMMAND]", "perform an action on a group"
    long_desc <<-D
      Perform an action on a group. To see available subcommands use 'gitlab group help.' 
    D
    subcommand "group", GitlabCli::Command::Group

    desc "project [SUBCOMMAND]", "perform an action on a project"
    long_desc <<-D
      Perform an action on a project. To see available subcommands use 'gitlab project help.' 
    D
    subcommand "project", GitlabCli::Command::Project

    desc "snippet [SUBCOMMAND]", "perform an action on a snippet"
    long_desc <<-D
      Perform an action on a snippet. To see available subcommands use 'gitlab snippet help.'
    D
    subcommand "snippet", GitlabCli::Command::Snippet
    
    desc "user [SUBCOMMAND]", "perform an action on a user"
    long_desc <<-D
      Perform an action on a user. To see available subcommands use 'gitlab user help.'
    D
    subcommand "user", GitlabCli::Command::User
  end
end
