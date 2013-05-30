require 'digest'

module GitlabCli
  module Command
    class Snippet < Thor
      map "save" => "download"

      def self.banner(task, namespace = true, subcommand = true)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end
      
      # ADD
      desc "add [PROJECT] [FILE] [OPTIONS]", "add a snippet"
      long_desc <<-D
        Add a snippet to a project.  You may specify a file to create a snippet from or you may pipe content from cat.
        [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [PROJECT_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id.
       
        $ gitlab snippet add namespace/project file1.txt

        $ cat file1.txt | gitlab snippet add namespace/project
      D
      option :title, :desc => "The title to use for the new snippet", :required => true, :type => :string, :aliases => ["-t"]
      option :file_name, :desc => "A file name for this snippet", :required => true, :type => :string, :aliases => ["-n", "-f"]  
      def add(project, file=nil)
        ui = GitlabCli.ui
        begin
          snippet = GitlabCli::Util::Snippet.create(project, options['title'], options['file_name'], file)

        rescue Exception => e
          ui.error "Unable to add snippet"
          ui.handle_error e

        else
          ui.success "Snippet created."
          ui.info "ID: %s" % [snippet.id]
          ui.info "URL: %s" % [snippet.view_url]
        end
      end 

      ## VIEW
      desc "view [PROJECT] [SNIPPET_ID]", "view a snippet"
      long_desc <<-D
        View the content of a snippet. Content will be displayed in the default pager or in "less."

        [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [PROJECT_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id. [SNIPPET_ID] must be specified as the id of the snippet.  Use 'gitlab snippets [PROJECT]' command to view the snippets available for a project.

        $ gitlab snippet view namespace/project 6

        $ gitlab snippet view 10 6
      D
      def view(project, snippet)
        ui = GitlabCli.ui
        begin
          snippet = GitlabCli::Util::Snippet.view(project, snippet)    

        rescue ResponseCodeException => e
          case e.response_code
          when 404
            ui.error "Unable to view snippet"
            ui.error "Ensure project and snippet exist."
          else
            ui.error "Unable to view snippet"
            ui.handle_error e
          end

        rescue Exception => e
          ui.error "Unable to view snippet"
          ui.handle_error e

        else
          pager = ENV['pager'] || 'less'

          unless system("echo %s | %s" % [Shellwords.escape(snippet), pager])
            ui.error "Problem displaying snippet"
          end
        end
      end

      ## EDIT
      desc "edit [PROJECT] [SNIPPET_ID]", "edit a snippet"
      long_desc <<-D
        Edit a snippet. Snippet will open in your default text editor or in "vi." 

        [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [PROJECT_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id. [SNIPPET_ID] must be specified as the id of the snippet.  Use 'gitlab snippets [PROJECT]' command to view the snippets available for a project.

        $ gitlab snippet edit namespace/project 6

        $ gitlab snippet edit 10 6
      D
      def edit(project, snippet)
        ui = GitlabCli.ui
        begin
          snippet_obj = GitlabCli::Util::Snippet.get(project, snippet)
          snippet_code = GitlabCli::Util::Snippet.view(project, snippet)

        rescue ResponseCodeException => e
          case e.response_code
          when 404
            ui.error "Unable to edit snippet"
            ui.error "Ensure project and snippet exist."
          else
            ui.error "Unable to edit snippet"
            ui.handle_error e
          end

        rescue Exception => e
          ui.error "Unable to edit snippet"
          ui.handle_error e

        else
          editor = ENV['editor'] || 'vi'

          temp_file_path = "/tmp/snippet.%s" % [rand]
          File.open(temp_file_path, 'w') do |file| 
            file.write(snippet_code) 
          end
          pre_digest = Digest::MD5.digest(File.read(temp_file_path))

          unless system("vi %s" % [temp_file_path])
            ui.error "Could not open system editor"
          end

          snippet_code = File.read(temp_file_path)
          post_digest = Digest::MD5.digest(snippet_code)
          File.delete(temp_file_path)

          if pre_digest == post_digest
            ui.info "Snippet was not updated. You quit without saving."
          else
            snippet = GitlabCli::Util::Snippet.update(project, snippet_obj, snippet_code)
            ui.success "Snippet updated."
            ui.info "URL: %s" % [snippet.view_url]
          end
        end
      end

      ## DELETE
      desc "delete [PROJECT] [SNIPPET_ID]", "delete a snippet"
      long_desc <<-D
        Delete a snippet. \n
        [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [PROJECT_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id. [SNIPPET_ID] must be specified as the id of the snippet.  Use 'gitlab snippets [PROJECT]' command to view the snippets available for a project.

        $ gitlab snippet delete namespace/project 6

        $ gitlab snippet delete 10 6
      D
       option :yes, :desc => "Delete without asking for confirmation", :required => false, :type => :boolean, :aliases => ["-y"]  
      def delete(project, snippet)
        ui = GitlabCli.ui
        begin
          response = GitlabCli.ui.yes? "Are you sure you want to delete this snippet? (Yes\\No)" unless options['yes']
          exit unless options['yes'] || response

          snippet = GitlabCli::Util::Snippet.delete(project, snippet)

        rescue ResponseCodeException => e
          case e.response_code
          when 404
            ui.error "Unable to delete snippet"
            ui.error "Ensure project and snippet exist."
          else
            ui.error "Unable to delete snippet"
            ui.handle_error e
          end

        rescue Exception => e
          ui.error "Unable to delete snippet"
          ui.handle_error e

        else
          ui.success "Successfully deleted the snippet."
        end
      end

      ## INFO
      desc "info [PROJECT] [SNIPPET_ID]", "view detailed info for a snippet"
      long_desc <<-D
        View detailed information about a snippet.\n
        [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [PROJECT_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id. [SNIPPET_ID] must be specified as the id of the snippet.  Use 'gitlab snippets [PROJECT]' command to view the snippets available for a project.
      D
      def info(project, snippet)
        ui = GitlabCli.ui
        begin
          snippet = GitlabCli::Util::Snippet.get(project, snippet)

        rescue ResponseCodeException => e
          case e.response_code
          when 404
            ui.error "Unable to view info for snippet"
            ui.error "Ensure project and snippet exist."
          else
            ui.error "Unable to view info for snippet"
            ui.handle_error e
          end

        rescue Exception => e
          ui.error "Unable to view info for snippet"
          ui.handle_error e

        else
          ui.info "Snippet ID: %s" % [snippet.id]
          ui.info "Title: %s" % [snippet.title]
          ui.info "File Name: %s" % [snippet.file_name]
          ui.info "Author: %s <%s>" % [snippet.author.name, snippet.author.email]
          ui.info "Created at: %s" % [Time.parse(snippet.created_at)]
          ui.info "Updated at: %s" % [Time.parse(snippet.updated_at)]
          ui.info "Expires at: %s" % [snippet.expires_at.nil? ? "Never" : Time.parse(snippet.expires_at)]
        end
      end

      ## DOWNLOAD
      desc "download|save [PROJECT] [SNIPPET_ID] [FILE]", "download/save a snippet locally"
      long_desc <<-D
        Download/Save the contents of a snippet in a local file\n
        [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [PROJECT_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id. [SNIPPET_ID] must be specified as the id of the snippet.  Use 'gitlab snippets [PROJECT]' command to view the snippets available for a project.
      D
      def download(project, snippet, file_path)
        ui = GitlabCli.ui
        begin
          snippet = GitlabCli::Util::Snippet.download(project, snippet, file_path)

        rescue ResponseCodeException => e
          case e.response_code
          when 404
            ui.error "Unable to download snippet"
            ui.error "Ensure project and snippet exist"
          else
            ui.error "Unable to download snippet"
            ui.handle_error e
          end

        rescue Exception => e
          ui.error "Unable to download snippet"
          ui.handle_error e

        else
          ui.success "Snippet file saved successfully"
        end
      end
    end
  end
end
