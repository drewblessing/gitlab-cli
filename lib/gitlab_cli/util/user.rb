module GitlabCli
  module Util
    class User
      def self.get(user_id=nil)
        url = user_id.nil? ? "user" : "users/%s" % [user_id]
        begin 
          response = GitlabCli::Util.rest "get", url

        rescue Exception => e
          raise e

        else
          data = JSON.parse(response)
          GitlabCli::User.new(data['id'],data['username'],data['email'],data['name'],data['state'],data['created_at'],data['theme_id'],data['bio'],data['skype'],data['linkedin'],data['twitter'],data['extern_uid'],data['provider'])
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

      # Create
      def self.create(email, password, username, name, skype=nil, linkedin=nil, twitter=nil, projects_limit=nil, bio=nil)
        url = "users"
        payload = {
          :email              => email,
          :password           => password,
          :username           => username,
          :name               => name,
          :skype              => skype,
          :linkedin           => linkedin,
          :twitter            => twitter,
          :projects_limit     => projects_limit,
          :bio                => bio
        }

        begin 
          response = GitlabCli::Util.rest 'post', url, payload
        rescue Exception => e
          raise e

        else
          data = JSON.parse(response)
          GitlabCli::User.new(data['id'],data['username'],data['email'],data['name'],data['state'],data['created_at'],data['theme_id'],data['bio'],data['skype'],data['linkedin'],data['twitter'])
        end
      end
    end
  end
end
