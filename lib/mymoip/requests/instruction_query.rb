module MyMoip
  class InstructionQuery
    include HTTParty
    base_uri MyMoip.api_url

    attr_reader :token

    def initialize(token)
      @token = token
      @auth = {username: MyMoip.token, password: MyMoip.key }
    end

    def api_call
      options = {:token => @token}
      options.merge!({:basic_auth => @auth})

      @response = self.class.get("/ws/alpha/ConsultarInstrucao", options)
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
      result["Pagamento"]["Data"]
    end

    def gross_amount
      result["Pagamento"]["TotalPago"]
    end

    def fee_amount
      result["Pagamento"]["TaxaMoIP"]
    end

    def net_amount
      result["Pagamento"]["ValorLiquido"]
    end

    def payment_type
      result["Pagamento"]["FormaPagamento"]
    end

    def payment_flag
      result["Pagamento"]["InstituicaoPagamento"]
    end 
    
    def status
      result["Pagamento"]["Status"]
    end 

    def id
      result["Pagamento"]["CodigoMoIP"]
    end
  end
end