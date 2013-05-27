module GitlabCli
  module Util
    class Groups
      def self.get_all
        begin 
          response = Array.new
          per_page = 100
          page = 0
          # If we get `per_page` results per page then we keep going.
          # If we get less than that we're done.
          while response.length == page * per_page do
            page += 1
            url = "groups?page=%s&per_page=%s" % [page, per_page]
            page_data = GitlabCli::Util.rest "get", url
            response.concat JSON.parse(page_data)
          end 

        rescue Exception => e
          raise e

        else
          projects = response.map do |p|
            GitlabCli::Group.new(p['id'],p['name'],p['path'],p['owner_id'])
          end
        end
      end
    end
  end
end

