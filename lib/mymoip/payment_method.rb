module MyMoip
  class PaymentMethod
    attr_accessor :boleto_bancario, :cartao_de_credito, :debito_bancario,
     :cartao_de_debito, :financiamento_bancario, :carteira_moip

    def initialize(attrs)
      self.boleto_bancario = attrs[:boleto_bancario]
      self.cartao_de_credito = attrs[:cartao_de_credito]
      self.debito_bancario = attrs[:debito_bancario]
      self.cartao_de_debito = attrs[:cartao_de_debito]
      self.financiamento_bancario = attrs[:financiamento_bancario]
      self.carteira_moip = attrs[:carteira_moip]
    end

    def to_xml(root = nil)
      if root.nil?
        xml  = ""
        root ||= Builder::XmlMarkup.new(target: xml)
      end

      root.FormasPagamento do |n1|
        n1.FormaPagamento('BoletoBancario') unless self.boleto_bancario == false
        n1.FormaPagamento('CartaoCredito') unless self.cartao_de_credito == false
        n1.FormaPagamento('DebitoBancario') unless self.debito_bancario == false
        n1.FormaPagamento('CartaoDebito') unless self.cartao_de_debito == false
        n1.FormaPagamento('FinanciamentoBancario') unless self.financiamento_bancario == false
        n1.FormaPagamento('CarteiraMoIP') unless self.carteira_moip == false
      end
      xml
    end
  end
end

# BoletoBancario
# CartaoCredito
# DebitoBancario
# CartaoDebito
# FinanciamentoBancario
# CarteiraMoIP
