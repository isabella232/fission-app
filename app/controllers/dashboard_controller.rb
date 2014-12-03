class DashboardController < ApplicationController

  before_action :validate_access!, :except => [:summary]

  def summary
    respond_to do |format|
      format.js do
        flash[:error] = 'Unsupported request!'
        javascript_redirect_to repository_listing_endpoint
      end
      format.html do
        @cells = Smash.new.tap do |cells|
          current_user.run_state.current_account.products.each do |product|
            Rails.application.railties.engines.each do |eng|
              if(eng.respond_to?(:fission_product))
                if(eng.fission_product.include?(product))
                  if(eng.respond_to?(:fission_dashboard))
                    cells.merge!(eng.fission_dashboard(product).to_smash)
                  end
                end
              end
            end
          end
        end
      end
    end
  end

end
