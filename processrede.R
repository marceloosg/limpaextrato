source('~/deia/verdure/extratos/processavalor.R')
rede=bkprede
bankrederange=grep("REDE",banco$Lançamento)
redebank=banco[bankrederange,]

for(valor in unique(rede$`Valor Líquido (R$)`)){
        rede=processavalor(rede,redebank,valor)
}

rede$Descriçao="Venda Delivery"
rede$Fonte=paste("rede ",rede$Tipo)
rede$`Data prevista de pagamento`=format(rede$`Data prevista de pagamento`,format=form)
rede$`Data da Transação (Venda)`=format(rede$`Data da Transação (Venda)`,format=form)
prede=select(rede,`Data da Transação (Venda)`,`Data prevista de pagamento`,`Pago na data previsa?`=Confirmado,
            Descriçao,`Recebido de `=Fonte,
            `Valor Bruto`, `Valor Líquido (R$)`)
write.xlsx(prede,"rede-03.xls")