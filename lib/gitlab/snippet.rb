require File.expand_path('../user', __FILE__)

class Gitlab
  class Snippet
    attr_accessor :id, :title, :file_name, :expires_at, :updated_at, :created_at, :project_id, :view_url, :author

    def initialize(id, title, file_name, expires_at, updated_at, created_at, project_id, author=nil)
      @id = id
      @title = title
      @file_name = file_name
      @expires_at = expires_at
      @updated_at = updated_at
      @created_at = created_at

      @project_id = project_id
      @view_url = get_view_url

      @author = author.class == 'Gitlab::User' ? author : parse_author(author)
    end

    private
    def get_view_url
      project_path_with_namespace = Gitlab::Util.get_project_path_with_namespace(@project_id)
      URI.join(Config[:gitlab_url],"%s/snippets/%s" % [project_path_with_namespace,@id.to_s])
    end

    private
    def parse_author(author)
      Gitlab::User.new(author['id'],author['username'],author['email'],author['name'],author['blocked'],author['created_at'])
    end
  end
end

