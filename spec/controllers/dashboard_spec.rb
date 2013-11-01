require 'spec_helper'

describe DashboardController do
    before do
      Identity.find_or_create_via_omniauth(uid: "bar")
      ENV['ALLOW_NO_AUTH'] = "true"
    end

    describe "GETS the index" do 
        it 'returns the index' do
            get :index
            expect(response.status).to eq(200)
        end
    end
end

