source('processavalor.R')
pagseguro=bkppagseguro
bankpagsegurorange=grep("PAGSEGURO",banco$Lançamento)
pagsegurobank=banco[bankpagsegurorange,]

for(valor in unique(pagseguro$`Valor Líquido (R$)`)){
        pagseguro=processavalor(pagseguro,pagsegurobank,valor)
}

pagseguro$Descriçao="Venda Delivery"
pagseguro$Fonte=paste("pagseguro ",pagseguro$Tipo)
pagseguro$`Data prevista de pagamento`=format(pagseguro$`Data prevista de pagamento`,format=form)
pagseguro$`Data da Transação (Venda)`=format(pagseguro$`Data da Transação (Venda)`,format=form)
ppagseguro=select(pagseguro,`Data da Transação (Venda)`,`Data prevista de pagamento`,`Pago na data previsa?`=Confirmado,
             Descriçao,`Recebido de `=Fonte,
             `Valor Bruto`, `Valor Líquido (R$)`)
write.xlsx(ppagseguro,"pagseguro-03.xls")