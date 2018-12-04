module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'; stream_packages_path
    when /^the signin\s?page$/
      signin_path
    when /^the new stream packages\s?page$/
      new_stream_package_path
    when /^the channels\s?page$/
      channels_path
    when /^the user home\s?page$/
      user_input_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
    
    when /^the edit page for "(.*)"$/i
      edit_stream_package_path(StreamPackage.find_by_name($1))
    
    when /^the details page for "(.*)"$/i
      stream_package_path(StreamPackage.find_by_name($1))

    when /^the channel details page for "(.*)"$/i
      channel_path(Channel.find_by_name($1))
      
    when /^the edit channel page for "(.*)"$/i
      edit_channel_path(Channel.find_by_name($1))

    when /^the similar movies page for "(.*)"$/i
      @movie = Movie.find_by_title($1)
      same_director_movies_path(@movie)
      
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
