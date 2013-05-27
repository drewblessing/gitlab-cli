module GitlabCli
  module Command
    class Group < Thor
      def self.banner(task, namespace = true, subcommand = true)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end

      ## INFO
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
