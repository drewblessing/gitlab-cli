module GitlabCli
  module Command
    class User < Thor
      def self.banner(task, namespace = true, subcommand = true)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end

      # ADD
      desc "add [EMAIL] [OPTIONS]", "add a user"
      long_desc <<-D
        Add a user. This action is restricted to GitLab administrators.
      D
      option :password, :desc => "A password for the new user", :type => :string, :required => true, :aliases => ["-p"]
      option :username, :desc => "The username for the user", :type => :string, :required => true, :aliases => ["-u"]
      option :name, :desc => "The user's full name. Enclose in double-quotes to include first and last.", :required => true, :type => :string, :aliases => ["-n"]
      option :skype, :desc => "The Skype name for the user", :type => :string
      option :linkedin, :desc => "The LinkedIn name for the user", :type => :string
      option :twitter, :desc => "The user's Twitter handle", :type => :string
      option :projects_limit, :desc => "The limit on the number of projects a user can create in their namespace", :type => :string
      option :bio, :desc => "A user's biography", :type => :string
      def add(email)
        ui = GitlabCli.ui
        begin
          user = GitlabCli::Util::User.create email, options['password'], options['username'], options['name'], options['skype'], options['linkedin'], options['twitter'], options['projects_limit'], options['bio']
        
        rescue ResponseCodeException => e
          case e.response_code
          when 404
            ui.error "A user with this information already exists. Please specify a unique user."
          else
            ui.error "Unable to create a user with email address \'%s\'" % [email]
            ui.handle_error e
          end

        rescue Exception => e
          ui.error "Unable to create a user with email address \'%s\'" % [email]
          ui.handle_error e

        else
          ui.success "User \"%s\" <%s> created successfully" % [user.name, user.email]
          ui.info "ID: %s" % [user.id]
        end
      end

      ## EDIT
      desc "edit [USER] [OPTIONS]", "edit a user"
      long_desc <<-D
        Edit a user. This action is restricted to GitLab administrators.
      D
      option :email, :desc => "A new email address for the user", :type => :string, :aliases => ["-e"]
      option :password, :desc => "A new password for the user", :type => :string, :aliases => ["-p"]
      option :username, :desc => "The new username for the user", :type => :string, :aliases => ["-u"]
      option :name, :desc => "Update the user's full name. Enclose in double-quotes to include first and last.", :type => :string, :aliases => ["-n"]
      option :skype, :desc => "The Skype name for the user", :type => :string
      option :linkedin, :desc => "The LinkedIn name for the user", :type => :string
      option :twitter, :desc => "The user's Twitter handle", :type => :string
      option :projects_limit, :desc => "The limit on the number of projects a user can create in their namespace", :type => :string
      option :bio, :desc => "A user's biography", :type => :string
      option :yes, :desc => "Update the user's information without asking for confirmation", :type => :boolean, :aliases => ["-y"]
      def edit(user_id)
        ui = GitlabCli.ui
        begin
          ui.warn "Changing a user's username can have unintended side effects! Personal repository git configs will need updated and project URLs will change." if !options['username'].nil?
          response = ui.yes? "Are you sure you want to proceed with changing this user's username? (Yes\\No)" unless options['yes']
          raise "User did not confirm the changes" unless options['yes'] || response

          user = GitlabCli::Util::User.update user_id, options['email'], options['password'], options['username'], options['name'], options['skype'], options['linkedin'], options['twitter'], options['projects_limit'], options['bio']

        rescue ResponseCodeException => e
          case e.response_code
          when 404
            ui.error "Unable to edit user with ID %s" % [user_id]
            ui.error "Either the user could not be found or the information you entered conflicts with an existing user."
          else
            ui.error "Unable to edit user with ID %s" % [user_id]
            ui.handle_error e
          end

        rescue Exception => e
          ui.error "Unable to edit user"
          ui.handle_error e

        else
          ui.success "User \"%s\" <%s> was successfully updated." % [user.name, user.email]
          ui.info "ID: %s" % [user.id]
        end
      end

      # INFO
      desc "info [USER]", "view detailed info for a user"
      long_desc <<-D
        View detailed information about a user.\n
        If no [USER] is specified the command will return information for the current user. This is the user configured in the Gitlab CLI configuration file via the private token.
      D
      def info(user_id=nil)
        ui = GitlabCli.ui
        begin
          user = GitlabCli::Util::User.get(user_id)

        rescue ResponseCodeException => e
          case e.response_code
          when 404
            ui.error "Unable to get user info"
            ui.error "Cannot find user with username, email or ID \"%s\"" % [user_id]
          else
            ui.error "Unable to get user info"
            ui.handle_error e
          end

        rescue Exception => e
          ui.error "Unable to get user info"
          ui.handle_error e

        else
          ui.warn "No user provided. Showing information for my user..." if user_id.nil?
          ui.info "User ID: %s" % [user.id]
          ui.info "Full Name: %s" % [user.name]
          ui.info "Email Address: %s" % [user.email]
          ui.info "Username: %s" % [user.username]
          ui.info "Created at: %s" % [Time.parse(user.created_at)]
          ui.info "Biography: %s" % [user.bio.nil? || user.bio.empty? ? "N/A" : user.bio]
          ui.info "State: %s" % [user.state]
          ui.info "Theme: %s" % [user.theme]
          ui.info "Provider: %s" % [user.provider.nil? ? "Internal" : user.provider]
          ui.info "External UID: %s" % [user.extern_uid] if !user.provider.nil?
          ui.info "Skype: %s" % [user.skype] unless user.skype.empty?
          ui.info "LinkedIn: %s" % [user.linkedin] if !user.linkedin.empty?
          ui.info "Twitter: %s" % [user.twitter] if !user.twitter.empty?
        end
      end
    end
  end
end
