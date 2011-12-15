require "ipcommerce/version"
require "ipcommerce/api"
require "ipcommerce/web_service"
require "ipcommerce/authentication"
require "ipcommerce/configuration"
require "ipcommerce/connection"
require "ipcommerce/web_service/service_information"
require "ipcommerce/web_service/transaction_processing"
require "ipcommerce/web_service/transaction_management"

require "net/http"
require "net/https"
require "base64"
require "date"
require "cgi"

module Ipcommerce
  
  class IpcommerceError < StandardError; end

	extend Configuration
	class << self
		# Alias for Ipcommerce::Web_service.new
		#
		# @return [Ipcommerce::Web_service]
		def new(options={})
			Ipcommerce::Web_service.new(options)
		end

		# Delegate to Ipcommerce::Web_Service
		def method_missing(method, *args, &block)
			return super unless new.respond_to?(method)
			new.send(method, *args, &block)
		end

		def respond_to?(method, include_private = false)
			new.respond_to?(method, include_private) || super(method, include_private)
			
		end
	end
  
end
