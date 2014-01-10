require 'fission-app-jobs/utils'

class RepositoriesController < ApplicationController

  include BasicCrud

  before_action do
    @account = Account[params[:account_id]]
  end

  def index
    @registered = @account.repositories.sort{|x,y| x.name <=> y.name}
    registered_names = @registered.map(&:name)
    @unregistered = fetch_github_repos.find_all do |repo|
      !registered_names.include?(repo.full_name)
    end.sort{|x,y| x.full_name <=> y.full_name }
    respond_to do |format|
      format.html{ apply_render }
    end
  end

  def enable
    gh_repo = github.repository(Base64.decode64(params[:repository_id]))
    account = @account || Account.find_by_name(gh_repo.full_name.split('/').first)
    if(account.stripe_id)
      repo = Repository.lookup(gh_repo.full_name, :github)
      endpoint = URI.parse(Rails.application.config.fission.rest_endpoint)
      if(params[:filter_branch] && !params[:filter_branch].strip.empty?)
        endpoint.query = "filter=#{params[:filter_branch]}"
      else
        endpoint.query = 'filter=master'
      end
      unless(repo)
        repo = Repository.new(
          :name => gh_repo.full_name,
          :url => gh_repo.rels[:git].href,
          :clone_url => gh_repo.rels[:clone].href,
          :private => gh_repo.private
        )
        repo.owner = account
        raise "Failed to save repository! #{repo.errors.inspect}" unless repo.save
      end
      result = github.create_hook(
        gh_repo.full_name,'web', {
          :url => endpoint.to_s,
          :content_type => :json
        }, {
          :events => [:push],
          :active => true
        }
      )
      repo.set_metadata(:github, :hook, :web, result.id)
      repo.save
      respond_to do |format|
        format.html do
          flash[:success] = "Repository Enabled! (#{gh_repo.full_name})"
          redirect_to @account ? account_repositories_url(@account) : root_url
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:info] = 'Cannot enable repository until account is enabled'
          session[:repo_enable_account_redirect] = params.dup
          redirect_to account_order_url(account)
        end
      end
    end
  end

  def disable
    repo = Repository[params[:repository_id]]
    hook_id = repo.get_metadata(:github, :hook, :web)
    if(hook_id)
      github.remove_hook(repo.name, hook_id)
    end
    repo.delete
    respond_to do |format|
      format.html do
        flash[:success] = "Repository Removed! (#{repo.name})"
        redirect_to account_repositories_url(@account)
      end
    end
  end

end
