module MyMoip
  class Request
    include HTTParty

    attr_reader :response

    def api_call(params, opts = {})
      opts[:logger]   ||= MyMoip.logger
      opts[:username] ||= MyMoip.token
      opts[:password] ||= MyMoip.key

      opts[:logger].info "New #{self.class} being sent to MoIP."
      opts[:logger].debug "#{self.class} of with #{params.inspect}"

      url = MyMoip.api_url + params.delete(:path)
      params[:basic_auth] = { username: opts[:username], password: opts[:password] }

      @response = HTTParty.send params.delete(:http_method), url, params

      opts[:logger].debug "#{self.class} to #{url} had response #{@response.inspect}"
    end
  end
end

requests = Dir[File.dirname(__FILE__) + "/requests/*.rb"]
requests.each { |f| require f }