class DashboardController < ApplicationController

  before_action :validate_access!, :except => [:summary]

  def summary
    respond_to do |format|
      format.js do
        flash[:error] = 'Unsupported request!'
        javascript_redirect_to repository_listing_endpoint
      end
      format.html do
        products = current_user.run_state.current_account.products
        if(isolated_product?)
          products = products.find_all do |product|
            product == @product
          end
        end
        @cells = dashboard_cells(products)
        if(@cells.empty?)
          render 'dashboard/no_content'
        end
      end
    end
  end

  protected

  def dashboard_cells(products)
    Smash.new.tap do |cells|
      products.each do |product|
        Rails.application.railties.engines.each do |eng|
          if(eng.respond_to?(:fission_product))
            if(eng.fission_product.include?(product))
              if(eng.respond_to?(:fission_dashboard))
                args = [product, current_user]
                num_args = eng.method(:fission_dashboard).arity
                if(num_args >= 0)
                  args = args.slice(0, num_args)
                end
                cells.merge!(eng.fission_dashboard(*args))
              end
            end
          end
        end
      end
    end
  end

end
