require 'rest_client'

class Gitlab
  class Project
    attr_accessor :id, :name, :description, :default_branch, :public, :path, :path_with_namespace, :issues_enabled, :merge_requests_enabled, :wall_enabled, :wiki_enabled, :created_at

    def initialize(id, name, description, default_branch, public, path, path_with_namespace, issues_enabled, merge_requests, wall_enabled, wiki_enabled, created_at)
      @id = id
      @name = name
      @description = description
      @default_branch = default_branch
      @public = public
      @path = path
      @path_with_namespace = path_with_namespace
      @issue_enabled = issues_enabled
      @merge_requests = merge_requests
      @wall_enabled = wall_enabled 
      @wiki_enabled = wiki_enabled
      @created_at = created_at
    end

  end
end

