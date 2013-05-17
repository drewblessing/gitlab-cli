## Util Classes and Methods

The 'util' classes are what you should use to interact with Gitlab CLI as a library. 

### _Projects_

GitlabCLI::Util::Projects

\#get_all - Returns an array of Project objects.

### _Project_

GitlabCLI::Util::Project

\#get(project) - When given a project ID/full path with namespace, returns a Project object.
\#get_project_path_with_namespace(project_id) - When given a project ID, returns the full path with namespace.

### _Snippets_

GitlabCLI::Utils::Snippets

\#get_all(project) - When given a project ID/full path with namespace, returns an array of Snippet objects.

### _Snippet_

GitlabCLI::Util::Snippet

\#get(project, snippet) - When given a project ID/full path with namespace and a snippet ID, returns a Snippet object.
\#create(project, title, file_name, code) - When given a project ID/full path with namespace, title, file name string, and code body, creates a snippet and returns a Snippet object.
\#view(project, snippet) - When given a project ID/full path with namespace and a snippet ID, returns raw snippet content.
\#update(project, snippet, content) - When given a project ID/full path with namespace, snippet ID, and code body, updates a snippet\'s content and returns a Snippet object.
\#delete(project, snippet) - When given a project ID/full path with namespace and a snippet ID, deletes a snippet.
\#download(project, snippet, file_path) - When given a project ID/full path with namespace, snippet ID, and a local file path, saves a snippet\'s content to the specified file.
