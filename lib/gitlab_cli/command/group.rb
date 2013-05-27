module GitlabCli
  module Command
    class Group < Thor
      def self.banner(task, namespace = true, subcommand = true)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end

      # ADD
      desc "add [NAME] [PATH]", "add a new group"
      long_desc <<-D
        Add a new group.  

        $ gitlab group add "My Group" my-group

        $ gitlab group add MyGroup mygroup
      D
      def add(name, path)
        ui = GitlabCli.ui
        begin
          group = GitlabCli::Util::Group.create(name, path)

        rescue ResponseCodeException => e
          case e.response_code
          when 404
            ui.error "A group with that name and/or path already exists. Please choose a new name and/or path."
          else
            ui.error "Unable to create a group"
            ui.handle_error e
          end

        rescue Exception => e
          ui.error "Unable to create a group"
          ui.handle_error e

        else
          ui.success "Group created."
          ui.info "ID: %s" % [group.id]
          ui.info "Name: %s" % [group.name]
          ui.info "Path/Namespace: %s" % [group.path]
        end
      end

      # INFO
      desc "info [GROUP_ID]", "view detailed info for a group"
      long_desc <<-D
        View detailed information about a group.\n
        Use 'gitlab groups' to see a list of projects with their namespace and id.
      D
      def info(group_id)
        ui = GitlabCli.ui
        begin
          group = GitlabCli::Util::Group.get(group_id)

        rescue ResponseCodeException => e
          case e.response_code
          when 404
            ui.error "Unable to get group info"
            ui.error "Cannot find group with ID \"%s\"" % [group_id]
          else
            ui.error "Unable to get group info"
            ui.handle_error e
          end

        rescue Exception => e
          ui.error "Unable to get group info"
          ui.handle_error e

        else
          ui.info "Group ID: %s" % [group.id]
          ui.info "Name: %s" % [group.name]
          ui.info "Path: %s" % [group.path]
        end
      end
    end
  end
end
