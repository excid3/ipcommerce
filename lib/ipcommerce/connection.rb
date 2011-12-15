module Ipcommerce
	module Connection
		# Do not call this method. This is used internally to send a request.
		
		
		URL = 'cws-01.cert.ipcommerce.com'.freeze
		ENDPOINT='/REST/2.0.16'.freeze
		def action_with_token(method, function, params={})

			#Each 
			svc_SvcInfo=[:token,:appProfile,:serviceInformation,:merchProfile]
			svc_Txn=[:Txn]
			svc_DataServices=[:transactionsFamily, :batch, :transactionsSummary, :transactionsDetail] #To be implemented
			##puts "action_with_token(#{function},#{params},#{method})"
			https = Net::HTTP.new(URL, Net::HTTP.https_default_port)
			https.use_ssl = true
			https.ssl_timeout = 2
			https.verify_mode = OpenSSL::SSL::VERIFY_NONE
			source = case 
				when svc_SvcInfo.include?(function); "SvcInfo"
				when svc_Txn.include?(function); ""
				when svc_DataServices.include?(function); "DataServices/TMS" #TODO:To Be Implemented
				else ""
			end
      body=params.delete :body
      target=params.delete :target
      action=function.to_s
      if (!target.nil?)then
        if (!target.is_a? Array) then target=[target.to_s] end
        target= #target can be a string or array
          target.join('/')+do_params(params)
          #the target uri. {target:['path','to','file'], params:{param1:"foo",param2:"bar"}}
      else
        target=""
        action+=do_params(params)
      end
      path=[ENDPOINT, source, action, target]
      path.delete("")
        #Deletes all empty values, to avoid a "//" within a path.
      path=path.compact.join("/")
      #puts "Sending to: #{path}"
			response=https.start { |http|

				request =case (method)
					when :get; Net::HTTP::Get.new(path)
					when :delete; Net::HTTP::Delete.new(path)
					when :put; Net::HTTP::Put.new(path)
					when :post; Net::HTTP::Post.new(path)
				end
				request.basic_auth(@session_token,"")
				request.set_content_type "application/json" #required
				request.delete "accept"	#if a non empty Accept header is sent, 
									#IPC server will send a text/xml response.
				#puts "Body Sent via #{method}","to #{path}:",body
				https.request(request, body)
			}
			if (function==:token and method==:get) then return response.body end 
			if (response.body.nil?) then return end
			begin
				g=JSON.parse(response.body)
			rescue JSON::ParserError
				begin
					g=Hash.from_xml(response.body)
					raise Ipcommerce::IpcommerceError, "An xml error was passed.\n"+g.to_s
				rescue REXML::ParseException
					response.body
				end
			end
			
		end
		
		def do_params(params)
			params=if (params.size>=1) then
					"?".concat(params.collect { |k,v| if v =="" then "" else "#{k}=#{CGI::escape(v.to_s)}" end }.join('&'))
			else "" end 
		
		end
		
	end
end
