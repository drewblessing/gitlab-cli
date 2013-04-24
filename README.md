# _GitLab CLI Tool_

_Many people prefer to work from the CLI when possible. This tool aims to bring some of the GitLab functionality into the CLI to avoid repeated trips to the web UI. At this time the tool only allows interaction with snippets._

## GitLab Versions

This tool has only been tested with the following versions of GitLab.  Some or all of the features may or may not work with other versions but they are not _officially_ supported.

* 5.1.0
* 5.0.x

## Project Setup

_How do I get started?_ 

1. _Clone this repo._
2. _Make sure you have bundler installed. `gem install bundler`_
3. _Run `bundle install` in the root of the repository._
4. _Copy config.yml.sample to config.yml and edit the configuration as appropriate._
5. _Add the repo bin path to your environment PATH variable._

_How can I find the private token for my user?_

Login to your GitLab web UI, go to 'My Profile', and select the 'Account' tab.  Copy the private token from the box and paste into your config.  

_How can I add the repo bin path to my environment PATH variable?_

Place it in your ~/.bash_profile file.  You should end up with something like this:
`export PATH=$PATH:/path/to/gitlab-cli/repo/bin/`

## Commands
Note: All command results are subject to user authorization.  For example, if the command says it will return all projects it will return all projects...that the user is able to see.

Note2: Anywhere you see [PROJECT] you can either specify the full namespace/project name for the project or you can provide the project ID.  Both can be obtained by running the first command below.

### _List all projects_

Usage: `gitlab projects [OPTIONS]`

Options: `--nopager`, `--pager` to turn paging off or on one time (See note below example output)

Example output:
```
3:	globalproject1
4:	namespace1/project2
6:	namespace1/project3
11:	namespace2/project1
13:	user1/project1
```

Note: As of v1.1.0, this command displays output in the system pager or `less` by default. Set configuration `display_results_in_pager` command to `false` to revert this change.
Use --nopager or --pager to temporarily turn paging off or on respectively.  This effectively overrides the true/false setting for `display_results_in_pager` configuration setting.

### _View detailed information about a project_

Usage: `gitlab project info [PROJECT]`

Example output:
```
Project ID: 3
Name: My Project
Path w/ Namespace: namespace1/myproject
Project URL: https://gitlab.example.com/namespace1/myproject
Description: This is my awesome repo!
Default Branch: master
Owner: Drew Blessing <drew.blessing@example.com>
Public?: false
Issues enabled?: false
Merge Requests enabled?: true
Wall enabled?: false
Wiki enabled?: false
Created at: Mon Apr 01 18:42:38 UTC 2013

```

### _List all snippets for a project_

Usage: `gitlab snippets [PROJECT]`

Using project ID: `gitlab snippets 13`

Using project full namespace/project format: `gitlab snippets user1/project1`

Options: `--nopager`, `--pager` to turn paging off or on one time (See note below example output)

Example output:
```
2:  Title - Filename
16:	README - README.md
```

Note: As of v1.1.0, this command displays output in the system pager or `less` by default. Set configuration `display_results_in_pager` command to `false` to revert this change.
Use --nopager or --pager to temporarily turn paging off or on respectively.  This effectively overrides the true/false setting for `display_results_in_pager` configuration setting.

### _View a snippet (Uses default pager or "less")_

Usage: `gitlab snippet view [PROJECT] [SNIPPET_ID]`

Using project ID: `gitlab snippet view 13 16`

Using project full namespace/project format: `gitlab snippet view user1/project1 16`

### _Edit a snippet (Users default editor or "vi")_

Usage: `gitlab snippet edit [PROJECT] [SNIPPET_ID]`

Using project ID: `gitlab snippet edit 13 16`

Using project full namespace/project format: `gitlab snippet edit user1/project1 16`

Example output:
```
Snippet updated.
 URL: https://gitlab.example.com/user1/project1/snippets/16
```

### _View detailed information about a snippet_

Usage :`gitlab snippet info [PROJECT] [SNIPPET_ID]`

Using project ID: `gitlab snippet info 13 16`

Using project full namespace/project format: `gitlab snippet info user1/project1 16`

Example output:
```
Snippet ID: 16
Title: README
File Name: README.md
Author: John Doe <john.doe@example.com>
Created at: Fri Apr 19 01:11:08 UTC 2013
Updated at: Fri Apr 19 01:11:08 UTC 2013
Expires at: Never
```

### _Add a snippet_

Usage 1: `gitlab snippet add [PROJECT] [FILE] -t [TITLE] -n [FILE_NAME]`

Usage 2: `cat [FILE] | gitlab snippet add [PROJECT] -t [TITLE] -n [FILE_NAME]`

Using project ID: `gitlab snippet add 13 16 /path/to/file -t "Awesome title" -n file.txt`

Using project full namespace/project format: `gitlab snippet add user1/project1 16 /path/to/file -t "Awesome title" -n file.txt``

Example output:
```
Snippet created.
ID: 20
URL: https://gitlab.example.com/user1/project1/snippets/20
```

### _Delete a snippet (Asks for confirmation)_

Usage: `gitlab snippet delete [PROJECT] [SNIPPET_ID]`

Using project ID: `gitlab snippet delete 13 16`

Using project full namespace/project format: `gitlab snippet delete user1/project1 16`

### _Save a snippet to your local filesystem_
Note: The "save" subcommand is an alias of "download." Both have the same effect.

Usage 1: `gitlab snippet download [PROJECT] [SNIPPET_ID] [FILE]`

Usage 2: `gitlab snippet save [PROJECT] [SNIPPET_ID] [FILE]`

Using project ID: `gitlab snippet save 13 16 /path/for/new/file`

Using project full namespace/project format: `gitlab snippet download user1/project1 16 /path/for/new/file`

## Issues

If you encounter issues with this project, please find help via one of these avenues.

1. _IRC: #gitlab on Freenode - nick dblessing_
2. _GitHub Issues: Open a new issue here on GitHub_

## Contributing changes

I welcome all contributions.  If you would like to include a new feature or bug fix, simply open a pull request and explain the problem or feature you contributed. I will review the contribution at that point.  If you want to discuss fixes or improvements before submitting a pull request, please find me on IRC #gitlab on Freenode or open a GitHub issue.

## License
See LICENSE file.
