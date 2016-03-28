cielo=bkpcielo
bankcielorange=grep("CIELO",banco$Lançamento)

cielobank=banco[bankcielorange,]
banco$Status=as.character(NA)
bandeiras=levels(as.factor(as.character(cielobank$Lançamento)))
bm=c("ELO", "Mastercard" , "Mastercard" ,"VISA","VISA")
cm=c("debito","credito"  , "debito",  "credito","debito","NA")
dm=c("debito","credito"  , "maestro",  "credito","electron")
cielorange=1:length(cielo$`Valor Líquido (R$)`)
cielo$Conferido=as.character(NA)
cielo$Tipo=factor(cm[6],levels=levels(as.factor(cm)))
cielobank$Tipo=factor(cm[6],levels=levels(as.factor(cm)))
cielobank$Bandeira=as.character(cielobank$Bandeira)
l=length(cielobank$Valor..R..)

cielo$`Data prevista de pagamento`=as.Date(cielo$`Data prevista de pagamento`,format("%d/%m/%Y"))
for(i in 1:l){
  #      if(i==11){
 #               print(i)
#        }
       # print(i)
        j=which(bandeiras == as.character(cielobank$Lançamento[i]))
        valor=cielobank$Valor..R..[i]
        datas=cielobank$Data[i]
        cielobank$Bandeira[i]=bm[j]
        cielobank$Tipo[i]=cm[j]
        bandset=which(cielo$Bandeira==bm[j])
        valorset=which(cielo$`Valor Líquido (R$)`==valor)
        midset=intersect(bandset,valorset)
        dataset=which(cielo$`Data prevista de pagamento`==datas)
        #        tiposet=grep(cm[j],cielo$Descrição)
        final=intersect(midset,dataset)
        if(length(midset) == 0){
                cielobank$Status[i]="cielo faltando"
                val=cielobank$Valor..R..[i]
                dat=as.character(cielobank$Data[i])
                print(c("Warning:",i,dat,val,"cielo faltando"))
        }
        else{
                if(length(final) > 0){
                        cielobank$Status[i]="PAGO"
                        cielo$Conferido[final]="PAGO"
                }
                else{
                        datas=as.Date(datas)
                        cdata=as.Date(cielo$`Data prevista de pagamento`)
                        dif=as.integer(datas-cdata)
                        dif=min(abs(dif))*sign(dif)
   #                      msg="PAGO FORA DA DATA PREVISTA por "
   #                     msg=paste(msg,as.character(dif),"dias")
                        msg=cdata+dif
                        cielobank$Status[i]=msg
                        cielo$Conferido[final]=msg
                }
                cielo$Tipo[final]=cm[j]
                cielorange=setdiff(cielorange,final)
        }
}
banco[bankcielorange,]=cielobank
msg="Pagamento Não encontrado"
for(i in cielorange){
        nmsg=msg
        if(cielo$`Data prevista de pagamento`[i] < as.Date("2016-01-01")){
                nmsg=paste(msg,"(Conferir extrato:",as.character(cielo$`Data prevista de pagamento`[i]),")")
        }
        cielo$Conferido[i]=nmsg
}
droplevels(cielobank$Tipo)
cielo$Fonte=paste("cielo ",cielo$Tipo)
cielo$Descriçao="Venda Delivery"
pcielo=select(cielo,`Data da Transação (Venda)`,`Data prevista de pagamento`,`Pago na data previsa?`=Conferido,
              Descriçao,`Recebido de `=Fonte,
              Tipo,`Valor Bruto`=`Valor Total Apresentado (R$)`, `Valor Líquido (R$)`)
write.xlsx(pcielo,"cielo-03.xls")