## Use as a library

First, require 'gitlab_cli'. 

`require 'gitlab_cli'`

Next, call the appropriate class and method within Gitlab CLI.  You will probably want to stick with calling the Util classes.  They will return objects with all the pertinent information. Below are a few examples of how you may use Gitlab CLI.  For a complete list of classes, methods and objects, please check out the links below.

* [Util Classes and Methods](Classes.md)
* [Objects](Objects.md)

### _Get all projects in Gitlab_ 
Returns an array of Project objects

`projects = GitlabCli::Util::Projects.get_all`

Then you can loop through and access any of the Project attributes.

```
projects.each do |project|
  puts project.name
end
```

### _Get a specific snippet_
Assumes you know the project id/full namespace and snippet id

`snippet = GitlabCli::Util::Snippet.get(3, 19)`

`snippet = GitlabCli::Util::Snippet.get("namespace/project_name", 19)`

Then you can access any of the Snippet attributes.

`puts snippet.title`

