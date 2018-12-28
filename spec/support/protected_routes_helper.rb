# frozen_string_literal: true

require 'faraday-cookie_jar'

module ProtectedRoutesHelper
  class Connection
    def initialize(email, password)
      @connection = Faraday.new(url: TOOLBOX_HOST) do |faraday|
        faraday.use :cookie_jar
        faraday.adapter Faraday.default_adapter
        faraday.response :json
      end

      start_session email, password
    end

    def start_session(email, password)
      @connection.post do |req|
        req.url 'barong/identity/sessions'
        req.headers['Content-Type'] = 'application/json'
        req.body "{ \"email\": \"#{email}\", \"password\": \"#{password}\" }"
      end
    end

    def get(path, params)
      @connection.get do |req|
        req.url path
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
    end

    def post(path, params)
      @connection.post do |req|
        req.url path
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
    end
  end
end
