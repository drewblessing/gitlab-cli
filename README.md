# _GitLab CLI Tool_

_Many people prefer to work from the CLI when possible. This tool aims to bring some of the GitLab functionality into the CLI to avoid repeated trips to the web UI._

## NOTE ##

This may not work with GitLab 6.x. Development is ongoing and a new version will be posted shortly. What's more, the new version will be drastically refactored and will be backed by rspec tests. This will ensure that future versions can be released quicker and with confidence. Thanks for your patience.

## Current version is 2.0.0. 

This branch (master) represents current development efforts and may not be 100% stable. Please install via RubyGems and/or checkout tag v2.0.0.

## GitLab Versions

This tool has only been tested with the following versions of GitLab.  Some or all of the features may or may not work with other versions but they are not _officially_ supported.

* 5.2.0 - See note below.
* 5.1.0
* 5.0.x

Note: 5.2.0 uses a newer version of Grape API framework which caused a regression in all APIs that return raw/blob content.  If you are running GitLab 5.2.0, you will need to make a few manual changes to the Gemfile and Gemfile.lock to use GitLab CLI.

 1 Stop GitLab 
 
 2 Edit 'Gemfile' and modify the 2 lines with Grape:

```
gem "grape", "~> 0.3.1"
gem "grape-entity", "~> 0.2.0"
```
 3 Edit 'Gemfile.lock' and modify the 2 lines with Grape:

```
    grape (0.3.2)
      ...<more stuff here>
    grape-entity (0.2.0)
```
 4 To be safe, run `bundle install --deployment --without development test postgres` or whatever bundle install command is appropriate for your installation.
 
 5 Start GitLab

Now the GitLab CLI tool should work properly with your installation.  I am working with GitLab HQ to find a permanent solution to this regression.  Thanks for your patience.

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

_Required system packages_

1. ruby-devel
2. make
3. gcc

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
