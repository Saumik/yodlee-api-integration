module Yodlee
  class Base

  	cattr_accessor :current_session_token, :current_session_started
    include HTTParty

    #LOGIN
 #    def login
	#   credentials = {
	#     :cobrandLogin => Yodlee::Config.username,
	#     :cobrandPassword => Yodlee::Config.password
	#   }

	#   response = self.class.post('/authenticate/coblogin', query: credentials)
	# end

#----------------------------------------------------------------------------------

	def login
	  response = query({
	    :endpoint => '/authenticate/coblogin',
	    :method => :POST,
	    :params => {
	      :cobrandLogin => Yodlee::Config.username,
	      :cobrandPassword => Yodlee::Config.password
	    }
	  })
	  self.current_session_started = Time.zone.now
	  self.current_session_token = response.cobrandConversationCredentials.sessionToken
	end

#----------------------------------------------------------------------------------

	def query opts
	  method   = opts[:method].to_s.downcase
	  response = self.class.send(method, opts[:endpoint], query: opts[:params])
	  data     = response.parsed_response
	  if response.success?
	    if [ TrueClass, FalseClass, Fixnum ].include?(data.class)
	      data
	    else
	      convert_to_mash(data)
	    end
	  else
	    nil
	  end
	end

#----------------------------------------------------------------------------------	

	# Token is fresh when it is created with in 60 minutes
	def fresh_token?
      current_session_token && current_session_started >= 90.minutes.ago
    end

#----------------------------------------------------------------------------------	
	
	# Fetch the token from service and save it inside the session, to fire future requests
	# with token in parameter.
	def cobrand_token
	  fresh_token? ? current_session_token : login
	end

#----------------------------------------------------------------------------------	

	def convert_to_mash data
      if data.is_a? Hash
        Hashie::Mash.new(data)
      elsif data.is_a? Array
        data.map { |d| Hashie::Mash.new(d) }
      end
    end

  end#BASE
end