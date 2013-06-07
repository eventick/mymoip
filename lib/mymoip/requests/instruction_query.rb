module MyMoip
  class InstructionQuery
    include HTTParty
    debug_output $stderr

    attr_reader :token, :response, :payment
    base_uri Rails.env == "production" ? "https://www.moip.com.br" : "https://desenvolvedor.moip.com.br/sandbox"

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
      @payment = last_payment
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
      DateTime.parse(payment["Data"])
    end

    def escrow_end_date
      DateTime.parse(payment["DataCredito"])
    end

    def gross_amount
      @payment["TotalPago"]["__content__"]
    end

    def fee_amount
      @payment["TaxaMoIP"]["__content__"]
    end

    def net_amount
      @payment["ValorLiquido"]["__content__"]
    end

    def payment_type
      @payment["FormaPagamento"]
    end

    def payment_flag
      @payment["InstituicaoPagamento"]
    end 
    
    def status
      @payment["Status"]["Tipo"]
    end 

    def id
      @payment["CodigoMoIP"]
    end

    private
    def last_payment
      payment = result["Pagamento"]
      if payment.kind_of?(Hash)
        @payment = payment
      else
        @payment = payment.first
        payment.each do |r|
          @payment = r if r["Status"]["__content__"] != "Iniciado" 
        end
      end
      @payment
    end
  end
end