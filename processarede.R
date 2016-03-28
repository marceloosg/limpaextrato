rede=bkprede
bankrederange=grep("REDE",banco$Lançamento)
redebank=banco[bankrederange,]
form="%d/%m/%y"
rede$`Data da Transação (Venda)`=format(as.Date(rede$`Data da Transação (Venda)`,format=form),format=form)
for(i in 1:length(rede$`Valor Líquido (R$)`)){
        if(i==69){
                print(i)
        }
        if( rede$`Valor Líquido (R$)`[i] %in% redebank$Valor..R..){
                dataset=redebank[ which(redebank$Valor..R..== rede$`Valor Líquido (R$)`[i]),]
                dataset=filter(dataset,Data >= rede$`Data da Transação (Venda)`[i]) 
                dataset=dataset$Data
               # dataset=format(dataset,format="%d-%m-%y")               
                if(length(which(dataset-rede$`Data prevista de pagamento`[i]==0)) > 0 ){
                        rede$Confirmado[i]="PAGO"
                }
                else{
                        cdata=(rede$`Data prevista de pagamento`[i])
                        datas=(dataset)
                        dif=as.integer(datas-cdata)
                #        dif=dif[dif>=0]
              #         dif=min(abs(dif))*sign(dif)
                        #                      msg="PAGO FORA DA DATA PREVISTA por "
                        #                     msg=paste(msg,as.character(dif),"dias")
                        msg=paste(as.character(cdata+dif,format=form),collapse=" ")
                        rede$Confirmado[i]=msg
                                #"PAGO FORA DA DATA PREVISTA"
                }
        }
        else{
                rede$Confirmado[i]="Pagamento Não Encontrado"
        }
}
rede$Descriçao="Venda Delivery"
rede$Fonte=paste("rede ",rede$Tipo)
rede$`Data prevista de pagamento`=format(rede$`Data prevista de pagamento`,format=form)
prede=select(rede,`Data da Transação (Venda)`,`Data prevista de pagamento`,`Pago na data previsa?`=Confirmado,
            Descriçao,`Recebido de `=Fonte,
            `Valor Bruto`, `Valor Líquido (R$)`)
write.xlsx(prede,"rede-03.xls")