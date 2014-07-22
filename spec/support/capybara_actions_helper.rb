require 'rspec/expectations'

module CapybaraActionsHelper
  #expected（お茶の名前）が、明細表に表示されているならtrue、表示されてないならfalseを返す。
  RSpec::Matchers.define :exist_in_table do |expected|
    match do |actual|
      begin
        tea_names = actual.all(:css, 'td.name').map(&:text)
        tea_names.include?(expected)
      rescue Capybara::ElementNotFound
        false
      end
    end
  end
end
