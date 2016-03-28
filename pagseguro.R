library(xlsx)
library(data.table)
library(dplyr)

files=grep("PagSeguro.*utf8", dir("extratos",full.names = TRUE),value = TRUE)
#files=c(files,"ticke.extrato.12.2015.xlsx")
#Sys.setlocale(category = "LC_ALL", locale = "pt_BR.UTF-8")
col=rep("character",28)
#col[7]="integer"
col[c(8,11)]="double"
file=files[1]
pag=read.csv(file,sep=";",dec=",",colClasses = col,header = TRUE)
fid= as.double(gsub("[A-Z]","",pag$Transacao_ID))
today=Sys.time()
p=pag
pag=data.table(`Data da Transação (Venda)`=as.Date(pag$Data_Transacao),
                     `Data prevista de pagamento`=as.Date(pag$Data_Compensacao),`Valor Bruto`=pag$Valor_Bruto,
                     `Valor Líquido (R$)`=pag$Valor_Liquido,
                  Status=pag$Data_Compensacao<today,Confirmado=NA,Bandeira="PagSeguro",Tipo=pag$Tipo_Transacao)

pagseguro=pag[,.(`Data da Transação (Venda)`,`Valor Bruto`=sum(as.double(`Valor Bruto`)),
                 `Valor Líquido (R$)`=sum(`Valor Líquido (R$)`)),by=`Data prevista de pagamento`]
#pagseguro=unique(select(pag,-`Valor Bruto`))
bkppagseguro=pagseguro