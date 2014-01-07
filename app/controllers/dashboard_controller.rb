class DashboardController < ApplicationController

  def index
    @accounts = Account.restrict(current_user)
    @repos = Repository.restrict(current_user)
    # TODO: This needs to be timed and managed internally
    if(!current_user.session(:unregistered_repos))
      current_user.set_session(:unregistered_repos, unregistered_repos(@repos))
      current_user.save
    end
    @unregistered_repos = (current_user.session(:unregistered_repos) || []).map(&:with_indifferent_access)
  end

  protected

  def unregistered_repos(repos)
    registered_names = repos.map(&:name)
    fetch_github_repos(*current_user.managed_accounts.map(&:name)).find_all do |repo|
      !registered_names.include?(repo.full_name)
    end.sort{|x,y| x.full_name <=> y.full_name }.map do |repo|
      {:full_name => repo.full_name}.with_indifferent_access
    end
  end

end
