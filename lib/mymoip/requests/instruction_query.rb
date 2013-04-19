module MyMoip
  class InstructionQuery
    include HTTParty
    debug_output $stderr

    attr_reader :token, :response
    base_uri MyMoip.api_url
    
    def initialize(token)
      @token = token
      @auth = {
        username: MyMoip.token,
        password: MyMoip.key
      }
    end

    def api_call
      options = {:basic_auth => @auth}
      url = "/ws/alpha/ConsultarInstrucao/#{@token}"
      @response = self.class.get(url, options)
    end

    def result
      @response["ConsultarTokenResponse"]["RespostaConsultar"]["Autorizacao"]
    end
    
    def payment
      result["Pagamento"]
    end
    
    def buyer_name
      result["Pagador"]["Nome"]
    end

    def buyer_email
      result["Pagador"]["Email"]
    end

    def date
      DateTime.parse(payment["Data"])
    end

    def escrow_end_date
      DateTime.parse(payment["DataCredito"])
    end

    def gross_amount
      payment["TotalPago"]["__content__"]
    end

    def fee_amount
      payment["TaxaMoIP"]["__content__"]
    end

    def net_amount
      payment["ValorLiquido"]["__content__"]
    end

    def payment_type
      payment["FormaPagamento"]
    end

    def payment_flag
      payment["InstituicaoPagamento"]
    end 
    
    def status
      payment["Status"]["Tipo"]
    end 

    def id
      payment["CodigoMoIP"]
    end
  end
end