require 'net/http'
require 'json'
require 'hashie'

module OpenSource
  class LicensesAPI
    def initialize(base_url: 'https://api.opensource.org')
      @base_url = base_url
    end

    def all
      request 'licenses/'
    end

    def tagged(tag)
      request "licenses/#{tag}"
    end

    def get(id)
      request "license/#{id}"
    end

    private

    def request(resource)
      response = Net::HTTP.get_response URI "#{@base_url}/#{resource}"
      raise KeyError, "Resource not found: #{resource}" unless response.is_a? Net::HTTPOK
      JSON.parse(response.body).map { |o| Hashie::Mash.new o }
    end
  end
  Licenses = LicensesAPI.new
end
