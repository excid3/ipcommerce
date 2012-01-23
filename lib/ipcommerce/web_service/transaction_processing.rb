module Ipcommerce
	class Web_service
		module Transaction_processing
			
			REST_SCHEMA=":http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Rest"
			
			def authorize_and_capture(transaction, merchant_profile_id=nil, workflow_id=nil)
				merchant_profile_id||=@merchant_profile_id;
				workflow_id||=@workflow_id;
				
				request={
					__type:"AuthorizeAndCaptureTransaction"+REST_SCHEMA,
					ApplicationProfileId: @application_id,
				    MerchantProfileId: merchant_profile_id,
				    Transaction: {__type: "BankcardTransaction:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Bankcard"}
    			}
    			transaction[:TransactionData][:TransactionDateTime]=iso_time(transaction[:TransactionData][:TransactionDateTime])
				request[:Transaction].update(transaction)

				request=JSON.generate(request)
				#puts request
				if (!self.validate_session())
					return false; end
				
				#puts "Submitting authorize and capture..."
				response=action_with_token(:post,:Txn,{body:request, target:workflow_id.to_s})
				#puts "Done"
				#puts response
				response
			end
			
			def authorize(transaction, merchant_profile_id=nil, workflow_id=nil)
				merchant_profile_id||=@merchant_profile_id;
				workflow_id||=@workflow_id;
				
				request={
					__type: "AuthorizeTransaction"+REST_SCHEMA,
				    ApplicationProfileId: @application_id,
				    MerchantProfileId: merchant_profile_id,
				    Transaction: {__type: "BankcardTransaction:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Bankcard"}
    			}
        transaction[:TransactionData][:TransactionDateTime]=iso_time(transaction[:TransactionData][:TransactionDateTime])
				request[:Transaction].update(transaction)
				puts request
				request=JSON.generate(request)
				#puts request
				if (!self.validate_session())
					return false; end
				
				#puts "Submitting authorize..."
				response=action_with_token(:post,:Txn,{body:request, target:workflow_id.to_s})
				#puts "Done"
				#puts response
				response
			end
			
			def adjust(transaction_id, tip=0, workflow_id=nil)
				workflow_id||=@workflow_id;
				
				request={
					__type: "Adjust:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Rest",
					ApplicationProfileId: @application_id,
					DifferenceData:{
						__type: "Adjust:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions",
						TransactionId: transaction_id,
						TipAmount: tip,
						Addendum: nil,
						PINDebitReason: 0,
						TenderData: nil
					}
				}
				request=JSON.generate(request)
				#puts request
				if (!self.validate_session())
					return false; end
				
				#puts "Submitting adjust..."
				response=action_with_token(:put,:Txn,{body:request, target:[workflow_id,transaction_id]})
				#puts "Done"
				#response
			end
			
			def undo(transaction_id,workflow_id)
				workflow_id||=@workflow_id;
				
				request={
					__type: "Undo:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Rest",
					ApplicationProfileId: @application_id,
					DifferenceData:{
						__type: "BankcardUndo:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Bankcard",
						TransactionId: transaction_id,
						Addendum: nil,
						PINDebitReason: 0,
						TenderData: nil
					}
				}
				request=JSON.generate(request)
				puts request
				if (!self.validate_session())
					return false; end
				
				#puts "Submitting undo..."
				response=action_with_token(:put,:Txn,{body:request, target:[workflow_id,transaction_id]})
				#puts "Done"
				#puts response
				response
			end
			alias void undo
			
			#WORKS
			def capture(transaction_id, diff_data, merchant_profile_id, workflow_id)
				if (transaction_id.is_a? Hash and transaction_id.has_key? "TransactionId") then
					transaction_id=transaction_id["TransactionId"]
				elsif (!transaction_id.is_a? String || transaction_id.nil?)
					#puts "Invalid first parameter transaction_id = #{transaction_id}"
					return false
				end
				request={
					__type: "Capture:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Rest",
					ApplicationProfileId: @application_id,
					DifferenceData:{
						__type: "BankcardCapture:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Bankcard",
						TransactionId: transaction_id,
						Addendum: nil
					}
				}
				request[:DifferenceData].merge(diff_data)
				request=JSON.generate(request)
				#puts request
				if (!self.validate_session())
					return false; end
				
				#puts "Submitting capture..."
				response=action_with_token(:put,:Txn,{body:request, target:[workflow_id,transaction_id]})
				#puts "Done"
				#puts response
				response
			end
			
			def capture_selective(merchant_profile_id, workflow_id, transaction_ids, difference_data=[])
				request={
					__type: "CaptureSelective:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Rest",
					ApplicationProfileId: @application_id,
					TransactionIds:transaction_ids,
					DifferenceData:difference_data
				}
				request=JSON.generate(request)
				#puts request
				if (!self.validate_session())
					return false; end
				
				#puts "Submitting capture selective..."
				response=action_with_token(:put,:Txn,{body:request, target:workflow_id})
				#puts "Done"
				#puts response
				response
				
			end
			
			def capture_all(merchant_profile_id, workflow_id)
				
				request={
					__type: "CaptureAll:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Rest",
					ApplicationProfileId: @application_id,
					BatchIds: [],
					MerchantProfileId:merchant_profile_id
				}
				request=JSON.generate(request)
				#puts request
				if (!self.validate_session())
					return false; end
				
				#puts "Submitting capture all..."
				response=action_with_token(:put,:Txn,{body:request, target:workflow_id})
				#puts "Done"
				#puts response
				response
			end
			
			def return_by_id(transaction_id, diff_data, merchant_profile_id, workflow_id)
				if (transaction_id.is_a? Hash and transaction_id.has_key? "TransactionId") then
					transaction_id=transaction_id["TransactionId"]
				elsif (!transaction_id.is_a? String || transaction_id.nil?)
					#puts "Invalid first parameter transaction_id = #{transaction_id}"
					return false
				end
				request={
					__type: "ReturnById:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Rest",
					ApplicationProfileId: @application_id,
					MerchantProfileId: merchant_profile_id,
					DifferenceData:{
						__type: "BankcardReturn:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Bankcard",
						TransactionId: transaction_id,
						Addendum: nil
					}
				}
				request[:DifferenceData].merge(diff_data)
				request=JSON.generate(request)
				#puts request
				if (!self.validate_session())
					return false; end
				
				#puts "Submitting return by id..."
				response=action_with_token(:post,:Txn,{body:request, target:workflow_id})
				#puts "Done"
				#puts response
				response
			end
			
			# Use extreme caution when using this.
			def return_unlinked(transaction, merchant_profile_id, workflow_id)
				request={
					__type:"ReturnTransaction:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Rest",
					ApplicationProfileId:@application_id,
					MerchantProfileId:merchant_profile_id,
					Transaction:{__type:"BankcardTransaction:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Bankcard"}
				}
				request[:Transaction].update(transaction)

				request=JSON.generate(request)
				#puts request
				if (!self.validate_session())
					return false; end
				
				#puts "Submitting return unlinked..."
				response=action_with_token(:post,:Txn,{body:request, target:workflow_id.to_s})
				#puts "Done"
				#puts response
				response
			end
			
			def verify(transaction, merchant_profile_id=nil, workflow_id=nil)
				merchant_profile_id||=@merchant_profile_id;
				workflow_id||=@workflow_id;
				
				request={
					__type: "VerifyTransaction"+REST_SCHEMA,
				    ApplicationProfileId: @application_id,
				    MerchantProfileId: merchant_profile_id,
				    Transaction: {__type: "BankcardTransaction:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/Transactions\/Bankcard"}
    			}
        transaction[:TransactionData][:TransactionDateTime]=iso_time(transaction[:TransactionData][:TransactionDateTime])
				request[:Transaction].update(transaction)
				puts request
				request=JSON.generate(request)
				#puts request
				if (!self.validate_session())
					return false; end
				
				#puts "Submitting verify..."
				response=action_with_token(:post,:Txn,{body:request, target:workflow_id.to_s})
				#puts "Done"
				#puts response
				response
			end
		end
	end
end
