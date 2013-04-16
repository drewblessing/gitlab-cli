#!/usr/bin/ruby

class Snippet < Thor
  desc "add <project> <file>", "add a snippet"
  long_desc <<-D
    Add a snippet to a project.  You may specify a file to create a snippet from or you may pipe content from cat.
    <project> may be specified as <namespace>/<project> or <project_id>.  Use 'gitlab projects' to see a list of projects with their namespace and id. <snipped_id> must be specified as the id of the snippet. 
   
    $ gitlab snippet add namespace/project file1.txt

    $ cat file1.txt | gitlab snippet add namespace/project
  D
  option :title, :desc => "The title to use for the new snippet", :type => :string, :aliases => ["-t"]
  option :file_name, :desc => "A file name for this snippet", :type => :string, :aliases => ["-n"]  
  def add(project, file=nil)
    snippet = Gitlab::Util.snippet_create(project, options['title'], options['file_name'], file)

    printf "Snippet created.\nID: %s\nURL: %s\n", snippet.id, snippet.view_url
  end 

  desc "view <project> <snippet_id>", "view a snippet"
  long_desc <<-D
    View the content of a snippet. Content will be displayed in the default pager or in "less." \n
    <project> may be specified as <namespace>/<project> or <project_id>.  Use 'gitlab projects' to see a list of projects with their namespace and id. <snipped_id> must be specified as the id of the snippet.  Use 'gitlab snippets <project>' command to view the snippets available for a project.
  D
  def view(project, snippet)
    snippet = Gitlab::Util.snippet_view(project, snippet)    

    pager = ENV['pager'] || 'less'

    unless system("echo %s | %s" % [snippet.inspect, pager])
      STDERR.puts "Problem displaying snippet"
      exit 1
    end
  end

  desc "edit <project> <snippet_id>", "edit a snippet"
  long_desc <<-D
    Edit a snippet. Snippet will open in your default text editor or in "vi." \n
    <project> may be specified as <namespace>/<project> or <project_id>.  Use 'gitlab projects' to see a list of projects with their namespace and id. <snipped_id> must be specified as the id of the snippet.  Use 'gitlab snippets <project>' command to view the snippets available for a project.
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

  desc "delete <project> <snippet_id>", "delete a snippet"
  long_desc <<-D
    Delete a snippet. \n
    <project> may be specified as <namespace>/<project> or <project_id>.  Use 'gitlab projects' to see a list of projects with their namespace and id. <snipped_id> must be specified as the id of the snippet.  Use 'gitlab snippets <project>' command to view the snippets available for a project.
  D
  def delete(project, snippet)
    response = ask "Are you sure you want to delete this snippet? (Yes\\No)"
    exit unless response.downcase == 'yes'

    snippet = Gitlab::Util.snippet_delete(project, snippet)

#    printf "Successfully deleted snippet %s", snippet.title
  end
end

