module GitlabCli
  module Util
    class Group
      def self.get(group_id)
        begin 
          url = "groups/%s" % [group_id]
          response = GitlabCli::Util.rest "get", url

        rescue Exception => e
          raise e

        else
          data = JSON.parse(response)
          GitlabCli::Group.new(data['id'], data['name'], data['path'], data['owner_id'])
        end
      end
    end
  end
end

