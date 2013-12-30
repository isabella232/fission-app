class DashboardController < ApplicationController

  def index
    @accounts = Account.restrict(current_user)
    @repos = Repository.restrict(current_user)
    @unregistered_repos = unregistered_repos(@repos)
  end

  protected

  def unregistered_repos(repos)
    registered_names = repos.map(&:name)
    fetch_github_repos(*current_user.managed_accounts.map(&:name)).find_all do |repo|
      !registered_names.include?(repo.full_name)
    end.sort{|x,y| x.full_name <=> y.full_name }
  end

end
