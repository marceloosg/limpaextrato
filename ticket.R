library(xlsx)
library(data.table)
library(dplyr)
file="ticke.extrato.01.2016.xlsx"
files=grep("ticke.*2016", dir(),value = TRUE)
#files=c(files,"ticke.extrato.12.2015.xlsx")
#Sys.setlocale(category = "LC_ALL", locale = "pt_BR.UTF-8")
col=rep("character",11)
col[7]="integer"
#col[11]="double"

#header=read.csv("cielo-2016-01a03-utf8.csv",sep=";",colClasses = "character",header = FALSE,skip = 2,nrow=1)
rheader=(read.xlsx(file,1,startRow = 13,endRow = 14,header=FALSE,colClasses = "character"))
header=c()
for(i in 1:length(rheader)){
        header=c(header,paste(rheader[1,i],rheader[2,i]))
}
dt=data.table(read.xlsx(file,1,startRow = 16,header=FALSE,colClasses=col))
for(file in files[2:length(files)]){
dt=rbindlist(list(dt,data.table(read.xlsx(file,1,startRow = 16,header=FALSE
                                          ,colClasses=col))))
}
colnames(dt)=header
raw=dt
dt=dt[is.na(dt$`Número Cartão`),]
DataPagamento=unique(dt[!is.na(`Data Cre/Deb`)]$`Data Cre/Deb`)
DataPagamento=as.POSIXct(DataPagamento,tz="" ,"%d/%m/%Y")
ValorLiquido=unique(raw[which(raw$`Descrição Lançamento`=="Total líquido" )]$`Valor R$`)
FITID=unique(raw[!is.na(`Número Reembolso`)]$`Número Reembolso`)
today=Sys.time()

ticket=data.table(`Data prevista de pagamento`= DataPagamento,`Valor Líquido (R$)`=ValorLiquido,
                  Status=DataPagamento<today,Confirmado=NA,Bandeira="Ticket Restaurante",Tipo="Débito",FITID=FITID)
ticket$`Valor Líquido (R$)`=as.double(gsub("$","",as.character(ticket$`Valor Líquido (R$)`),fixed=TRUE))



dt=raw[`Descrição Lançamento`=="COMPRA",]
lead=dt$`Data Cre/Deb`[1]
lst=c()
for( i in 1:length(dt$`Data Cre/Deb`)){
        if(is.na(dt$`Data Cre/Deb`[i])){
                dt$`Data Cre/Deb`[i]=dt$`Data Cre/Deb`[lead]
                dt$`Número Reembolso`[i]=dt$`Número Reembolso`[lead]
        }
        else{
                lead=i
                lst=c(lst,lead)
        }
}
ticket$`Data da Transação (Venda)`=dt$`Data Transação`[lst]
DataPagamento=dt$`Data Cre/Deb`
DataPagamento=as.POSIXct(DataPagamento,tz="" ,"%d/%m/%Y")
ValorLiquido=dt$`Valor R$`
        #unique(raw[which(raw$`Descrição Lançamento`=="Total líquido" )]$`Valor R$`)
FITID=dt$`Número Reembolso`
aticket=data.table(`Data da Transação (Venda)`=dt$`Data Transação`,`Data prevista de pagamento`= DataPagamento,`Valor Líquido (R$)`=ValorLiquido,
                  Status=DataPagamento<today,Confirmado=NA,Bandeira="Ticket Restaurante",Tipo="Débito",FITID=FITID)
aticket$`Valor Líquido (R$)`=as.double(gsub("$","",as.character(aticket$`Valor Líquido (R$)`),fixed=TRUE))


#stat=c("PAGO","Agendado")
#dt$`Descrição Lançamento`="Ticket Restaurante"
#dt$`Valor R$`=as.double(gsub("$","",as.character(dt$`Valor R$`),fixed=TRUE))
#df=dt[,.(`Data da Transação (Venda)`=`Data Transação`,
#         `Data prevista de pagamento`=`Data Cre/Deb`,
#         Descrição=as.character(dt$`Descrição Lançamento`),
#         `Valor Total Apresentado (R$)`=`Valor R$`,  Status=NA,FITID=`Número Docto`)]

#datat=df$`Data da Transação (Venda)`
#df$`Data da Transação (Venda)`=format(strptime(datat,"%Y-%m-%d %H:%M:%S"),"%Y%m%d")
#dt=dt[,.(Data,valor=Total.Pedido,NOME=Formas.de.Pagamento,FITID=ID.Pedido) ]
#cat=as.factor(datat)
#sdt=split(df,cat)
#ldt=c()
#for(i in 1:length(sdt)){
#        sdt[[i]]=unique(sdt[[i]][,.(`Data da Transação (Venda)`,`Data prevista de pagamento`,
#                                    `Valor Total Apresentado (R$)`=sum(`Valor Total Apresentado (R$)`),
#                                    Status,FITID=sum(FITID)),
#                                by= Descrição])
#}

    #                                    `Valor Total Apresentado (R$)`=sum(`Valor Total Apresentado (R$)`),
    #                                    Status,FITID=sum(FITID)),
#cdf=rbindlist(sdt)
#cdf=df
#cdf$`Data da Transação (Venda)`= as.POSIXct(cdf$`Data da Transação (Venda)`,tz="" ,"%d/%m/%Y")

#df$valor=df$valor*100
#df=df[order(df$NOME),]

write.csv(ticket,file = "2016-03-raw.csv",quote=FALSE)
# df=unsplit(sdt,cat,drop=FALSE)
bkpticket=ticket