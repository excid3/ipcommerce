module Ipcommerce

	module Configuration
		VALID_OPTIONS_KEYS = [
			:identity_token,
			:application_id,
			:session_token,
			:profile_id,
			:testing,
			:revalidate,
			:ready_state,
			:renew_time].freeze
		
		attr_accessor *VALID_OPTIONS_KEYS
		
		
		APPLICATION_ID=12494
		PROFILE_ID="TestProfile"
		REVALIDATE=true
		READY_STATE=0
		RENEW_TIME=0

		def save()
			g=File.open(File.dirname($PROGRAM_NAME)+"/config.dat","wb")
			g.write(Marshal.dump(options))
			g.close
			@application_id;
		end
		
		# This will be called if new() is called without an identity token.
		def load()
			if (!File.exists?File.dirname($PROGRAM_NAME)+"/config.dat") then 
				#puts "Warning, the config.dat file was not found in the same directory as the running application."; 
				return false;
			end
			f=File.open(File.dirname($PROGRAM_NAME)+"/config.dat","rb")
			config=Marshal.load(f.read)
			f.close
			reset()
			@identity_token, 
			@application_id,
			@session_token, 
			@profile_id,
			@testing,
			@revalidate,
			@ready_state,
			@renew_time = config.values_at *VALID_OPTIONS_KEYS
			validate_session(false)
		end
		
		# When Ipcommerce is initialized, this module
		# is extended, setting all configuration options to their default values
		def self.extended(base)
			base.reset
		end
		
		# Convenience method to allow configuration options to be set in a block
		def configure()
			yield self
		end
		
		# Create a hash of options and their values
		def options
			options = {}
			VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
			options
		end
		
		def reset
			@identity_token	= ""
			@application_id	= APPLICATION_ID
			@session_token	= ""
			@profile_id		= PROFILE_ID
			@ready_state	= 0
			@renew_time		= 0
			self
		end
		
		
	end

end
