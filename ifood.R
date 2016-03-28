library(xlsx)
library(data.table)
library(dplyr)
dt=data.table(read.xlsx("201601-ifood.xlsx",1))
dt=filter(dt,Confirmado=="Sim")
dt=dt[grep("MÁQUINA|CARTÃO|DINHEIRO",dt$Formas.de.Pagamento,invert=TRUE),]
dt=dt[!is.na(Formas.de.Pagamento),]
dt$Status=dt$Confirmado
dt$Formas.de.Pagamento=toupper(dt$Formas.de.Pagamento)
dt$Data=format(strptime(dt$Data,"%Y-%m-%d %H:%M:%S"),"%Y-%m-%d")
df=dt[,.(Data,valor=Total.Pedido,NOME=Formas.de.Pagamento,Status,Confirmado,FITID=ID.Pedido) ]
cat=as.factor(df$Data)
sdt=split(df,cat)
ldt=c()
for(i in 1:length(sdt)){
        sdt[[i]]=unique(sdt[[i]][,.(Data,valor=sum(valor),FITID=sum(FITID)),by= NOME])
}
dft=rbindlist(sdt)
ifood=dft
bkpifood=ifood
write.csv(ifood,file = "201601-ifood.csv",quote=FALSE)
#df=unsplit(sdt,cat,drop=FALSE)