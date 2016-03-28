library(xlsx)
library(data.table)
library(dplyr)
dt=data.table(read.xlsx("201601.xlsx",1))

dt=dt[Confirmado=="Sim",]
dt$Formas.de.Pagamento=toupper(dt$Formas.de.Pagamento)
dt$Data=format(strptime(dt$Data,"%Y-%m-%d %H:%M:%S"),"%Y%m%d")
dt=dt[,.(Data,valor=Total.Pedido,NOME=Formas.de.Pagamento,FITID=ID.Pedido) ]
cat=as.factor(dt$Data)
sdt=split(dt,cat)
ldt=c()
for(i in 1:length(sdt)){
        sdt[[i]]=unique(sdt[[i]][,.(Data,valor=sum(valor),FITID=sum(FITID)),by= NOME])
}
df=rbindlist(sdt)
df$valor=df$valor*100
df=df[order(df$NOME),]
write.csv(df,file = "201601.csv",quote=FALSE)
#df=unsplit(sdt,cat,drop=FALSE)