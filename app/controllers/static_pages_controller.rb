class StaticPagesController < ActionController::Base

  before_action do
    @pages ||= {}.with_indifferent_access
    populate_static_data!
  end

  def display
    respond_to do |format|
      format.html do
        if(entry = @pages[params[:path]])
          @content = entry[:content]
        else
          # TODO: Needs proper 404ing
          flash[:error] = 'Requested page not found'
          redirect_to root_url
        end
      end
    end
  end

  private

  def populate_static_data!
    base_directory = Rails.application.config.fission.static_pages
    times = time_files_in(base_directory)
    times.each do |path, mtime|
      next if @pages[path] && @pages[path][:mtime] == mtime
      @pages[path] = {
        :mtime => mtime,
        :content => read_static_file(path)
      }.with_indifferent_access
    end
  end

  def read_static_file(path)
    if(path.end_with('.yml'))
      YAML.load(File.read(path))
    elsif(path.end_with('.json'))
      JSON.load(File.read(path))
    else
      raise "Unknown file extension type encountered on: #{path}"
    end
  end

  def time_files_in(dir)
    result = {}.with_indifferent_access
    Dir.glob(File.join(dir, '*')).each do |path|
      result[path] = File.mtime(path)
    end
    result
  end

end
