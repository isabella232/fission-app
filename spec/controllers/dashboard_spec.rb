require 'spec_helper'

describe DashboardController do
    describe "GETS the index" do 
        it 'returns the index' do
            get :index
            expect(response.status).to eq(302)
        end
    end
end

