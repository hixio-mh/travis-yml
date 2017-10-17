require 'spec_helper'

describe Travis::Yaml::Web::V1 do
  include Rack::Test::Methods

  def app
    described_class
  end

  describe 'GET /' do
    let!(:response) do
      get '/'
      Oj.load(last_response.body)
    end

    it 'is ok' do
      expect(last_response.status).to be 200
    end

    it 'is json' do
      expect(last_response.headers['Content-Type']).to eq 'application/json'
    end

    it 'returns version' do
      expect(response['version']).to eq 'v1'
    end
  end

  describe 'POST /parse' do
    let!(:response) do
      post '/parse', 'rvm: 2.3', {}
      Oj.load(last_response.body)
    end

    it 'is ok' do
      expect(last_response.status).to be 200
    end

    it 'is json' do
      expect(last_response.headers['Content-Type']).to eq 'application/json'
    end

    it 'returns version' do
      expect(response['version']).to eq 'v1'
    end

    it 'returns parsed config' do
      expect(response['config']).to include(rvm: ['2.3'])
    end

    it 'returns messages' do
      expect(response['messages']).to eq [
        '[info] on language: missing :language, defaulting to: ruby'
      ]
    end
  end
end
