#source('~/deia/verdure/extratos/openbank.R')
print("bank done")
#source('~/deia/verdure/extratos/cielo.R')
print("cielo done")
source('~/deia/verdure/extratos/processcielo.R')
print("cieloprocess done")
source('~/deia/verdure/extratos/ticket.R')
print("ticket done")
source('~/deia/verdure/extratos/processaticket.R')
print("ticketprocess done")
source('~/deia/verdure/extratos/sodexo.R')
print("sodexo done")
source('~/deia/verdure/extratos/processasodexo.R')
print("sodexo process done")
source('~/deia/verdure/extratos/rede.R')
source('~/deia/verdure/extratos/processarede.R')
print("rede done")
cielo$Fonte="cielo"
ticket$Fonte="ticket"
sodexo$Fonte="sodexo"
rede$Fonte="rede"
cielo$`Data prevista de pagamento`=as.character(format(cielo$`Data prevista de pagamento`,format="%d-%m-%y"))

ticket$`Data prevista de pagamento`=as.character(ticket$`Data prevista de pagamento`)
sodexo$`Data prevista de pagamento`=as.character(sodexo$`Data prevista de pagamento`)
