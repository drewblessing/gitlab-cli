## Use as a library

First, require 'gitlab_cli'. `require 'gitlab_cli'`

Next, call the appropriate class and method within Gitlab CLI.  You will probably want to stick with calling the Util classes.  They will return objects with all the pertinent information. Below are a few examples of how you may use Gitlab CLI.  For a complete list of classes, methods and objects, please check out the link below.

* [Util Classes and Methods](https://github.com/drewblessing/gitlab-cli/blob/master/doc/Classes.md)
* [Objects](https://github.com/drewblessing/gitlab-cli/blob/master/doc/Classes.md)

### _Get all projects in Gitlab_ 
Returns an array of Project objects

`projects = GitlabCli::Util::Projects.get_all`

### _Get a specific snippet_
Assumes you know the project id/full namespace and snippet id_

`snippet = GitlabCli::Util::Snippet.get(3, 19)`

`snippet = GitlabCli::Util::Snippet.get("namespace/project_name", 19)`

