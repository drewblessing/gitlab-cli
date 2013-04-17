#!/usr/bin/ruby

class Snippet < Thor
  # ADD
  desc "add [PROJECT] [FILE]", "add a snippet"
  long_desc <<-D
    Add a snippet to a project.  You may specify a file to create a snippet from or you may pipe content from cat.
    [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [PROJECT_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id.
   
    $ gitlab snippet add namespace/project file1.txt

    $ cat file1.txt | gitlab snippet add namespace/project
  D
  option :title, :desc => "The title to use for the new snippet", :required => true, :type => :string, :aliases => ["-t"]
  option :file_name, :desc => "A file name for this snippet", :required => true, :type => :string, :aliases => ["-n", "-f"]  
  def add(project, file=nil)
    snippet = Gitlab::Util.snippet_create(project, options['title'], options['file_name'], file)

    printf "Snippet created.\nID: %s\nURL: %s\n", snippet.id, snippet.view_url
  end 

  ## VIEW
  desc "view [PROJECT] [SNIPPET_ID]", "view a snippet"
  long_desc <<-D
    View the content of a snippet. Content will be displayed in the default pager or in "less."

    [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [PROJECT_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id. [SNIPPET_ID] must be specified as the id of the snippet.  Use 'gitlab snippets [PROJECT]' command to view the snippets available for a project.

    $ gitlab snippet view namespace/project 6

    $ gitlab snippet view 10 6
  D
  def view(project, snippet)
    snippet = Gitlab::Util.snippet_view(project, snippet)    

    pager = ENV['pager'] || 'less'

    unless system("echo %s | %s" % [snippet.inspect, pager])
      STDERR.puts "Problem displaying snippet"
      exit 1
    end
  end

  ## EDIT
  desc "edit [PROJECT] [SNIPPET_ID]", "edit a snippet"
  long_desc <<-D
    Edit a snippet. Snippet will open in your default text editor or in "vi." 

    [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [PROJECT_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id. [SNIPPET_ID] must be specified as the id of the snippet.  Use 'gitlab snippets [PROJECT]' command to view the snippets available for a project.

    $ gitlab snippet edit namespace/project 6

    $ gitlab snippet edit 10 6
  D
  def edit(project, snippet)
    snippet_obj = Gitlab::Util.snippet_get(project, snippet)
    snippet_code = Gitlab::Util.snippet_view(project, snippet)

    editor = ENV['editor'] || 'vi'

    temp_file_path = "/tmp/snippet.%s" % [rand]
    File.open(temp_file_path, 'w') { |file| file.write(snippet_code) }

    system("vi %s" % [temp_file_path])

    snippet_code = File.read(temp_file_path)

    snippet = Gitlab::Util.snippet_update(project, snippet_obj, snippet_code)
    printf "Snippet updated.\n URL: %s\n", snippet.view_url
  end

  ## DELETE
  desc "delete [PROJECT] [SNIPPET_ID]", "delete a snippet"
  long_desc <<-D
    Delete a snippet. \n
    [PROJECT] may be specified as [NAMESPACE]/[PROJECT] or [SNIPPET_ID].  Use 'gitlab projects' to see a list of projects with their namespace and id. [SNIPPET_ID] must be specified as the id of the snippet.  Use 'gitlab snippets [PROJECT]' command to view the snippets available for a project.

    $ gitlab snippet delete namespace/project 6

    $ gitlab snippet delete 10 6
  D
  def delete(project, snippet)
    response = ask "Are you sure you want to delete this snippet? (Yes\\No)"
    exit unless response.downcase == 'yes'

    snippet = Gitlab::Util.snippet_delete(project, snippet)

#    printf "Successfully deleted snippet %s", snippet.title
  end
end

