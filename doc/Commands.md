## Commands
Note: All command results are subject to user authorization.  For example, if the command says it will return all projects it will return all projects...that the user is able to see.

Note2: Anywhere you see [PROJECT] you can either specify the full namespace/project name for the project or you can provide the project ID.  Both can be obtained by running the first command below.

## Projects

### _List all projects_

Usage

`gitlab projects [OPTIONS]`

* Use the pager options to temporarily turn paging off or on respectively.  These options effectively overrides the true/false setting for `display_results_in_pager` configuration setting.

Options

```
  [--nopager]  # Turn OFF pager output one time for this command
  [--pager]    # Turn ON pager output one time for this command
```

Example output

```
3:	globalproject1
4:	namespace1/project2
6:	namespace1/project3
11:	namespace2/project1
13:	user1/project1
```

### _View information about a project_

Usage

`gitlab project info [PROJECT]`

Example output

```
Project ID: 3
Name: My Project
Path w/ Namespace: namespace1/myproject
Project URL: https://gitlab.example.com/namespace1/myproject
Description: This is my awesome repo!
Default Branch: master
Owner: John Doe <john.doe@example.com>
Public?: false
Issues enabled?: false
Merge Requests enabled?: true
Wall enabled?: false
Wiki enabled?: false
Created at: Mon Apr 01 18:42:38 UTC 2013
```

### _Add a project_

Usage

`gitlab project add [PROJECT_NAME] [OPTIONS]`

* [PROJECT_NAME] is a required parameter

```
Options:
          [--wiki]                       # Enable wiki for the project
  -b, [--branch=BRANCH]                  # The project's default branch
  -d, [--description=DESCRIPTION]        # The project's description
          [--snippets]                   # Enable snippets for the project
  -g, -n, [--namespace-id=NAMESPACE_ID]  # The namespace ID this project should be added to. Namespace ID is synonymous with group ID
          [--issues]                     # Enable issues for the project
          [--wall]                       # Enable issues for the project
          [--merge-requests]             # Enable merge_requests for the project
```

Example output

```
Project "My Project" successfully created.
ID: 35
URL: https://gitlab.example.com/my-group/my-project
```

## Snippets

### _List snippets for a project_

Usage

`gitlab snippets [PROJECT] [OPTIONS]`

* Use the pager options to temporarily turn paging off or on respectively.  These options effectively overrides the true/false setting for `display_results_in_pager` configuration setting.

Options

```
  [--nopager]  # Turn OFF pager output one time for this command
  [--pager]    # Turn ON pager output one time for this command
```

Example output:
```
2:  Title - Filename
16:	README - README.md
```

### _View a snippet_

Usage

`gitlab snippet view [PROJECT] [SNIPPET_ID]`

* Displays the snippet in the system pager, as specified by `pager` ENV variable, or `less`.

### _Edit a snippet_

Usage

`gitlab snippet edit [PROJECT] [SNIPPET_ID]`

* The snippet will open in the system editor, as specified by `editor` ENV variable, or `vi`.

Example output

```
Snippet updated.
URL: https://gitlab.example.com/user1/project1/snippets/16
```

### _View information about a snippet_

Usage 

`gitlab snippet info [PROJECT] [SNIPPET_ID]`

Example output

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

Usage

```
gitlab snippet add [PROJECT] [FILE] [OPTIONS] -n, -f, --file-name=FILE_NAME -t, --title=TITLE
```

* All options are required

Options

```
  -t, --title=TITLE              # The title to use for the new snippet
  -n, -f, --file-name=FILE_NAME  # A file name for this snippet
```

Example output

```
Snippet created.
ID: 20
URL: https://gitlab.example.com/user1/project1/snippets/20
```

### _Delete a snippet_

Usage

`gitlab snippet delete [PROJECT] [SNIPPET_ID]`

* Asks for user confirmation before deleting.
* Use -y flag to bypass confirmation. Use at your own risk.

Options

```
  -y, [--yes]  # Delete without asking for confirmation
```

Example output

```
Successfully deleted the snippet.
```

### _Save/Download a snippet to your local filesystem_

Usage

`gitlab snippet download|save [PROJECT] [SNIPPET_ID] [FILE]`

* The "save" subcommand is an alias of "download." Both have the same effect.

Example output

```
Snippet file saved successfully.
```

## Groups

### _List all groups_

Usage

`gitlab groups [OPTIONS]`

* Use the pager options to temporarily turn paging off or on respectively.  These options effectively overrides the true/false setting for `display_results_in_pager` configuration setting.
* The Group ID displayed by this command is the same ID you can use when creating a project to specify the namespace a project should be in.  This command may be helpful in determining the appropriate namespace ID for use when creating a project.

Options

```
  [--nopager]  # Turn OFF pager output one time for this command
  [--pager]    # Turn ON pager output one time for this command
```

Example output

```
2:	Test Group
4:	My Test Group
5:	Special Group
6:	My Group
```

### _View information about a group_

Usage

`gitlab group info [GROUP_ID]`

* Group ID is the same as Namespace ID.

Example output

```
Group ID: 2
Name: Test Group
Path: test-group
Owner ID: 2
```

### _Add a group_

Usage

* Admins only

Usage


`gitlab group add [NAME] [PATH]`

* [PATH] will become the namespace for any project within this group. As such, it will also be associated with all URLs for projects within the namespace.

Example output:
```
Group created.
ID: 15
Name: My awesome group
Path/Namespace: awesome-group
```

## Users

### _Add a user_

* Admins only

Usage

```
gitlab user add [EMAIL] [OPTIONS] -n, --name=NAME -p, --password=PASSWORD -u, --username=USERNAME
```

* Required parameters include --name, --password, and --username

```
Options:
      [--linkedin=LINKEDIN]              # The LinkedIn name for the user
      [--twitter=TWITTER]                # The user's Twitter handle
      [--projects-limit=PROJECTS_LIMIT]  # The limit on the number of projects a user can create in their namespace
      [--bio=BIO]                        # A user's biography
  -u, --username=USERNAME                # The username for the user
  -p, --password=PASSWORD                # A password for the new user
  -n, --name=NAME                        # The user's full name. Enclose in double-quotes to include first and last.
      [--skype=SKYPE]                    # The Skype name for the user
```

Example output

```
User "Test User" <test@example.com> created successfully
ID: 3
```

### _Edit/Update a user_

* Admins only

Usage

`gitlab user edit [USER] [OPTIONS]`

* [USER] must be specified as a user ID. Use `gitlab users` to get a list of users and their associated IDs.
* Changing a user's username can have unintended side effects! Personal repository git configs will need updated and project URLs will change.

```
Options:
      [--linkedin=LINKEDIN]              # The LinkedIn name for the user
  -e, [--email=EMAIL]                    # A new email address for the user
      [--twitter=TWITTER]                # The user's Twitter handle
      [--projects-limit=PROJECTS_LIMIT]  # The limit on the number of projects a user can create in their namespace
      [--bio=BIO]                        # A user's biography
  -y, [--yes]                            # Update the user's information without asking for confirmation
  -u, [--username=USERNAME]              # The new username for the user
  -p, [--password=PASSWORD]              # A new password for the user
  -n, [--name=NAME]                      # Update the user's full name. Enclose in double-quotes to include first and last.
      [--skype=SKYPE]                    # The Skype name for the user
```

Example output

```
User "Test User" <test@example.com> was successfully updated.
ID: 3
```

### _View user information_

Usage

`gitlab user info [USER]`

* [USER] must be specified as a user ID. Use `gitlab users` to get a list of users and their associated IDs.
* If user provider is "Internal" no external UID attribute will be displayed.  Examples of external providers include LDAP and other omniauth providers.
* If no [USER] is specified the command will return information for the current user. This is the user configured in the Gitlab CLI configuration file via the private token.
* If no [USER] is specified you will see a warning message printed - `No user provided. Showing information for my user...`

Example output

```
User ID: 3
Full Name: Test User
Email Address: test@example.com
Username: test.user
Created at: Fri May 17 19:48:39 UTC 2013
Biography: My awesome bio!!
State: active
Theme: Classic
Provider: Internal
External UID: test.user.external
Skype: skype_name
LinkedIn: linkedin_name
Twitter: @twitter_name
```
