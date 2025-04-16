allparas=commandArgs()
getpathindex=grep("^--file=",allparas)
getpath=gsub("^--file=", "", allparas[getpathindex])
getbasepathsub=dirname(getpath)
input_plasmid_seq=allparas[6]
input_membership=allparas[7]
membercutoff=allparas[8]
#sampleTimes=allparas[9]
outputtag=allparas[9]
library(vegan)
library(readr)
library(readxl)
library(writexl)
library(tidyverse)
qbxx=read_tsv(input_membership)
than100=names(table(qbxx$membership))[table(qbxx$membership)>=membercutoff]
#df0=qbxx%>%filter(membership%in%than100)
membershipUnique=than100
#########遍历所有社区的new gene
source(sprintf("%s/heatmap.full.genome.pipeline.R",getbasepathsub))
#folders=list.files("/data/lizhenpeng/wuxinmiao/again/a_diversity_more10goups/roary_than10/", full.names = TRUE)  
folders=amat
runtimes=100
comlist=list()
for (community_name in membershipUnique){
  # 获取当前文件夹的名称，对应于社区的名称 
  getplasmidsnam=qbxx$plasmids[qbxx$membership==community_name]
  getplasmidsnam1=gsub("\\..*$","",getplasmidsnam)
  amat_sub=amat[rownames(amat)%in%getplasmidsnam1,]
  fff=t(amat_sub)
  #fff[!is.na(fff)]=1
  #fff[is.na(fff)]=0
  allstrains=colnames(fff)
  allstrainnum=length(allstrains)
  #new gene 行为基因，列为菌株
  kkkmat_new=matrix(NA,runtimes,allstrainnum)
  for(cc in 1:runtimes){
    #print(c("cc",cc))
    genomeselect=sample(allstrains)
    allgenearray_new=rep(NA,times=allstrainnum)
    prepan=rep(0,times=dim(fff)[1])
    for(kkk in 1:allstrainnum){
      gselect=genomeselect[kkk]
      strainck=allstrains%in%gselect
      zz1=which(prepan==0)
      prepan=(as.integer(fff[,strainck])+prepan)
      zz0=which(as.integer(fff[,strainck])==1)
      allgenenum=length(intersect(zz0,zz1))
      allgenearray_new[kkk]=allgenenum
    }
    kkkmat_new[cc,]=allgenearray_new
  }
  comlist[[as.character(community_name)]]=list(membership = community_name, matrix=kkkmat_new)
}
save(comlist,file="comlist")
load("./comlist")


############22社区的alpha值
#folders=list.files("/data/lizhenpeng/wuxinmiao/again/a_diversity_more10goups/roary_than10/", full.names = TRUE)  
#
forfitn=function(x,K,alpha){
  return(K*x^(-alpha))
}
# 自定义抖动函数，只向正方向抖动  
jitter_positive <- function(x, factor = 0.1) {  
  # 生成一个与x长度相同的随机扰动，扰动范围是0到factor之间的正数  
  jitter_amount <- runif(length(x), 0, factor)  
  # 将随机扰动加到原始数据上  
  return(x + jitter_amount)  
} 

forcoefs=list()
for(i in names(comlist)){
  eachcom=comlist[[i]]
  allstrainnum=dim(eachcom$matrix)[2]
  xaxis_O1_new=1:allstrainnum
  yaxis_O1_new=apply(eachcom$matrix,2,median)
  #
  Kv=seq(1,1000,by=10)
  alphaV=seq(0.01,2.5,by=0.1)
  flag=FALSE
  #
  for(g02 in Kv){
    if(flag==TRUE){
      break
    }
    for(g03 in alphaV){
      newy=jitter_positive(yaxis_O1_new)
      ffmm=try(nls(newy~ forfitn(x=xaxis_O1_new,K,alpha),start=list(K=g02,alpha=g03)))
      print(c(g02,g03))
      if(class(ffmm)!="try-error"){
        flag=TRUE
        break
      }
    }
  }
  #
  ffmm=try(nls(newy ~ forfitn(x=xaxis_O1_new,K,alpha),start=list(K=g02,alpha=g03)))
  if(class(ffmm)!="try-error"){
    fit_res=coef(ffmm)
    Kn=fit_res[1]
    alphan=fit_res[2]
    forcoefs[[i]]=list(Kn=fit_res[1], alphan=fit_res[2])
    cat(i, Kn=Kn, alphan=alphan, file = "roary_newgene_alpha1.txt", append = TRUE, sep = "\n")
  }
}
##############

#画22个拟合曲线+散点图
library(ggplot2)
library(gridExtra)
library(patchwork)
ppp=list()
#load("/data/lizhenpeng/wuxinmiao/again/pan/comlist")
#community_params=read_tsv("roary_newgene_alpha1.txt",col_names=T)
for(j in 1:length(comlist)){
  jnam=names(comlist)[j]
  mem=comlist[[jnam]]$membership
  #community_name <- community_params$membership[j] # 假设community_params和comlist按相同顺序排列
  #alphan=community_params$alpha[community_params$membership==mem]
  #Kn=community_params$K[community_params$membership==mem]
  alphan=forcoefs[[jnam]]$alphan
  Kn=forcoefs[[jnam]]$Kn
  kkkmat_new=comlist[[jnam]]$matrix
  #kkkmat_new=comlist[[j]]
  allstrainnum=dim(kkkmat_new)[2]
  xaxis_O1_new=1:allstrainnum
  yaxis_O1_new=apply(kkkmat_new,2,median)
  yaxis_O1_new0=kkkmat_new
  ranged=sapply(1:dim(kkkmat_new)[2],function(xxx)quantile(kkkmat_new[,xxx],c(0.025,0.975)))
  dataf_new=cbind(xaxis_O1_new,yaxis_O1_new, t(ranged))
  dataf_new=as.data.frame(dataf_new)
  names(dataf_new)=c("StrainNumber","Median_new","Percent2.5_new","Percent97.5_new")
  
  #
  # 生成一个新的x值范围以用于绘图  
  new_x=1:allstrainnum  
  new_y=Kn*new_x^(-alphan)
  
  df_new=data.frame(StrainNumber=rep(dataf_new$StrainNumber,each=100),yaxis_O1_new0=as.vector(yaxis_O1_new0))
  ##pdf("test.pdf")
  fordata=data.frame(new_x,new_y)
  ppp[[j]]=ggplot(fordata) +  
    geom_line(aes( x = new_x, y = new_y),linewidth=1,colour="#E04832",linetype = "solid")+
    #geom_pointrange(data=dataf_new,aes(x = StrainNumber, y = Median_new, ymin = Percent2.5_new, ymax = Percent97.5_new),col="dodgerblue",fill ="dodgerblue4", alpha = 0.3, size = 0.04)+
    #geom_pointdensity(data = df_new,aes(x =StrainNumber, y = yaxis_O1_new0) ,size = 0.5,pch=19,adjust = 5)+    
    #scale_color_gradient(low = "lightblue", high = "darkblue") + # 定义颜色渐变  
    xlab("Number of plasmid genomes") +  
    ylab("Number of new genes") +
    theme_bw() +  
    theme(axis.text = element_text(size =5, face = "bold", angle = 0)) +
    theme(axis.title.x = element_text(size =5,  color = "black", face = "bold", vjust = 0.5, hjust = 0.5, angle = 0),
          axis.title.y = element_text(size = 5,  color = "black", face = "bold", vjust = 0.5, hjust = 0.5, angle = 90))
  #print(p)
  #dev.off()
}
p=ppp[[1]]
for(np in 2:length(ppp)){
  
  p=p+ppp[[np]]
  
}
pdf(sprintf("%s_allmem.pdf",outputtag),12,7)
p=p+plot_layout(ncol=5)
print(p)
dev.off()
