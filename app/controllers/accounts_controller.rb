class AccountsController < ApplicationController
  include BasicCrud

  render_overrides :show => true

end
