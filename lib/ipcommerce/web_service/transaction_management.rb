module Ipcommerce
	class Web_service
		module Transaction_management
			
			REST_SCHEMA=":http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/DataServices\/TMS\/Rest"
			
			def query_transactions_families(args={})
				options={capture_states:[0,1,2],is_acknowledged:0,query_type:1,
					start_date:Time.now.to_i-60*60*24,end_date:Time.now.to_i,page:0,page_size:50}
				
				options.merge!(args)
				
				options[:start_date]=json_time(options[:start_date])
				options[:end_date]=json_time(options[:end_date])
				
				workflow_id||=@workflow_id;
				
				
				request={
					__type: "QueryTransactionsFamilies"+REST_SCHEMA,
					PagingParameters:{
						__type: "PagingParameters:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/DataServices",
						Page:0,
						PageSize:50,
					},
					QueryTransactionsParameters:{
						__type: "QueryTransactionsParameters:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/DataServices\/TMS",
						CaptureStates:options[:capture_states],
						IsAcknowledged:options[:is_acknowledged],
						QueryType:options[:query_type],
						TransactionDateRange:{
							EndDateTime:options[:end_date],
							StartDateTime:options[:start_date]
						}
					}
				}
				request=JSON.generate(request)
				puts request
				if (!self.validate_session())
					return false; end
				
				puts "Submitting Query Transactions Families..."
				
				response=action_with_token(:post,:transactionsFamily,{body:request})
				puts "Done"
				puts response
				response
			end 
			
			def query_batch(args={})
				options={start_date:Time.now.to_i-60*60*24,
					end_date:Time.now.to_i, page:0,page_size:50}
				options.merge! args
				
				
				
				options[:start_date]=json_time(options[:start_date])
				options[:end_date]=json_time(options[:end_date])
				
				workflow_id||=@workflow_id;
				
				
				request={
					__type: "QueryBatch"+REST_SCHEMA,
					PagingParameters:{
						__type: "PagingParameters:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/DataServices",
						Page:options[:page],
						PageSize:options[:page_size]
					},
					QueryBatchParameters:{
						__type: "QueryBatchParameters:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/DataServices\/TMS",
						BatchDateRange:{
							EndDateTime:options[:end_date],
							StartDateTime:options[:start_date]
						}
					}
				}
				request=JSON.generate(request)
				puts request
				if (!self.validate_session())
					return false; end
				
				puts "Submitting Query Batch..."
				
				response=action_with_token(:post, :batch, {body:request})
				puts "Done"
				puts response
				response
			end 
			
			
			def query_transactions_summary(args={})
				options={capture_states:[1],is_acknowledged:0,query_type:1,
					start_date:Time.now.to_i-60*60*24,end_date:Time.now.to_i,page:0,page_size:50}
				
				options.merge!(args)
				
				if (!options[:start_date].is_a? String) then options[:start_date]="\/Date(#{options[:start_date].to_int*1000})\/" end
				if (!options[:end_date].is_a? String) then options[:end_date]="\/Date(#{options[:end_date].to_int*1000})\/" end
				
				workflow_id||=@workflow_id;
				
				
				options[:start_date]=json_time(options[:start_date])
				options[:end_date]=json_time(options[:end_date])
				
				request={
					__type: "QueryTransactionsSummary"+REST_SCHEMA,
					PagingParameters:{
						__type: "PagingParameters:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/DataServices",
						Page:options[:page],
						PageSize:options[:page_size]
					},
					QueryTransactionsParameters:{
						__type: "QueryTransactionsParameters:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/DataServices\/TMS",
						CaptureStates:options[:capture_states],
						IsAcknowledged:options[:is_acknowledged],
						QueryType:options[:query_type],
						TransactionDateRange:{
							EndDateTime:options[:end_date],
							StartDateTime:options[:start_date]
						}
					}
				}
				request=JSON.generate(request)
				puts request
				if (!self.validate_session())
					return false; end
				
				puts "Submitting Query Transactions Summary..."
				
				response=action_with_token(:post,:transactionsSummary,{body:request})
				puts "Done"
				puts response
				response
			end 
			
			
			def query_transactions_detail(transaction_ids, args={})
				options={include_related:0,is_acknowledged:0,query_type:1,
					start_date:Time.now.to_i-60*60*24,end_date:Time.now.to_i,page:0,page_size:50}
				
				options.merge!(args)
				
				options[:start_date]=json_time(options[:start_date])
				options[:end_date]=json_time(options[:end_date])
				
				workflow_id||=@workflow_id;
				
				
				request={
					__type: "QueryTransactionsDetail"+REST_SCHEMA,
					PagingParameters:{
						__type: "PagingParameters:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/DataServices",
						Page:options[:page],
						PageSize:options[:page_size]
					},
					IncludeRelated:options[:include_related],
					QueryTransactionsParameters:{
						__type: "QueryTransactionsParameters:http:\/\/schemas.ipcommerce.com\/CWS\/v2.0\/DataServices\/TMS",
						IsAcknowledged:options[:is_acknowledged],
						QueryType:options[:query_type],
						TransactionIds:transaction_ids
					},
					TransactionDetailFormat:2
				}
				request=JSON.generate(request)
				puts request
				if (!self.validate_session())
					return false; end
				
				puts "Submitting Query Transactions Detail..."
				
				response=action_with_token(:post,:transactionsDetail,{body:request})
				puts "Done"
				puts response
				response
			end 
			
		
		end
		
	end	
end
