module Ipcommerce
	module Authentication
		
		def ready? 
			validate_session(false)
		end
		
		def sign_on_with_token()
			@ready_state=0
			@renew_time=0
			@session_token=identity_token
			#puts "Signing on..."
			s=action_with_token(:get,:token)
			@session_token=s[1,s.length-2] #remove quotes
			if (!@session_token.nil?) then @ready_state=1; end
			#We can now check if an identity token was returned.
			if (validate_session) then
				#puts "Done",""; true
			else
				#puts "Failed",""; false
			end
		end
	
	
		def validate_session(revalidate=nil)
			if (revalidate.nil?)
				revalidate=@revalidate; end
			if (@ready_state==1) then
				session_info=Nokogiri::XML(Base64.decode64(@session_token))
				##puts "Session Info from saml Token:",session_info
				begin
					renew_time=session_info.xpath("//saml:Assertion/saml:Conditions/@NotOnOrAfter").text
				rescue Nokogiri::XML::XPath::SyntaxError => e
					#puts "A Saml session token was not returned by SignOnWithToken. Check that the identity token provided is valid for this version.",""
					@ready_state=0;
					return false
				end
				if (renew_time.nil?) then; @ready_state=0; return false; end;
				#Setting ready_state to zero prevents any automatic signons, and all subsequent calls to
				#validate_session return false.
				@renew_time=DateTime.parse(renew_time)
				#printf "Session is valid until: %00d:%02d\n", @renew_time.hour(),@renew_time.min()
				@ready_state=2
        save()
			elsif (@ready_state>=2) then
				if (@renew_time <= DateTime.now) then
					if (!revalidate)
						return false; end
					load()
					if (@renew_time > DateTime.now) then
						#puts "Expired session was renewed by another process."
						return true;
					end
					#puts "Expired session will be renewed."
					sign_on_with_token
				end
			else
				return false
			end
			true	
		end
	end
end
