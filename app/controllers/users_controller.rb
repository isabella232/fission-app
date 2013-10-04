class UsersController < ApplicationController

  include BasicCrud

  before_action :validate_user!, :except => [:new, :create]
  restrict(:index => [:root, :account_admin])

  def new
    respond_to do |format|
      format.html do
        @identity = Identity.new
      end
    end
  end

end
