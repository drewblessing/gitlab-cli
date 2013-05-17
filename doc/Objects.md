## Objects

### _Project_

Attributes:

* id                          The numerical ID of the project
* name                        The name of the project
* description                 A long description of the project
* default_branch              The default branch to display in the interface
* public                      Is the project public? True/False
* path                        The short path for the project
* path_with_namespace         The full path with namespace for the project
* issues_enabled              Can issues be created? True/False
* merge_requests_enabled      Accept merge requests for the project? True/False
* wall_enabled                Is the wall enabled? True/False
* wiki_enabled                Is the wiki enabled? True/False
* created_at                  The date/time the project was created
* project_url                 The URL to the project
* owner                       The owner of the project (returns a User object)

### _Snippet_

* id
* title
* file_name
* expires_at
* updated_at
* created_at
* project_id
* view_url
* author

### _User_

* id
* username
* email
* name
* blocked
* created_at
* bio
* skype
* linkedin
* twitter
* extern_uid
* provider
