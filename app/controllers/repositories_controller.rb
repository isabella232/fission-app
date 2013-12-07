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
    repo = Repository.lookup(gh_repo.full_name, :github)
    unless(repo)
      repo = Repository.new(
        :name => gh_repo.full_name,
        :url => gh_repo.rels[:git].href,
        :clone_url => gh_repo.rels[:clone].href,
        :private => gh_repo.private
      )
      repo.owner = @account
      raise "Failed to save repository! #{repo.errors.inspect}" unless repo.save
    end
    # TODO: Needs to allow option passing for filter and url modification
    github.create_hook(
      gh_repo.full_name,'web', {
        :url => Rails.application.config.fission.rest_endpoint,
        :content_type => :json
      }, {
        :events => [:push],
        :active => true
      }
    )
    respond_to do |format|
      format.html do
        flash[:success] = "Repository Enabled! (#{gh_repo.full_name})"
        redirect_to account_repositories_url(@account)
      end
    end
  end

  def disable
  end

  protected

  def fetch_github_repos
    Fission::App::Jobs.fetch_all(github.org(@account.name), :repos)
  end

  def github
    Octokit::Client.new(:access_token => current_user.token_for(:github))
  end

end
