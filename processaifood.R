ifood=bkpifood
bankifoodrange=grep("IFOOD",banco$Lançamento)
ifoodbank=banco[bankifoodrange,]
for(i in 1:length(ifood$Status)){
        
        subs=filter(ifoodbank,Valor..R..==ifood$`Valor Líquido (R$)`[i])
        msg="Pagamento Não Encontrado"
        if(dim(subs)[1]>0){
                
                msg=paste("PAGO FORA DA DATA PREVISTA ex:(",subs$Data[1],")")
                subs=filter(subs,Data==ifood$`Data prevista de pagamento`[i])
                if(dim(subs)[1]>0){
                        msg="PAGO"
                }
        }
        ifood$Confirmado[i]=msg
}