library(xlsx)
library(data.table)
library(dplyr)
files=grep("^..0.*DEPOSITADO.xls", dir(),value=TRUE)
#file=files[1]
col=rep("character",12)
col[c(9,12)]="double"
dt=c()

for(file in files){
        rheader=(read.xlsx(file,1,startRow = 8,endRow = 33,header=FALSE,colClasses = col))
        DataPagamento=as.Date(gsub(".*: ","",rheader$X2[2]),format("%d/%m/%Y"))
        valorbruto=as.double(as.character(rheader$X12[3]))
        ValorLiquido=as.double(as.character(rheader$X12[6]))
        ffid=sum(rheader$X10,na.rm = TRUE)
        today=as.Date(Sys.time())
        curdt=data.table(`Data prevista de pagamento`= DataPagamento,`Valor Líquido (R$)`=ValorLiquido,
                         Status=DataPagamento<today,Confirmado=NA,Bandeira="Sodexo",Tipo="Débito",FITID=ffid)
        dt=rbindlist(list(dt,curdt))
}
sodexo=dt
write.csv(sodexo,file = "2016-03-sodexo.csv",quote=FALSE)
bkpsodexo=sodexo

