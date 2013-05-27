module GitlabCli
  class Group
    attr_accessor :id, :name, :path, :owner_id

    def initialize(id, name, path, owner_id)
      @id = id
      @name = name
      @path = path
      @owner_id = owner_id
    end
  end
end

