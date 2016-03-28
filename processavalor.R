processavalor=function(card,bank,valor){
        cadset=which(card$`Valor Líquido (R$)`==valor)
        bankset=which(bank$Valor..R..==valor)
        subbank=bank[bankset,]
        subcard=card[cadset,]
        subbank=filter(subbank,Data>=subcard$`Data da Transação (Venda)`[1])
        csize=length(subcard)
        bsize=length(subbank)
        size=min(csize,bsize)
        cpago=c()
        for(i in cadset){
                if(i==93){
                        print(c("ok:",i,cadset))
                }
                if(dim(subbank)[1] > 0){
                        sdata=which(card[i,]$`Data prevista de pagamento`==subbank$Data)
                        if(length(sdata) > 0){
                                j=sdata[1]
                                pdata=as.Date(subbank[j]$Data)
                                msg="PAGO"
                                card$Confirmado[i]=msg
                                subbank=subbank[-j,]
                                cpago=c(cpago,i)
                        }
                }
                else{
                        
                        print(cadset)
                        cconf=setdiff(cadset,cpago)
                        card$Confirmado[cconf]="Pagamento nao encontrado"
                        cpago=cadset
                        break
                }
        }
        print("done")
        if(dim(subbank)[1] > 0){
                fset=setdiff(cadset,cpago)
                for(i in fset){
                        if(dim(subbank)[1] > 0){
                                sdata=which(subbank$Data>card[i,]$`Data da Transação (Venda)`)[1]
                                if(length(sdata) > 0){
                                        j=sdata[1]
                                        pdata=as.Date(subbank[j,]$Data)
                                        if(pdata > as.Date(Sys.time())){
                                                msg=paste("AGENDADO para",pdata)
                                        }
                                        else{
                                                msg=paste("PAGO em ",pdata)
                                        }
                                        card$Confirmado[i]=msg
                                        subbank=subbank[-j,]
                                        cpago=c(cpago,i)
                                }
                                else{
                                        card[setdiff(cadset,cpago),]$Confirmado ="Pagamento nao encontrado"
                                        cpago=cadset
                                        break
                                }
                        }
                }
        }
        else{
                card$Confirmado[setdiff(cadset,cpago)]="Pagamento nao encontrado"
                
        }
        card
}