library(xlsx)
library(data.table)
library(dplyr)
#Sys.setlocale(category = "LC_ALL", locale = "pt_BR.UTF-8")
col=rep("character",12)
col[c(6)]="integer"
col[c(9,10,12)]="double"
cold=rep("character",11)
cold[c(5)]="integer"
cold[c(8,9,10)]="double"
total=0
form="%d/%m/%y"
files=grep("Rela.*utf8.xls", dir(),value = TRUE)
rede=c()
for(file in files){
        tipo="Débito"
        cols=cold
        if(length(grep("credito",file)>0)){
                tipo="Crédito"
                cols=col
        }
        dt=read.csv(file,dec=",",sep="\t",colClasses = cols,header = TRUE)
        dt=dt[1:(dim(dt)[1]-1),]
        DataPagamento=as.Date(dt$Data.de.Receb,format="%d/%m/%y")
        ValorLiquido=as.double(dt$Valor.Líquido..R..)
        today=as.Date(Sys.time())
       # print(c(file,class(dt$Qtde.de.Vendas),class(dt$Valor.Bruto..R..)))
        FITID=(dt$Qtde.de.Vendas+dt$Valor.Bruto..R..)*100-unclass(DataPagamento)
        rede=rbindlist(list(rede,data.table(`Data da Transação (Venda)`=dt$Data.da.Venda,
                                            `Data prevista de pagamento`= DataPagamento
                         ,`Valor Bruto`=dt$Valor.Bruto..R..
                         ,Tipo=tipo
                         ,`Valor Líquido (R$)`=ValorLiquido
                         ,Status=DataPagamento<today
        ,Confirmado=NA 
        ,Bandeira=dt$Bandeira
        ,Tipo=tipo
        ,FITID=FITID
        )))
        total=total+dim(dt)[1]
        print(c(file,dt[which(dt$Valor.Líquido..R..==29.33),]$Data.de.Receb))
}
rede=rede[!is.na(`Data prevista de pagamento`),]
rede$`Data da Transação (Venda)`=as.Date(rede$`Data da Transação (Venda)`,format=form)

setorder(rede,`Data da Transação (Venda)`)
write.csv(rede,file = "2016-03-rede.csv",quote=FALSE)
bkprede=rede
