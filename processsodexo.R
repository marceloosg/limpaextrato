sodexo=bkpsodexo
banksodexorange=grep("SODEX",banco$Lançamento)
sodexobank=banco[banksodexorange,]
for(valor in unique(sodexo$`Valor Líquido (R$)`)){
        sodexo=processavalor(sodexo,sodexobank,valor)
}

sodexo$Fonte="sodexo"
sodexo$Descriçao="Venda Delivery"
sodexo$`Data prevista de pagamento`=format(sodexo$`Data prevista de pagamento`,format=form)
sodexo$`Data da Transação (Venda)`=format(sodexo$`Data da Transação (Venda)`,format=form)
psodexo=select(sodexo,`Data da Transação (Venda)`,`Data prevista de pagamento`,`Pago na data previsa?`=Confirmado,
             Descriçao,`Recebido de `=Fonte,
             `Valor Bruto`, `Valor Líquido (R$)`)
write.xlsx(psodexo,"sodexo-03.xls")