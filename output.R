
cielo=select(cielo,`Data prevista de pagamento`,`Valor Líquido (R$)`,Fonte,Bandeira,Tipo,Confirmado=Conferido,FITID)
write.xlsx(cielo,"cielo-03.xls")
ticket=select(ticket,`Data prevista de pagamento`,`Valor Líquido (R$)`,Fonte,Bandeira,Tipo,Confirmado,FITID)
write.xlsx(ticket,"ticket-03.xls")
sodexo=select(sodexo,`Data prevista de pagamento`,`Valor Líquido (R$)`,Fonte,Bandeira,Tipo,Confirmado,FITID)
write.xlsx(sodexo,"sodexo-03.xls")
rede=select(rede,`Data prevista de pagamento`,`Valor Líquido (R$)`,Fonte,Bandeira,Tipo,Confirmado,FITID)
write.xlsx(rede,"rede-03.xls")

full=rbindlist(list(cielo,ticket,sodexo,rede))
write.xlsx(full,"consolidadas-03.xls")