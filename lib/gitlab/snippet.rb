require 'rest_client'

class Gitlab
  class Snippet
    attr_accessor :id, :title, :file_name, :expires_at, :updated_at, :created_at, :project_id, :view_url

    def initialize(id, title, file_name, expires_at, updated_at, created_at, project_id)
      @id = id
      @title = title
      @file_name = file_name
      @expires_at = expires_at
      @updated_at = updated_at
      @created_at = created_at

      @project_id = project_id
      @view_url = get_view_url
    end

    private
    def get_view_url
      project_path_with_namespace = Gitlab::Util.get_project_path_with_namespace(@project_id)
      URI.join(Config[:gitlab_url],"%s/snippets/%s" % [project_path_with_namespace,@id.to_s])
    end
  end
end

