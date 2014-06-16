# spec/support/factory_girl.rb
RSpec.configure do |config|
  # additional factory_girl configuration

#orderとorder_detailのlintに通る書き方を考えたらコメントをはずす
  config.before(:suite) do
    begin
      DatabaseRewinder.start
      FactoryGirl.lint
    ensure
      DatabaseRewinder.clean
    end
  end
end
