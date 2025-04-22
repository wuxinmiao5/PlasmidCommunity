library(ape)
library(igraph)
library(ggraph)
library(tidygraph)
library(tidyverse)
library(readr)
library(dplyr)
library(seqinr)
library(ggplot2)
library(readxl)
library(writexl)
allparas=commandArgs()
input_fastani=allparas[6]
outputtag=allparas[7]
system("rm -rf plasmids.txt")
system(sprintf("ls %s/*|grep .*fasta >>plasmids.txt",input_fastani))
system("fastANI --ql plasmids.txt --rl plasmids.txt -o fastani_output.txt --matrix --minFraction 0.8 -t 50")

aaa=read_tsv("./fastani_output.txt",col_names=FALSE)
qq=c()
qq2=c()
for(i in 1:nrow(aaa)){
  id=basename(aaa$X1[i])
  qq=append(qq,id)
  id2=basename(aaa$X2[i])
  qq2=append(qq2,id2)
}
aaa0=data.frame(X1=qq,X2=qq2,X3=aaa$X3)
uniquenames=basename(readLines("plasmids.txt"))
aaa01=matrix(0, ncol=length(uniquenames),nrow=length(uniquenames))
  for(kkk in 1:dim(aaa0)[1]){
    nam1=qq[kkk]
    nam2=qq2[kkk]
    ck01=uniquenames%in%nam1
    ck02=uniquenames%in%nam2
    aaa01[ck01,ck02]=aaa0$X3[kkk]
    aaa01[ck02,ck01]=aaa0$X3[kkk]
  }
treedist=aaa01
rownames(treedist)=uniquenames
colnames(treedist)=uniquenames
treedist=1-treedist/100
treedist[is.na(treedist)]=0
save(treedist,file="treedist")
#
cutoffvalues=c()
cutoffseq=rev(seq(0.01,0.25,0.01))
allSILHOUETTE=c()
for(zz in cutoffseq){
  print(zz)
  treedist00=treedist
  cutoff=zz
  cutoffvalues=append(cutoffvalues, cutoff)
  treetemp=treedist00
  treetemp[,]=0
  treetemp[treedist00<=cutoff]=1
  g=graph_from_adjacency_matrix(treetemp,mode="undirected",diag=FALSE)
  imc=cluster_louvain(g)
  ccc=communities(imc)
  gnodes=V(g)$name
  ggroup=membership(imc)
  uniquegroup=unique(ggroup)
  meanSILHOUETTE=c()
  if(length(uniquegroup)>1){
    for(eachgnode in gnodes){
      ckeachgnode=colnames(treedist)%in%eachgnode
      #找到每个点在网络中属于哪个社区
      nodegroup=ggroup[gnodes%in%eachgnode]
      #这个点所在社区的所有成员（ai）
      nodegroupmembers=gnodes[ggroup%in%nodegroup]
      if(length(nodegroupmembers)==1){
        innerdistance=0
      }else{
        innergroupnodes=setdiff(nodegroupmembers,eachgnode)
        innerdistance=mean(treedist[colnames(treedist)%in%innergroupnodes,colnames(treedist)%in%eachgnode])
      }
      othergroups=setdiff(uniquegroup,nodegroup)
      othermeanVec=c()
      for(eachgroup in othergroups){
        ckgroup=(ggroup==eachgroup)
        eachotherGroupsNodes=gnodes[ckgroup]
        eachothergroupDistance=mean(treedist[colnames(treedist)%in%eachotherGroupsNodes,ckeachgnode])
        #print(eachothergroupDistance)
        othermeanVec=append(othermeanVec, eachothergroupDistance)
      }
      #print(othermeanVec)
      eachSILHOUETTE=(min(othermeanVec)-innerdistance)/max(min(othermeanVec),innerdistance)
      meanSILHOUETTE=append(meanSILHOUETTE, eachSILHOUETTE)
    }
    allSILHOUETTE=append(allSILHOUETTE,mean(meanSILHOUETTE))
  }else{
    allSILHOUETTE=append(allSILHOUETTE,0)
  }
  print(allSILHOUETTE)
}
getoptimalindex=max(which(allSILHOUETTE==max(allSILHOUETTE)))
getcutoff_core=cutoffvalues[getoptimalindex]
#plot
dataforplot=data.frame(cutoff=cutoffvalues,Silhouette=allSILHOUETTE)
pdf(sprintf("Silhouette_curve_%s.pdf",outputtag))
ddu=theme_classic() +
  theme(axis.text = element_text(size = 15, face = "bold", angle = 0)) +
  theme(axis.title.x = element_text(size = 15,  color = "black", face = "bold", vjust = 0.5, hjust = 0.5, angle = 0),
        axis.title.y = element_text(size = 15,  color = "black", face = "bold", vjust = 0.5, hjust = 0.5, angle = 90))
PSilhouette=ggplot(data=dataforplot,aes(x=cutoff,y=Silhouette))+geom_line()+theme(plot.title = element_text(colour = "firebrick",hjust=0.5))+ddu
print(PSilhouette)
dev.off()
