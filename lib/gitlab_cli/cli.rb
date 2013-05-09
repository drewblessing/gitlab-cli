require 'thor'
require 'gitlab_cli'

module GitlabCli
  class CLI < Thor
    desc "projects [OPTIONS]", "list projects"
    long_desc <<-D
      Get a list of projects.  List will only include projects for which you have at least view privileges.\n
    D
    option :nopager, :desc => "Turn OFF pager output one time for this command", :required => false, :type => :boolean
    option :pager, :desc => "Turn ON pager output one time for this command", :required => false, :type => :boolean
    def projects
      if options['pager'] && options['nopager']
        STDERR.puts "Cannot specify --nopager and --pager options together. Choose one."
        exit 1
      end

      projects = GitlabCli::Util::Projects.get_all
      formatted_projects = ""
      pager = ENV['pager'] || 'less'

      projects.each do |p|
        formatted_projects << "%s:\t%s\n" % [p.id, p.path_with_namespace]
      end
      
      if ((GitlabCli::Config[:display_results_in_pager] && !options['nopager']) || options['pager'])
        unless system("echo %s | %s" % [Shellwords.escape(formatted_projects), pager])
          STDERR.puts "Problem displaying projects in pager"
          exit 1
        end
      else 
        puts formatted_projects
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
      if options['pager'] && options['nopager']
        STDERR.puts "Cannot specify --nopager and --pager options together. Choose one."
        exit 1
      end

      snippets = GitlabCli::Util::Snippets.get_all(project)
      formatted_snippets = ""
      pager = ENV['pager'] || 'less'

      snippets.each do |s|
        formatted_snippets << "%s:\t%s - %s\n" % [s.id, s.title, s.file_name]
      end
      puts "This project does not have any snippets.\n" if snippets.size == 0

      if ((GitlabCli::Config[:display_results_in_pager] && !options['nopager']) || options['pager'])
        unless system("echo %s | %s" % [Shellwords.escape(formatted_snippets), pager])
          STDERR.puts "Problem displaying snippets in pager"
          exit 1
        end
      else 
        puts formatted_snippets
      end

    end

    desc "snippet [SUBCOMMAND]", "perform an action on a snippet"
    long_desc <<-D
      Perform an action on a snippet. To see available subcommands use 'gitlab snippet help.'
    D
    subcommand "snippet", GitlabCli::Command::Snippet

    desc "project [SUBCOMMAND]", "perform an action on a project"
    long_desc <<-D
      Perform an action on a project. To see available subcommands use 'gitlab project help.' 
    D
    subcommand "project", GitlabCli::Command::Project
  end
end
