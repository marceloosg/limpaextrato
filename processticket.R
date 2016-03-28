ticket=bkpticket
bankticketrange=grep("TICKET",banco$Lançamento)
ticketbank=banco[bankticketrange,]
ticket$`Data da Transação (Venda)`=as.Date(ticket$`Data da Transação (Venda)`)
ticket$`Data prevista de pagamento`=as.Date(ticket$`Data prevista de pagamento`)
ticket$`Data prevista de pagamento`=as.Date(ticket$`Data prevista de pagamento`+2)
for(valor in unique(ticket$`Valor Líquido (R$)`)){
        ticket=processavalor(ticket,ticketbank,valor)
}

ticket$Fonte="Ticket Restaurante"
ticket$Descriçao="Venda Delivery"
fticket=merge(select(aticket,-Confirmado,-`Data prevista de pagamento`),select(ticket,FITID,Confirmado,Descriçao,Fonte,`Data prevista de pagamento`),by = "FITID")
pticket=select(fticket,`Data da Transação (Venda)`,`Data prevista de pagamento`,`Pago na data previsa?`=Confirmado,
              Descriçao,`Recebido de `=Fonte,
              Tipo,`Valor Líquido (R$)`
              )
write.xlsx(pticket,"pticket-03.xls")