module Ipcommerce
	class Web_service < API

		def json_time(time)
			if (time.is_a? Time) then
				time=time.to_i
			end
			if (!time.is_a? String) then
				time="\/Date(#{time.to_int}000)\/"
			end
			time
		end
		
		def iso_time(time)
			if (time.is_a? Numeric) then
				time=Time.at(time)
			end
			if (time.is_a? Time) then
				time=time.iso8601
			end
			if (!time.is_a? String) then
				time=Time.now.iso8601
			end
			time
		end

		include Ipcommerce::Web_service::Service_information
		include Ipcommerce::Web_service::Transaction_processing
		include Ipcommerce::Web_service::Transaction_management
		
	end
end 
