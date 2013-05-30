module GitlabCli
  class User
    attr_accessor :id, :username, :email, :name, :state, :created_at, :theme, :theme_id, :bio, :skype, :linkedin, :twitter, :extern_uid, :provider

    def initialize(id, username, email, name, state, created_at, theme_id=nil, bio=nil, skype=nil, linkedin=nil, twitter=nil, extern_uid=nil, provider=nil)
      @id = id
      @username = username
      @email = email
      @name = name
      @state = state
      @created_at = created_at
      @theme_id = theme_id
      @theme = theme_id_to_name
      @bio = bio
      @skype = skype
      @linkedin = linkedin
      @twitter = twitter
      @extern_uid = extern_uid
      @provider = provider
    end

    def theme_id_to_name
      case @theme_id
      when 1
        'Default'
      when 2
        'Classic'
      when 3
        'Modern'
      when 4
        'SlateGray'
      when 5
        'Violet'
      else
        ''
      end
    end
  end
end

