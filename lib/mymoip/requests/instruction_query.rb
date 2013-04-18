module MyMoip
  class InstructionQuery
    include HTTParty

    attr_reader :token, :response

    def initialize(token)
      api_url
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

    private
    def api_url
      self.base_uri = if MyMoip.environment == "sandbox"
        self.base_uri "https://desenvolvedor.moip.com.br/sandbox"
      else
        self.base_uri "https://www.moip.com.br"
      end
    end
  end
end