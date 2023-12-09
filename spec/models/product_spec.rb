require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do

    it 'should save successfully with all four fields set' do
      category = Category.create(name: 'Flower')
      product = Product.new(
        name: 'Rose flower',
        price: 10.99,
        quantity: 5,
        category: category
      )
      expect(product.save).to be true
    end
    it 'should not save without a name' do
      category = Category.create(name: 'Flower')
      product = Product.new(
        price: 10.99,
        quantity: 5,
        category: category
      )
      product.save
      expect(product.errors.full_messages).to include("Name can't be blank")
    end

    it 'should not save without a price' do
      category = Category.create(name: 'Evergreens')
      product = Product.new(
        name: 'Gaint Tea',
        quantity: 5,
        category: category
      )
      product.save
      expect(product.errors.full_messages).to include("Price can't be blank")
    end

    it 'should not save without a quantity' do
      category = Category.create(name: 'Shrubs')
      product = Product.new(
        name: 'Sweet Hops',
        price: 10.99,
        category: category
      )
      product.save
      expect(product.errors.full_messages).to include("Quantity can't be blank")
    end
    it 'should not save without a category' do
      product = Product.new(
        name: 'Rose flower',
        price: 10.99,
        quantity: 5
      )
      product.save
      expect(product.errors.full_messages).to include("Category can't be blank")
    end
  end
end
