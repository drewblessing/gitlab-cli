## Objects

### _Project_

GitlabCLI::Project

Attributes:

* id - The numerical ID of the project
* name - The name of the project
* description - A long description of the project
* default_branch - The default branch to display in the interface
* public - Is the project public? True/False
* path - The short path for the project
* path_with_namespace - The full path with namespace for the project
* issues_enabled - Can issues be created? True/False
* merge_requests_enabled - Accept merge requests for the project? True/False
* wall_enabled - Is the wall enabled? True/False
* wiki_enabled - Is the wiki enabled? True/False
* created_at - The date/time the project was created
* project_url - The URL to the project
* owner - The owner of the project (returns a User object)

### _Snippet_

GitlabCLI::Snippet

* id - The numerical ID of the snippet
* title - The title of the snippet
* file_name - The file name for the snippet
* expires_at - The date/time the snippet is set to expire
* updated_at - The date/time the snippet was last updated
* created_at - The date/time the snippet was first created
* project_id - The ID of the project it is in
* view_url - The URL to the snippet
* author - The author of the snippet (returns a User object)

### _User_

GitlabCLI::User

* id - The numerical ID of the user
* username - The short username of the user
* email - The email address of the user
* name - The user\'s full name
* blocked - Is the user prevented from logging in? True/False
* created_at - The date/time the user was first created
* bio - The user\'s bio
* skype - The user\'s Skype account
* linkedin - The user\'s LinkedIn account
* twitter - The user\'s Twitter account
* extern_uid - The external UID for the user, if the provider is not GitLab
* provider - The user\'s provider, GitLab/LDAP/OmniAuth
