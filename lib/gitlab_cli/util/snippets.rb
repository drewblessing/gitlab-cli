module GitlabCli
  module Util
    class Snippets
      def self.get_all(project)
        id = GitlabCli::Util.numeric?(project) ? project : GitlabCli::Util.get_project_id(project)

        begin 
          response = Array.new
          per_page = 100
          page = 0
          # If we get `per_page` results per page then we keep going.
          # If we get less than that we're done.
          while response.length == page * per_page do
            page += 1
            url = "projects/%s/snippets?page=%s&per_page=%s" % [id, page, per_page]
            page_data = GitlabCli::Util.rest "get", url
            response.concat JSON.parse(page_data)
          end
        rescue Exception => e
          raise e

        else
          snippets = response.map do |s|
            GitlabCli::Snippet.new(s['id'],s['title'],s['file_name'],s['expires_at'],s['updated_at'],s['created_at'],id,s['author'])
          end
        end
      end
    end
  end
end
