module GitlabCli
  class Project
    attr_accessor :id, :name, :description, :default_branch, :public, :path, :path_with_namespace, :issues_enabled, :merge_requests_enabled, :wall_enabled, :wiki_enabled, :created_at, :project_url, :owner

    def initialize(id, name, description, default_branch, public, path, path_with_namespace, issues_enabled, merge_requests_enabled, wall_enabled, wiki_enabled, created_at, owner=nil)
      @id = id
      @name = name
      @description = description
      @default_branch = default_branch
      @public = public
      @path = path
      @path_with_namespace = path_with_namespace
      @issues_enabled = issues_enabled
      @merge_requests_enabled = merge_requests_enabled
      @wall_enabled = wall_enabled 
      @wiki_enabled = wiki_enabled
      @created_at = created_at
      @project_url = get_project_url

      @owner = owner.class == 'Gitlab::User' || owner.nil? ? owner : parse_owner(owner)
    end

    private
    def get_project_url
      URI.join(GitlabCli::Config[:gitlab_url],@path_with_namespace)
    end    

    private
    def parse_owner(owner)
      GitlabCli::User.new(owner['id'],owner['username'],owner['email'],owner['name'],owner['state'],owner['created_at'])
    end
    
  end
end

