# frozen_string_literal: true

class ProductsController < BaseController
  # INDEX
  get '/' do
    json Product.all
  end
  # SHOW
  get '/:id' do |id|
    json Product.find(id)
  end

  # POST
  post '/' do
    json Product.create!(params)
  end

  # DELETE
  delete '/:id' do |id|
    json Product.find(id).destroy
  end
end
