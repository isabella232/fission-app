require 'spec_helper'

describe 'Validate Home Page', :type => :feature do
  before do
    Identity.find_or_create_via_omniauth(uid: "foo")
    ENV['ALLOW_NO_AUTH'] = "true"
  end

  it 'visits the homepage' do
    visit '/'
    page.should have_content('Fission')
  end
end
