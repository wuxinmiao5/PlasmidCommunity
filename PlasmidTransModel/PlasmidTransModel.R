library(tidymodels)
library(tidyverse)
library(Biostrings)
library(seqinr)
allparas=commandArgs(trailingOnly = FALSE)
#getpathindex=grep("^--file=",allparas)
#getpath=gsub("^--file=", "", allparas[getpathindex])
getdir=dirname(Sys.which("PlasmidTransModel.R"))
getdir0=dirname(getdir)
#inputgenome="GCA_015356015__CP064244.1.fasta"
#outputnam="modelmerge"
inputgenome=allparas[6]
outputnam=allparas[7]
#modeltype=c("Binary","ThreeClass")
modeltype=allparas[8]
if(modeltype=="Binary"){
	load(sprintf("%s/data/binaryModel.Rdata",getdir0))
	user_file=readDNAStringSet(filepath =inputgenome,format="fasta")
	pentamer_freq=as.data.frame(oligonucleotideFrequency(user_file, width=5,as.prob= TRUE, with.labels = T))
	pentamer_freq=pentamer_freq%>%mutate(plasmids=names(user_file))%>%select(plasmids,everything())
	pentamer_trans=unlist(pentamer_freq[1,2:dim(pentamer_freq)[2]])
	forinput_kmer=rep(0,each=length(feature_best))
	forinput_kmer=sapply(1:length(forinput_kmer),function(xxx){if(feature_best[xxx]%in%names(pentamer_trans)){pentamer_trans[names(pentamer_trans)%in%feature_best[xxx]]}else{0}},USE.NAMES=FALSE)
	names(forinput_kmer)=feature_best
	newfit=workflow_best%>%fit(fulldata_extract)
	modelinput=matrix(forinput_kmer,nrow=1)
	colnames(modelinput)=feature_best
	pre=augment(newfit,modelinput)
	write_tsv(pre,sprintf("%s_prediction_2class.txt",outputnam))
}else{
  load(sprintf("%s/data/threeClassModel.Rdata",getdir0))
	genefeature=c("group_13847","group_1599","group_5662","group_13427")
	kmerfeature=c("CAGGC" , "ACAGA" , "GACGC" , "GGCCG" ,"AGAGA" ,"CTCCG" ,"CTCTT",
	"ACATC" ,"CTGGT", "GCGGC"   ,"TTGTT"  , "CCGGT", "TCAGC" ,"GAAGG")
	prodigalcode=sprintf("prodigal -a target.pep -d target.cds -g 11 -p single -i %s",inputgenome)
	makedb="makeblastdb -in model3.fasta  -dbtype prot -title model -out model"
	blastpcode="blastp -db model -query target.pep -out model.out -evalue 0.00001 -outfmt 6 -max_target_seqs 10000000 -max_hsps 1000 -qcov_hsp_perc 80 -num_threads 4"
	system(prodigalcode)
	system(makedb)
	system(blastpcode)
	#gene feature
	readout=read_tsv("model.out",col_names=FALSE)
	if(dim(readout)[1]==0){
		 uniquematch=c()
	}else{
		readout01=readout%>%filter(X3>95)%>%group_by(X1)%>%filter(X3==max(X3))
		readout02=as.data.frame(readout01)
		uniquematch=unique(readout02$X2)
	}
	forinput_gene=rep(0,each=4)
	names(forinput_gene)=genefeature
	forinput_gene[forinput_gene%in%uniquematch]=1
	#kmer feature
	user_file=readDNAStringSet(filepath =inputgenome,format="fasta")
	pentamer_freq=as.data.frame(oligonucleotideFrequency(user_file, width=5,as.prob= TRUE, with.labels = T))
	pentamer_freq=pentamer_freq%>%mutate(plasmids=names(user_file))%>%select(plasmids,everything())
	pentamer_trans=unlist(pentamer_freq[1,2:dim(pentamer_freq)[2]])
	forinput_kmer=rep(0,each=14)
	forinput_kmer=sapply(1:length(forinput_kmer),function(xxx){if(kmerfeature[xxx]%in%names(pentamer_trans)){pentamer_trans[names(pentamer_trans)%in%kmerfeature[xxx]]}else{0}},USE.NAMES=FALSE)
	names(forinput_kmer)=kmerfeature
	getfeatureinput=c(forinput_gene,forinput_kmer)
	newfit=workflow_best%>%fit(fulldata_extract)
	pre=augment(newfit,t(as.data.frame(getfeatureinput)))
	write_tsv(pre,sprintf("%s_prediction_3class.txt",outputnam))
#
}
