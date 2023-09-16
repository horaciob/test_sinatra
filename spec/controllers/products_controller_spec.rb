# frozen_string_literal: true

describe ProductsController, type: :controller do
  def app
    described_class.new
  end

  let(:response_json) { JSON.parse(last_response.body) }
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }
  let(:valid_params) do
    { name: 'New Product', code: 'whatever', price: 15.99 }
  end

  describe 'GET /' do
    it 'returns a list of products' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(response_json).to be_an(Array)
    end
  end

  describe 'GET /:id' do
    it 'returns a single product' do
      product = create(:product)

      get "/#{product.id}"

      expect(last_response.status).to eq(200)
      expect(response_json['name']).to eq(product.name)
    end

    it 'returns a 404 status for non-existent product' do
      get '/12345' # assuming ID 12345 doesn't exist
      expect(last_response.status).to eq(404)
    end
  end

  describe 'POST /' do
    it 'creates a new product' do
      post '/', valid_params.to_json, headers

      expect(last_response.status).to eq(200)
      expect(response_json['name']).to eq('New Product')
    end

    context 'when fails' do
      it 'fails when no name' do
        invalid_params = valid_params.except(:name)

        post '/', invalid_params.to_json, headers

        expect(last_response.status).to eq(422)
      end

      it 'fails when no code' do
        invalid_params = valid_params.except(:code)

        post '/', invalid_params.to_json, headers

        expect(last_response.status).to eq(422)
      end

      it 'fails when no price' do
        invalid_params = valid_params.except(:price)

        post '/', invalid_params.to_json, headers

        expect(last_response.status).to eq(422)
      end
    end
  end

  describe 'DELETE /:id' do
    it 'deletes a product' do
      product = create(:product)

      delete "/#{product.id}"

      expect(last_response.status).to eq(200)
      expect(Product).not_to exist(product.id)
    end

    context 'when fails' do
      it 'returns a 404 status for non-existent product' do
        delete '/12345' # assuming ID 12345 doesn't exist
        expect(last_response.status).to eq(404)
      end
    end
  end
end
