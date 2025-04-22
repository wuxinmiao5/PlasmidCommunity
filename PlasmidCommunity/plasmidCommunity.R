allparas=commandArgs(trailingOnly=FALSE)
getpathindex=grep("^--file=",allparas)
getpath=gsub("^--file=", "", allparas[getpathindex])
getbasepath=dirname(getpath)
getMode=allparas[6]
if(getMode=="silhouetteCurve"){
  plasmid_seq=allparas[7]
  output_tag=allparas[8]
  execode=sprintf("Rscript %s %s %s", Sys.which("silhouetteCurve.R"),plasmid_seq,output_tag)
  system(execode)
}else if(getMode=="getCommunity"){
  fastani=allparas[7]
  discutoff=allparas[8]
  membercutoff=allparas[9]
  output_tag=allparas[10]
  execode=sprintf("Rscript %s %s %s %s %s", Sys.which("getCommunity.R"),fastani,discutoff,membercutoff,output_tag)
  system(execode)
}else if(getMode=="pan"){
  plasmid_seq=allparas[7]
  membership_info=allparas[8]
  membercutoff=allparas[9]
  output_tag=allparas[10]
  execode=sprintf("Rscript %s %s %s %s %s", Sys.which("pan.R"),plasmid_seq,membership_info,membercutoff,output_tag)
  system(execode)
}
