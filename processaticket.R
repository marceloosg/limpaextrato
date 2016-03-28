ticket=bkpticket
bankticketrange=grep("TICKET",banco$Lançamento)
ticketbank=banco[bankticketrange,]
ticket$`Data prevista de pagamento`=as.Date(ticket$`Data prevista de pagamento`)+2
for(i in 1:length(ticket$`Valor Líquido (R$)`)){
        if( ticket$`Valor Líquido (R$)`[i] %in% ticketbank$Valor..R..){
                dataset=ticketbank[ which(ticketbank$Valor..R..== ticket$`Valor Líquido (R$)`[i]),]$Data
                td=as.Date(ticket$`Data prevista de pagamento`[i])
                if(length(which(dataset==td)) > 0  ){
                        ticket$Confirmado[i]="PAGO"
                }
                else{

                        dif=(as.integer(dataset-td))
                        dif=min(abs(dif))*sign(dif)
                        msg="PAGO FORA DA DATA PREVISTA por "
                        ticket$Confirmado[i]=paste(msg,as.character(dif),"dias")
                }
        }
        else{
                ticket$Confirmado[i]="Pagamento Não Encontrado"
        }
}

