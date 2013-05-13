require 'thor/shell/basic'
require 'thor/shell/color'

## Concepts borrowed from Vagrant UI class.

module GitlabCli
  module UI
    class Interface
      #[:ask, :warn, :error, :info, :success].each do |method|
      #  define_method(method) do |message, *opts|
      #    # Log normal console messages
      #    @logger.info { "#{method}: #{message}" }
      #  end
      #end
    end

    class Basic < Interface
      def initialize
        #super
        
        @shell = Thor::Shell::Basic.new
      end
      
      # Use some light meta-programming to create the various methods to
      # output text to the UI. These all delegate the real functionality
      # to `say`.
      [:info, :warn, :error, :success].each do |method|
        class_eval <<-CODE
          def #{method}(message)
            #super(message)
            @shell.say(message)
          end
        CODE
      end

      def ask(message, opts=nil)
        #super(message)

        # We can't ask questions when the output isn't a TTY.
        #raise Errors::UIExpectsTTY if !$stdin.tty? && !Vagrant::Util::Platform.cygwin?

        # Setup the options so that the new line is suppressed
        #opts ||= {}
        #opts[:new_line] = false if !opts.has_key?(:new_line)
        #opts[:prefix]   = false if !opts.has_key?(:prefix)

        # Output the data
        #@shell.ask(:info, message, opts)

        # Get the results and chomp off the newline. We do a logical OR
        # here because `gets` can return a nil, for example in the case
        # that ctrl-D is pressed on the input.
        @shell.ask message
      end

      def yes?(message, color=nil)
        @shell.yes? message, color
      end
    end

    class Color < Basic 
      def initialize
        #super
        
        @shell = Thor::Shell::Color.new
      end

      # Terminal colors
      COLORS = {
        :clear  => "\e[0m",
        :red    => "\e[31m",
        :green  => "\e[32m",
        :yellow => "\e[33m"
      }

      # Mapping between type of message and the color to output
      COLOR_MAP = {
        :info    => nil,
        :warn    => :yellow,
        :error   => :red,
        :success => :green
      }

      # Use some light meta-programming to create the various methods to
      # output text to the UI. These all delegate the real functionality
      # to `say`.
      [:info, :warn, :error, :success].each do |method|
        class_eval <<-CODE
          def #{method}(message,color=nil,force_new_line = (message.to_s !~ /( |\t)\Z/))
            say_color = color.nil? ? COLOR_MAP[:#{method}] : color
            #super(message)
            @shell.say(message,say_color,force_new_line)
          end
        CODE
      end
    end
  end
end
