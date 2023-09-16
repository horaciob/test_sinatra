# frozen_string_literal: true

require './app'

map '/products' do
  run ProductsController
end
