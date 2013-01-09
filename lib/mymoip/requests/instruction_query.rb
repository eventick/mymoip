module MyMoip
  class InstructionQuery
    include HTTParty
    base_uri "https://desenvolvedor.moip.com.br/sandbox"

    attr_reader :token

    def initialize(token)
      @token = token
      @auth = {username: "01010101010101010101010101010101", password: "ABABABABABABABABABABABABABABABABABABABAB" }
    end

    def api_call
      options = {:basic_auth => @auth}
      url = "/ws/alpha/ConsultarInstrucao/#{@token}"
      @response = self.class.get(url, options)
    end

    def result
      @response["ConsultarTokenResponse"]["RespostaConsultar"]["Autorizacao"]
    end

    def buyer_name
      result["Pagador"]["Nome"]
    end

    def buyer_email
      result["Pagador"]["Email"]
    end

    def date
      result["Pagamento"][0]["Data"]
    end

    def gross_amount
      result["Pagamento"][0]["TotalPago"]["__content__"]
    end

    def fee_amount
      result["Pagamento"][0]["TaxaMoIP"]["__content__"]
    end

    def net_amount
      result["Pagamento"][0]["ValorLiquido"]["__content__"]
    end

    def payment_type
      result["Pagamento"][0]["FormaPagamento"]
    end

    def payment_flag
      result["Pagamento"][0]["InstituicaoPagamento"]
    end 
    
    def status
      result["Pagamento"][0]["Status"]["Tipo"]
    end 

    def id
      result["Pagamento"][0]["CodigoMoIP"]
    end
  end
end