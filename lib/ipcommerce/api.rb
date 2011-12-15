require_relative 'configuration'
require_relative 'authentication'
require_relative 'connection'

module Ipcommerce
	# @private
	class API
		include Configuration
		include Authentication
		include Connection

		# @private
		attr_accessor *Configuration::VALID_OPTIONS_KEYS

		# Creates a new API
    def initialize(options={})
			config = Ipcommerce.options.merge(options)
		
			@identity_token, 
			@application_id,
			@session_token, 
			@profile_id,
			@testing,
			@revalidate,
			@ready_state,
			@renew_time = config.values_at *VALID_OPTIONS_KEYS
			
      if  options[:identity_token].nil? and options.has_key?:identity_token then
         puts "Please modify application_and_merchant_setup.rb to include a valid identity token."
       
         exit
      end
      
			if (!validate_session() and @identity_token.is_a? String and !@identity_token.empty?) then
				sign_on_with_token();
			end

			if (@ready_state<1) then
			  load()
			  
			  if (!validate_session() ) then
			    if (@identity_token.is_a? String or @identity_token.empty?) then
			      sign_on_with_token()
			    end
			    if (!validate_session()) then 
  				  puts "Initialized class, but no session was activated. Make sure application_and_merchant setup was run first, and a valid identity token was supplied.",""
            exit
          end
        end
			end
		end
	end
end
