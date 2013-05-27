module GitlabCli
  module Util
    class Snippet
      # Get snippet object
      def self.get(project, snippet_id)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)
        url = "projects/%s/snippets/%s" % [id, snippet_id]

        begin 
          response = GitlabCli::Util.rest 'get', url
        rescue Exception => e
          raise e

        else
          data = JSON.parse(response)
          GitlabCli::Snippet.new(data['id'],data['title'],data['file_name'],data['expires_at'],data['updated_at'],data['created_at'],id,data['author'])
        end
      end

      # Create
      def self.create(project, title, file_name, code)
        ## Adapted from https://github.com/ripienaar/snipper/blob/master/lib/snipper/util.rb
        if STDIN.tty?
          if File.readable?(code)
            content = File.read(code)
          else
            GitlabCli.ui.error "Cannot read the specified file."
            exit 1
          end
        else
          content = STDIN.read
        end
        ##
        
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)

        url = "projects/%s/snippets" % [id]
        payload = {
          :title      => title, 
          :file_name  => file_name,
          :code       => content
        }

        begin 
          response = GitlabCli::Util.rest 'post', url, payload
        rescue Exception => e
          raise e

        else
          data = JSON.parse(response)
          GitlabCli::Snippet.new(data['id'],data['title'],data['file_name'],data['expires_at'],data['updated_at'],data['created_at'],id,data['author'])
        end
      end

      # View
      def self.view(project, snippet_id)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)
        url = "projects/%s/snippets/%s/raw" % [id, snippet_id]

        begin 
          response = GitlabCli::Util.rest 'get', url
        rescue Exception => e
          raise e

        end
      end
      
      # Update 
      def self.update(project, snippet, content)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)
        url = "projects/%s/snippets/%s" % [id, snippet.id]
        payload = {
          :title      => snippet.title, 
          :file_name  => snippet.file_name, 
          :code       => content
        }

        begin 
          response = GitlabCli::Util.rest 'put', url, payload
        rescue Exception => e
          raise e

        else
          data = JSON.parse(response)
          GitlabCli::Snippet.new(data['id'],data['title'],data['file_name'],data['expires_at'],data['updated_at'],data['created_at'],id,data['author'])
        end
      end

      # Delete
      def self.delete(project, snippet_id)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)
        url = "projects/%s/snippets/%s" % [id, snippet_id]

        begin
          snippet = get(project, snippet_id)
        rescue Exception => e
          raise e

        else
          if snippet.class == 'GitlabCli::Snippet'
            begin 
              response = GitlabCli::Util.rest 'delete', url
            rescue Exception => e
              raise e
            end
          end
        end
      end

      # Download/Save
      def self.download(project, snippet_id, file_path)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)

        begin
          snippet_content = view(project, snippet_id)

        rescue Exception => e
          raise e

        else
          begin
            File.open(file_path, 'w') { |file| file.write(snippet_content) }

          rescue IOError => e
            GitlabCli.ui.error "Cannot save snippet as file. Please check permissions for %s" % [file_path]

          rescue Errno::ENOENT => e
            GitlabCli.ui.error "Specified directory does not exist.  Directory must exist to save the snippet file."
          end
        end
      end
    end
  end
end
