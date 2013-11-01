describe "User information" do
  before do
    Identity.find_or_create_via_omniauth(uid: "tickel")
    ENV['ALLOW_NO_AUTH'] = "true"
  end

  it "lists user information" do
    get "/users"
  end
end
