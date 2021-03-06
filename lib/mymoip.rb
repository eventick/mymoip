require 'active_model'
require 'builder'
require 'logger'
require 'httparty'
require 'json'

module MyMoip
  class << self
    attr_accessor :production_key, :production_token,
                  :sandbox_key, :sandbox_token,
                  :environment, :logger, :default_referer_url

    def api_url
      if environment == "sandbox"
        "https://desenvolvedor.moip.com.br/sandbox"
      else
        "https://www.moip.com.br"
      end
    end

    def key=(value)
      warn "[DEPRECATION] `key=` is deprecated. Please use `sandbox_key` or `production_key` instead."
      @production_key = @sandbox_key = value
    end

    def token=(value)
      warn "[DEPRECATION] `token=` is deprecated. Please use `sandbox_token` or `production_token` instead."
      @production_token = @sandbox_token = value
    end

    def key
      send(:"#{environment}_key")
    end

    def token
      send(:"#{environment}_token")
    end
  end
end

$LOAD_PATH << "./lib/mymoip"

files = Dir[File.dirname(__FILE__) + "/mymoip/*.rb"]
files.each { |f| require f }

MyMoip.environment = "sandbox"
MyMoip.logger = Logger.new(STDOUT)
