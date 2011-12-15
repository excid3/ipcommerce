module Ipcommerce
	class Web_service
		module Service_information
			
			def get_application_data(application_id=nil, save=false)
				if (!self.validate_session())
					return false; end
					
				application_id||=@application_id
				
				#puts "Getting applicaton data for #{application_id}..."
				application_data=action_with_token(:get, :appProfile, {target:application_id.to_s})
				#if not error
				#puts "Result:",application_data,"Done",""
				if (save) then
					@application_id=application_id
					save()
				end
				application_data
			end
			
			#Requires application_data which contains an xml 
			def save_application_data(application_data)
				application_data[:SoftwareVersionDate]=json_time(application_data[:SoftwareVersionDate])
				application_data=JSON.generate(application_data)
				if (!self.validate_session())
					return false; end
				
				#puts "Saving applicaton data..."
				result=action_with_token(:put, :appProfile, {body:application_data})
				#puts "Result:",result
				@application_id=result["id"]
				save()
				#puts "Done",""
				@application_id
			end
			
			
			def delete_application_data(application_id=0, force=false)
				if (!self.validate_session())
					return false; end
				if (@application_id==application_id and !force) then 
					#puts "Possible accidental deletion of current running application prevented.","Call delete_application_data(#{application_id}, true) to override."
					return
				end
				
				#puts "Deleting applicaton profile..."
				result=action_with_token(:delete, :appProfile, {target:application_id.to_s})
				#puts "Done",""
				
				if (@application_id==application_id) then @application_id=nil; end
			end
			
			
			def get_service_information()
				
				if (!self.validate_session())
					return false; end
				
				#puts "Getting service information..."
				
				services=action_with_token(:get,:serviceInformation)
				
				
				#puts "Done",""
				services
				
			end
			
			
			def service_name(service_id)
				if service_id.is_a? Hash then service_id=service_id["ServiceId"] end
				case service_id
						#Sandbox
					when "214DF00001"; "Chase Paymentech Orbital - Tampa"
					when "B51E100001"; "Chase Paymentech Orbital - Salem"
					when "7B62B00001"; "First Data - Nashville"
					when "786F400001"; "Chase Paymentech Orbital - Tampa Retail"
					when "A656D00001"; "First Data - Nashville US"
					when "4CACF00001"; "Chase Tampa Direct TCS"
					when "3E2DE00001"; "RBS Global Gateway"
					when "832E400001"; "RBS Worldpay"
					when "C82ED00001"; "TSYS Sierra"
					when "5A38100001"; "Tampa - Canada"
					when "71C8700001"; "TSYS Sierra Canada"
					when "8335000001"; "TSYS Summit"
					when "A4F2B00001"; "Salem Direct"
					when "E4FB800001"; "First Data - Nashville"
					when "16E5800001"; "Intuit QBMS"
					when "A8CFF00001"; "First Data BUYPASS"
					when "36EBE00001"; "Tampa TCS for Canada"
					when "6429C00001"; "Intuit QBMS Inline Tokenization"
					when "8046100001"; "Intuit QBMS No Tokenization"
					when "207CE00001"; "Adaptive Payments"
					when "88D9300001"; "Fifth Third Payment Services FTPS"
					when "8077500001"; "Intuit QBMS Inline Tokenization"
					when "B447F00001"; "Fifth Third Payment Services FTPS"
						#Production
					when "C97EF1300C"; "Chase Paymentech Orbital - Tampa" 
					when "8A4B91300C"; "Chase Paymentech Orbital - Salem"
					when "19F161300C"; "First Data - Nashville"
					when "3257B1300C"; "Chase Paymentech Orbital - Tampa Retail"
					when "859AC1300C"; "First Data - Nashville US"
					when "633511300C"; "Chase Tampa Direct TCS"
					when "355931300C"; "RBS Global Gateway"
					when "8CEA11300C"; "RBS Worldpay"
					when "168511300C"; "TSYS Sierra"
					when "852BB1300C"; "Tampa - Canada"
					when "507BF1300C"; "TSYS Sierra Canada"
					when "55C3C1300C"; "TSYS Summit"
					when "D1DDF1300C"; "Salem Direct"
					when "D917B1300C"; "First Data - Nashville"
					when "7AC431300C"; "Intuit QBMS"
					when "7B4DD1300C"; "First Data BUYPASS"
					when "9461F1300C"; "Tampa TCS for Canada"
					when "CE4AE1300C"; "Intuit QBMS Inline Tokenization"
					when "E7DFB1300C"; "Intuit QBMS No Tokenization"
					when "CAFF61300C"; "Adaptive Payments"
					when "9999999999"; "Fifth Third Payment Services FTPS"
					else; "Unknown Service"
				end
			end
			
			
			#Requires merchant_profile which is an xml string or object implementing to_s()
			#The rest endpoint can accept multiple merchant_profiles, however this function
			#implements save_merchant_profiles for one profile for improved clarity.
			
			def save_merchant_profile(merchant_profile, serviceId="")
				merchant_profile[:LastUpdated]=json_time(merchant_profile[:LastUpdated])

				merchant_profiles_list= "["+
					JSON.generate(merchant_profile)+
					"]";
					
					
				save_merchant_profiles(merchant_profiles_list, serviceId)
			end
			
			def save_merchant_profiles(merchant_profiles, serviceId="")
				if (!self.validate_session())
					return false; end
				
				#puts "Saving merchant profiles..."
				returnVal=action_with_token(:put, :merchProfile,{
						body:merchant_profiles.to_s,
						serviceId:serviceId
						})
				
				puts returnVal
				
				#puts "Done",""
				#JSON.parse(returnVal)
			end
			
			
			def is_merchant_profile_initialized(merchant_profile_id, serviceId="")
				if (!self.validate_session())
					return false; end
				
				#puts "Checking if merchant profile is initialized..."
				returnVal=action_with_token(:get, :merchProfile,{
					target:[merchant_profile_id, "OK"],
					serviceId:serviceId
					})
				#puts "Result:",returnVal
				
				#puts "Done",""
				returnVal=="true"
			end
			
			def get_merchant_profile(merchant_profile_id=nil, serviceId="")
				if (!self.validate_session())
					return false; end
				
				#puts "Getting merchant profile..."
				merchant_profile=action_with_token(:get, :merchProfile,{
					target:merchant_profile_id,
					serviceId:serviceId
					})
				#puts "Result:",merchant_profile
				
				#puts "Done",""
				merchant_profile
			end
			
			def delete_merchant_profile(merchant_profile_id, serviceId="")
				if (merchant_profile_id.is_a? Hash) then
					merchant_profile_id=merchant_profile_id["ProfileId"]
				end
				if (!self.validate_session())
					return false; end
				
				#puts "Deleting merchant profile..."
				merchant_profile=action_with_token(:delete, :merchProfile,{
					target:merchant_profile_id,
					serviceId:serviceId
					})
				rescue Ipcommerce::IpcommerceError
					#puts "Failed to delete merchant profile. Perhaps it doesn't exist?"
				#puts "Done",""
			end
			
			
		end 
	end
end
