class FissionCell < Cell::Rails
  include FissionApp::Commons

  attr_reader :arguments
  
  protected

  def current_user
    @arguments[:current_user]
  end

end
