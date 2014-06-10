require 'rails_helper'

describe Item do
  it 'has many order_details' do
    association = Item.reflect_on_association(:order_details).macro
    expect(association).to eq(:has_many)
  end

  describe 'validation test' do
    it 'is valid with an unique name and positive number price' do
      item = Item.new(name: '紅茶', price: '1')
      expect(item).to be_valid
    end

    it 'is invalid with a blank name' do
      item = Item.new(price: '1')
      expect(item).to be_invalid
    end

    it 'is invalid with a same name' do
      Item.create(name: '紅茶', price: '1')
      duplicate_item = Item.new(name: '紅茶', price: '1')
      expect(duplicate_item).to be_invalid
    end

    it 'is invalid with an negative number price' do
      item = Item.new(name: '紅茶', price: '-1')
      expect(item).to be_invalid
    end
  end
end

