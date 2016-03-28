library(xlsx)
library(data.table)
library(dplyr)
#Sys.setlocale(category = "LC_ALL", locale = "pt_BR.UTF-8")
col=rep("character",8)
col[2]="integer"
col[c(4,7)]="double"

header=read.csv("cielo-2016-01a03-utf8.csv",sep=";",colClasses = "character",header = FALSE,skip = 2,nrow=1)
dt=data.table(read.csv("cielo-2016-01a03.utf8.csv",dec=",",sep=";",header = FALSE,skip = 3,colClasses = col))
colnames(dt)=as.character(header)
df1=dt[grep("(POS|arcela|Lançamento)",dt$Descrição,invert=TRUE),.(`Data da Transação (Venda)`=`Data de Apresentação`,
                                             `Data prevista de pagamento`,Descrição=as.character(Descrição),
                                             `Valor Total Apresentado (R$)`,`Valor Líquido (R$)`, Status,FITID=Resumo,Bandeira)]
dt=data.table(read.csv("cielo-2016-04-futuro.utf8.csv",dec=",",sep=";",header = FALSE,skip = 3,colClasses = col))
colnames(dt)=as.character(header)
df2=dt[grep("POS|arcela|Lançamento",dt$Descrição,invert=TRUE),.(`Data da Transação (Venda)`=`Data de Apresentação`,
                                                    `Data prevista de pagamento`,Descrição=as.character(Descrição),
                                                    `Valor Total Apresentado (R$)`,`Valor Líquido (R$)`,  Status,FITID=Resumo,Bandeira)]
dt=data.table(read.csv("cielo-dezembro.utf8.csv",dec=",",sep=";",header = FALSE,skip = 3,colClasses = col))
colnames(dt)=as.character(header)
df3=dt[grep("POS|arcela|Lançamento",dt$Descrição,invert=TRUE),.(`Data da Transação (Venda)`=`Data de Apresentação`,
                                                                `Data prevista de pagamento`,Descrição=as.character(Descrição),
                                                                `Valor Total Apresentado (R$)`,`Valor Líquido (R$)`,  Status,FITID=Resumo,Bandeira)]
df=rbindlist(list(df1,df2,df3))
range=grep("crédito",df$Descrição)
df$Descrição[range]=gsub(".*","credito cielo",df$Descrição[range])
range=grep("(débito|maestro|electron)",df$Descrição)
df$Descrição[range]=gsub(".*","debito cielo",df$Descrição[range])


#dt$Formas.de.Pagamento=toupper(dt$Formas.de.Pagamento)
datat=df$`Data da Transação (Venda)`
#df$`Data da Transação (Venda)`=format(strptime(datat,"%Y-%m-%d %H:%M:%S"),"%Y%m%d")
#dt=dt[,.(Data,valor=Total.Pedido,NOME=Formas.de.Pagamento,FITID=ID.Pedido) ]
cat=as.factor(datat)
sdt=split(df,cat)
ldt=c()
for(i in 1:length(sdt)){
        sdt[[i]]=unique(sdt[[i]][,.(`Data da Transação (Venda)`,
                                    `Data prevista de pagamento`,
                                    `Valor Total Apresentado (R$)`=sum(`Valor Total Apresentado (R$)`),
                                    `Valor Líquido (R$)`=sum(`Valor Líquido (R$)`),  Status,FITID,Bandeira),
                                by= .(Descrição=paste(Descrição,Bandeira))])
}
cielo=rbindlist(sdt)
#df$valor=df$valor*100
#df=df[order(df$NOME),]
write.csv(cielo,file = "2016-03-cielo.csv",quote=FALSE)
#df=unsplit(sdt,cat,drop=FALSE)
bkpcielo=cielo