require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products
	test "product attributes must not be empty" do
		product = Product.new
		assert product.invalid?
		assert product.errors[:title].any?
		assert product.errors[:description].any?
		assert product.errors[:price].any?
		assert product.errors[:image_url].any?
	end

	test "product price must be positive" do
		product = Product.new(title: "Title1",
							  description: "Test for positive price",
							  image_url: "some_image.jpg")
		product.price = -1
		assert product.invalid?
		assert_equal "must be greater then or equal to 0.01",
		product.errors[:price].join('; ')

		product.price = 0
		assert product.invalid?
		assert_equal "must be greater then or equal to 0.01",
		product.errors[:price].join('; ')

		product.price = 1
		assert product.valid?	
	end

	test "product is not valid without a unique title" do
		product = Product.new(title: products(:product_from_stand).title,
			description: "yyy",
			price: 1,
			image_url: "pic.jpg")

		assert !product.save
		assert_equal "has already been taken", product.errors[:title].join('; ')
		#I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join('; ')
	end

	test "product must have an unique title" do
		product = Product.new(products(:one))
		product.save
		product = Product.new(products(:two))
		assert !product.save
		assert_equal "has already been taken", product.errors[:title].join('; ')
		#I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join('; ')
	end

  # test "the truth" do
  #   assert true
  # end
end
