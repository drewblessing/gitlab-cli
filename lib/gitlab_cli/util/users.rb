module GitlabCli
  module Util
    class Users
      def self.get_all
        begin 
          response = Array.new
          per_page = 100
          page = 0
          # If we get `per_page` results per page then we keep going.
          # If we get less than that we're done.
          while response.length == page * per_page do
            page += 1
            url = "users?page=%s&per_page=%s" % [page, per_page]
            page_data = GitlabCli::Util.rest "get", url
            response.concat JSON.parse(page_data)
          end 

        rescue Exception => e
          raise e

        else
          users = response.map do |u|
            GitlabCli::User.new(u['id'],u['username'],u['email'],u['name'],u['state'],u['created_at'],u['theme_id'],u['bio'],u['skype'],u['linkedin'],u['twitter'],u['extern_uid'],u['provider'])
          end
        end
      end
    end
  end
end

