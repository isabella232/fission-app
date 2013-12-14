class StaticPagesController < ActionController::Base

  before_action do
    @pages ||= {}.with_indifferent_access
    populate_static_data!
  end

  def display
    respond_to do |format|
      format.html do
        key = params[:path].sub(%r{^/}, '')
        if(entry = @pages[key])
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
        :content => read_static_file(path, base_directory)
      }.with_indifferent_access
    end
  end

  def read_static_file(path, prefix=nil)
    if(prefix)
      path = Dir.glob(File.join(prefix, "#{path}*")).first
    end
    if(path.end_with?('.yml'))
      YAML.load(File.read(path))
    elsif(path.end_with?('.json'))
      JSON.load(File.read(path))
    else
      raise "Unknown file extension type encountered on: #{path}"
    end
  end

  def time_files_in(dir)
    result = {}.with_indifferent_access
    Dir.glob(File.join(dir, '**/*')).each do |path|
      next unless File.file?(path)
      key = path.sub(dir, '')
      key = key.sub(File.extname(key), '').sub(%r{^/}, '')
      result[key] = File.mtime(path)
    end
    result
  end

end
