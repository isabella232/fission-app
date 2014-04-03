class DashboardController < ApplicationController

  def index
    @accounts = Account.restrict(current_user)
    @repos = Repository.restrict(current_user)
    @unregistered_repos = unregistered_repos(@repos)
    @repos = {}.tap do |reps|
      @repos.each do |repo|
        unless(reps[repo.owner.name])
          reps[repo.owner.name] = []
          unless(repo.owner.tokens && !repo.owner.tokens.empty?)
            repo.owner.create_token
          end
        end
        reps[repo.owner.name] << repo
      end
    end
  end

  protected

  def unregistered_repos(repos)
    registered_names = repos.map(&:name)
    unless(current_user.session.get(:repositories, :github))
      current_user.session.put(
        :repositories, :github,
        fetch_github_repos(*current_user.managed_accounts.map(&:name)).map(&:full_name)
      )
    end
    current_user.session.get(:repositories, :github).find_all do |repo_name|
      !registered_names.include?(repo_name)
    end.sort{|x,y| x <=> y }.map do |repo_name|
      {:full_name => repo_name}.with_indifferent_access
    end
  end

end
