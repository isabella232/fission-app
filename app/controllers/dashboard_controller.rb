class DashboardController < ApplicationController

  def index
    @accounts = Account.restrict(current_user)
    @repos = Repository.restrict(current_user)
  end

end
