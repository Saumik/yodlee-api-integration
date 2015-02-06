module Yodlee
	class Consumer < Base
		def consumer
			test_user_id = 'sbMempsahni5'
			test_user_password = 'sbMempsahni5#123'
			response = query({
				:endpoint => '/authenticate/login',
				:method => :POST,
				:cobSessionToken => cobrand_token,
				:login => test_user_id,
				:password => test_user_password

			})	
			response
		end
	end
end