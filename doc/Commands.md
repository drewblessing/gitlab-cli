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

Note: As of v1.1.0, this command can output in the system pager or `less` to improve readability when many results are shown. Set configuration `display_results_in_pager` command to `true` to enable this functionality.
Use --nopager or --pager to temporarily turn paging off or on respectively.  These options effectively overrides the true/false setting for `display_results_in_pager` configuration setting.

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

### _Add a project_
Only [PROJECT_NAME] is required.

Usage 1: `gitlab project add [PROJECT_NAME] --description=DESCRIPTION --branch=DEFAULT_BRANCH --namespace-id=NAMESPACE_ID --issues=BOOLEAN --merge_requests=BOOLEAN --wall=BOOLEAN --wiki=BOOLEAN`

Usage 2: 
```
gitlab project add "My Project" -d "This project is going to be awesome" -b master -n 2 --issues=true --wall=false --merge-requests=true --wiki=false
```

Example output:
```
Project "My Project" successfully created.
ID: 35
URL: https://gitlab.example.com/my-group/my-project
```

### _List all snippets for a project_

Usage: `gitlab snippets [PROJECT] [OPTIONS]`

Using project ID: `gitlab snippets 13`

Using project full namespace/project format: `gitlab snippets user1/project1`

Options: `--nopager`, `--pager` to turn paging off or on one time (See note below example output)

Example output:
```
2:  Title - Filename
16:	README - README.md
```

Note: As of v1.1.0, this command can output in the system pager or `less` to improve readability when many results are shown. Set configuration `display_results_in_pager` command to `true` to enable this functionality.
Use --nopager or --pager to temporarily turn paging off or on respectively.  These options effectively overrides the true/false setting for `display_results_in_pager` configuration setting.

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
Use -y flag to bypass confirmation. Use at your own risk.

Usage: `gitlab snippet delete [PROJECT] [SNIPPET_ID]`

Using project ID: `gitlab snippet delete 13 16`

Using project full namespace/project format: `gitlab snippet delete user1/project1 16`

### _Save a snippet to your local filesystem_
Note: The "save" subcommand is an alias of "download." Both have the same effect.

Usage 1: `gitlab snippet download [PROJECT] [SNIPPET_ID] [FILE]`

Usage 2: `gitlab snippet save [PROJECT] [SNIPPET_ID] [FILE]`

Using project ID: `gitlab snippet save 13 16 /path/for/new/file`

Using project full namespace/project format: `gitlab snippet download user1/project1 16 /path/for/new/file`


### _List all groups_

Usage: `gitlab groups [OPTIONS]`

Options: `--nopager`, `--pager` to turn paging off or on one time (See note below example output)

Example output:
```
2:	Test Group
4:	My Test Group
5:	Special Group
6:	My Group
```

### _View detailed information about a group_

Usage: `gitlab group info [GROUP_ID]`

Example output:
```
Group ID: 2
Name: Test Group
Path: test-group
Owner ID: 2
```

### _Add a group_
Only available to Administrators

Usage 1: `gitlab group add [NAME] [PATH]`

Usage 2: `gitlab group add "My awesome group" awesome-group`

Example output:
```
Group created.
ID: 15
Name: My awesome group
Path/Namespace: awesome-group
```

