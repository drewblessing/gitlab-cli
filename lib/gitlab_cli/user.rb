module GitlabCli
  class User
    attr_accessor :id, :username, :email, :name, :blocked, :created_at, :bio, :skype, :linkedin, :twitter, :extern_uid, :provider

    def initialize(id, username, email, name, blocked, created_at, bio=nil, skype=nil, linkedin=nil, twitter=nil, extern_uid=nil, provider=nil)
      @id = id
      @username = username
      @email = email
      @name = name
      @blocked = blocked
      @created_at = created_at
      @bio = bio
      @skype = skype
      @linkedin = linkedin
      @twitter = twitter
      @extern_uid = extern_uid
      @provider = provider
    end
  end
end

