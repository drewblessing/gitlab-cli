# _GitLab CLI Tool_

_Many people prefer to work from the CLI when possible. This tool aims to bring some of the GitLab functionality into the CLI to avoid repeated trips to the web UI. At this time the tool only allows interaction with snippets._

## Version 2.0.0 

This version contains breaking changes!!

* Now packaged as a gem! 
* Configuration file loaded from user's home directory - ~/.gitlab_cli.yml
* Easier to use within your Ruby scripts/applications (see "Use as a library")

## GitLab Versions

This tool has only been tested with the following versions of GitLab.  Some or all of the features may or may not work with other versions but they are not _officially_ supported.

* 5.1.0
* 5.0.x

[How to use (Commands)](#how-to-use-commands)
[Use as a Library](#use-as-a-library)

## Installation and Setup 

_How do I get started?_ 

Install from rubygems (Recommended)

1. _`gem install gitlab_cli`_

Install from the repo (requires rake and bundler).

1. _Clone the repo._
2. _`rake build`_
3. _`rake install` (Requires root privileges)._

You now have access to the `gitlab` command.

_Required Gems_

If you install from rubygems then you will not need to install these required gems yourself. The gem package manager will attempt to install the proper versions for you.

1. thor >= 0.17.0 and < 0.19
2. json >= 1.7.7 and < 1.8
3. rest-client >= 1.6.7 and < 1.7

Note for Linux users: You may need to install the `ruby-devel` package via YUM if you receive an error on install.  The error you would see is:

```
Building native extensions.  This could take a while...
 ERROR: Failed to build gem native extension.

/usr/bin/ruby extconf.rb
mkmf.rb can't find header files for ruby at /usr/lib/ruby/ruby.h


Gem files will remain installed in /usr/lib/ruby/gems/1.8/gems/json-1.7.7 for inspection.
Results logged to /usr/lib/ruby/gems/1.8/gems/json-1.7.7/ext/json/ext/generator/gem_make.out
```

_How can I find the private token for my user?_

Login to your GitLab web UI, go to 'My Profile', and select the 'Account' tab.  Copy the private token from the box and paste into your config.  

_How can I add the repo bin path to my environment PATH variable?_

Place it in your ~/.bash_profile file.  You should end up with something like this:
`export PATH=$PATH:/path/to/gitlab-cli/repo/bin/`

## How to use (Commands) 

View a list of all the commands you can use to interact with Gitlab CLI, complete with examples.

[Commands](doc/Commands.md)

## Use as a library

Now that Gitlab CLI is distributed as a gem it is increasingly easy to use in your Ruby scripts or applications.  Click the link below to see documentation on how to get started using Gitlab CLI as a library.

[Use as a library](doc/Library.md)

## Issues

If you encounter issues with this project, please find help via one of these avenues.

1. _IRC: #gitlab on Freenode - nick dblessing_
2. _GitHub Issues: Open a new issue here on GitHub_

## Contributing changes

I welcome all contributions.  If you would like to include a new feature or bug fix, simply open a pull request and explain the problem or feature you contributed. I will review the contribution at that point.  If you want to discuss fixes or improvements before submitting a pull request, please find me on IRC #gitlab on Freenode or open a GitHub issue.

## License
See LICENSE file.
