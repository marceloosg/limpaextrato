sodexo=bkpsodexo
banksodexorange=grep("SODEX",banco$Lançamento)
sodexobank=banco[banksodexorange,]
for(i in 1:length(sodexo$Status)){
        
        subs=filter(sodexobank,Valor..R..==sodexo$`Valor Líquido (R$)`[i])
        msg="Pagamento Não Encontrado"
        if(dim(subs)[1]>0){
                
                msg=paste("PAGO FORA DA DATA PREVISTA ex:(",subs$Data[1],")")
                subs=filter(subs,Data==sodexo$`Data prevista de pagamento`[i])
                if(dim(subs)[1]>0){
                        msg="PAGO"
                }
        }
        sodexo$Confirmado[i]=msg
}
