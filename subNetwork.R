library(ape)
library(igraph)
library(ggraph)
library(qgraph)
#allparas=commandArgs()
#input_fastani=allparas[6]
#discutoff=allparas[7]
#membercutoff=allparas[8]
#outputtag=allparas[9]
ddd=treedist
ddd[treedist<discutoff]=1
ddd[treedist>=discutoff]=0
qqq=graph_from_adjacency_matrix(ddd,mode="undirected",weighted=TRUE,diag=FALSE)
qqq02=as_tbl_graph(qqq)
#zzz=activate(qqq02,edges)
qqq03=qqq02%>%mutate(deg=centrality_degree(mode='all'))
set.seed(100)
community=cluster_louvain(qqq)
membership=membership(community)
membertable=table(membership)
memsmaller10=names(membertable)[membertable<membercutoff]
memlarger10=setdiff(names(membertable), memsmaller10)
memsmaller10nams=names(membership)[membership%in%memsmaller10]
membership[names(membership)%in%memsmaller10nams]="undefinded"
qqq02=qqq03%>%mutate(Community=as.character(membership))
dir.create("subNetworkPlot")
for(i in memlarger10){
  smallname=V(qqq02)$name[V(qqq02)$Community==i]
  qqq03=induced_subgraph(qqq02, V(qqq02)[V(qqq02)$name %in% smallname])
  qqq03=as_tbl_graph(qqq03)
  layout <- create_layout(qqq03, layout = 'igraph',algorithm = 'kk')
  #layout$x[24]=0.3970372
  pdf(sprintf("./subNetworkPlot/subNetworkPlot_%s.pdf",i),15,10)
  pcore=ggraph(qqq03,layout=layout )+
    scale_size_continuous(name = "deg", breaks = unique(V(qqq03)$deg),labels = unique(V(qqq03)$deg)) +
    geom_edge_link0(edge_width=0.01,color="lightblue")+
    geom_node_point(aes(fill=factor(Community)),size=5,shape=21,color="white")
  #geom_node_text((aes(label=factor(name),size=2.5)#对度大于12的节点标注名字，并按权重绘制边的大小
  print(pcore)
  dev.off()
}
