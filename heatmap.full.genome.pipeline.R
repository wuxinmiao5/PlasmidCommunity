#setwd("/disk/lizhenpeng/test")
library(seqinr)
allfilepath=list.files("./plasmids",full.names=T)
mergefiles=function(xxx,forname){
    filenamed=paste(forname,"fasta",sep=".")
    file.create(filenamed)
    file.append(filenamed,xxx)
}
unlink("allcds",recursive =T)
dir.create("allcds")
# /share/nas2/duyu/software/bin/prodigal -a seq.pep -d seq.cds -f gbk -g 11  -o seq.gbk -p single -s seq.stat -i seq.faq
for(i in allfilepath){
    seqnam=rev(strsplit(i,split="\\/")[[1]])[1]
    seqnam=strsplit(seqnam,split="\\.")[[1]][1]
    P0="prodigal"
    P1=paste("-a",paste("./","allcds","/",seqnam,".pep",sep=""),sep=" ")
    P2=paste("-d",paste("./","allcds","/",seqnam,".cds",sep=""),sep=" ")
    P3=paste("-f","gff",sep=" ")
    P4=paste("-g","11",sep=" ")
    P5=paste("-o",paste("./","allcds","/",seqnam,".gbk",sep=""),sep=" ")
    P6=paste("-p","meta",sep=" ")
    P7=paste("-s",paste("./","allcds","/",seqnam,".stat",sep=""),sep=" ")
    P8=paste("-i", i ,sep=" ")
    pv=c(P0,P1,P2,P3,P4,P5,P6,P7,P8)
    system(paste(pv,collapse=" "))
}
allprodigialfiles=list.files("./allcds/",full.names=TRUE)
cdsgrep=grepl("\\.cds",allprodigialfiles)
file.remove(allprodigialfiles[!cdsgrep])
#cdsgrepget=list.files("./allcds/",full.names=TRUE)[cdsgrep]
#change ID
cdsfiles=list.files("./allcds/",full.names=TRUE)
#aa=aa[2:length(aa)]
#aatrans=rev(strsplit(aa,split="\\/")[[1]])[1]
#dir.create("nanopore_withid")
for(i in 1:length(cdsfiles)){
    seqed=c()
    named=c()
    aatrans=rev(strsplit(cdsfiles[i],split="\\/")[[1]])[1]
    redfasta=read.fasta(cdsfiles[i],as.string=T)
    getid=strsplit(aatrans,split="\\.")[[1]][1]
    print(getid)
    named=append(named,paste(getid,names(redfasta),sep="-"))
    seqed=toupper(as.character(redfasta))
    fileoutnam=paste("./allcds/",aatrans,sep="")
    write.fasta(as.list(seqed),named,file.out=fileoutnam)
}

mergefiles(cdsfiles,"allcdssum")
#cd-hit
cdhitcodes="cd-hit-est -i allcdssum.fasta -o ref.greedy.fasta -c 0.9 -n 9 -d 0 -M 16000 -T 24 -s 0.9"
system(cdhitcodes)
makecode="makeblastdb -in allcdssum.fasta -dbtype nucl -title allO -out allO"
blastcode="blastn -db allO -query ref.greedy.fasta -out ref.greedy.txt -evalue 0.00001 -outfmt 6 -qcov_hsp_perc 60 -max_target_seqs 1000000 -max_hsps 1 -num_threads 36"
makecode02="makeblastdb -in ref.greedy.fasta -dbtype nucl -title allO02 -out allO02"
blastcode02="blastn -db allO02 -query allcdssum.fasta -out ref.greedy02.txt -evalue 0.00001 -outfmt 6 -qcov_hsp_perc 60 -max_target_seqs 1000000 -max_hsps 1 -num_threads 36"
#
system(makecode)
system(blastcode)
system(makecode02)
system(blastcode02)
aa=read.table("ref.greedy.txt",header=F,stringsAsFactors=F,sep="\t",quote="",comment.char="#")
aa02=read.table("ref.greedy02.txt",header=F,stringsAsFactors=F,sep="\t",quote="",comment.char="#")
match01=paste(aa$V1,aa$V2,sep="")
match02=paste(aa02$V2,aa02$V1,sep="")
bothck=match01%in%match02
aaf=aa[bothck,]
#
#cdsgrepget=list.files("/datapool/NAS01-2/lizhenpeng/VFDB/biotype.classifier/strainscds",full.names=T)
nams=list.files("./allcds/")
nams02=sapply(nams,function(xxx)strsplit(xxx,split="\\.")[[1]][1],USE.NAMES=F)
nams03=paste(nams02,"-",sep="")
amat=c()
linetag=names(read.fasta("ref.greedy.fasta"))
for(ii in nams03){
	#iii=paste(ii,"-",sep="")
	checked=grepl(ii,aaf$V2)
	eachline=as.numeric(linetag%in%(aaf$V1[checked]))
	amat=rbind(amat,eachline)
}

rownames(amat)=nams02
colnames(amat)=linetag
#write.table(amat,"huihui.heatmap.fullgenome02.txt",sep="\t",quote=F)
save(amat,file="amat")
#on windows
#amat=read.table("phage.heatmap.fullgenome.txt",sep="\t",header=T)
#amat_distance=dist(amat)
#amat_distance02=as.matrix(amat_distance)
library(pheatmap)
library(RColorBrewer)
library(gplots)
#pdf("heatmap.full.pdf",6,6,onefile=F)
load("amat")
png("heatmap.0822.png",30,30,units="in",res=300)
#scolors=colorpanel(100, low="red",mid="blue",high="white")
scolors=colorRampPalette(c("steelblue", "white", "firebrick3"))(50)
pheatmap(amat,show_colnames=FALSE,col=scolors,border_color="white",fontsize_row=12,fontsize_col=0.5,treeheight_row=60,treeheight_col=60,pointsize=24)
dev.off()
#pheatmap(amat_distance02,show_colnames=T,col=scolors,border_color="white")

#pheatmap(amat,show_colnames=T)
