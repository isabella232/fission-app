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

    # Check if engine is currently loaded within application
    #
    # @param name [String, Symbol] name of engine (or suffix with
    #   'fission-app' removed)
    # @return [TrueClass, FalseClass]
    def engine?(name)
      loaded = Rails.application.config.settings.fetch(:engines, [])
      name = name.to_s.tr('-', '_')
      loaded.include?(name) || loaded.map{|n| n.sub('fission_app_', '')}.include?(name)
    end

  end
end
