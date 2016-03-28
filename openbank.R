library(xlsx)
library(data.table)
library(dplyr)

files=grep("Recebimentos.xlsx", dir(),value = TRUE)
#Sys.setlocale(category = "LC_ALL", locale = "pt_BR.UTF-8")
col=rep("character",6)
col[3]="double"
#col[11]="double"
#header=data.table(read.xlsx(file,1,startRow = 4,endRow = 4,header=FALSE,colClasses=col))

file=files[1]
dt=data.frame(read.xlsx(file,1,startRow = 1,header=TRUE,colClasses=col,colIndex = 1:6),stringsAsFactors = FALSE)
for(file in files[2:length(files)]){
        dt=rbindlist(list(dt,data.frame(read.xlsx(file,1,startRow =1,header=TRUE,
                                                  colClasses=col,colIndex = 1:6),stringsAsFactors = FALSE)))
}
dt=data.table(dt)
dt=dt[!is.na(dt$Valor..R..),]
banco=dt[!is.na(dt$Data),]
banco$Tipo=as.character(NA)
banco$Data=as.Date(as.integer(as.character(banco$Data)),origin= "1970-01-01",format="%Y-%m-%d")
bkpbanco=banco
write.csv(banco,file = "2016-03-banco.csv",quote=FALSE)
