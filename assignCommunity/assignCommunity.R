library(readr)
library(readxl)
allArgs=commandArgs(trailingOnly=TRUE)
allplasmidPath=allArgs[1]
queryPlasmidPath=allArgs[2]
output_tag=allArgs[3]
#allplasmidPath="/data/lizhenpeng/wuxinmiao/again/plasmids"
cat(queryPlasmidPath,"\n",sep="",collapse="",file="queryplasmidpath.txt")
system(sprintf("ls %s/* >allplasmidpath.txt",allplasmidPath))
ANIcode="fastANI --ql queryplasmidpath.txt --rl allplasmidpath.txt -o fastani_output.txt --matrix --minFraction 0.8 -t 50"
system(ANIcode)
readoutput=read_tsv("fastani_output.txt",col_names=FALSE)
gettargetplasmid=readoutput$X2[which.max(readoutput$X3)]
getplas01=rev(strsplit(gettargetplasmid,"\\/")[[1]])[1]
getplas=gsub(".fasta","",getplas01)
qbxx=read_xlsx("/data/lizhenpeng/wuxinmiao/again/7232qbxx_again(2).xlsx",1)
getmembership=qbxx$membership[qbxx$plasmids==getplas]
allmembershipSize=table(qbxx$membership)
getmemSize=allmembershipSize[names(allmembershipSize)%in%getmembership]
outline=c(readoutput$X1[1],getmembership, getmemSize)
nam=c("queryPlasmid","membership","membershipSize")
outlinef=data.frame(names=nam,info=outline)
write_tsv(outlinef,col_names=TRUE,file=sprintf("%s_membershipAssigned.txt",output_tag))
