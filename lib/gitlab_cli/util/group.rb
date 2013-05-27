module GitlabCli
  module Util
    class Group
      def self.get(group_id)
        url = "groups/%s" % [group_id]
        begin 
          response = GitlabCli::Util.rest "get", url

        rescue Exception => e
          raise e

        else
          data = JSON.parse(response)
          GitlabCli::Group.new(data['id'], data['name'], data['path'], data['owner_id'])
        end
      end

      def self.create(name, path)
        url = "groups"
        payload = {
          :name           => name,
          :path           => path,
        }
        begin
          response = GitlabCli::Util.rest "post", url, payload

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

