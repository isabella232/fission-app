require 'fission-app'
require 'octokit'

module FissionApp
  module Commons

    # Build github API client
    #
    # @param ident [Symbol] :bot or :user
    # @return [Octokit::Client]
    def github(ident)
      Octokit.auto_paginate = true
      case ident
      when :bot
        token = Rails.application.config.settings.get(:github, :token)
      when :user
        token = current_user.token_for(:github)
      else
        raise "Unknown GitHub identity requested for use: #{ident.inspect}"
      end
      Octokit::Client.new(:access_token => token)
    end
    
  end
end
