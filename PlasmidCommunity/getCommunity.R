library(ape)
library(tidyverse)
library(readr)
library(igraph)
library(ggraph)
library(qgraph)
library(tidygraph)
allparas=commandArgs()
#getpathindex=grep("^--file=",allparas)
#getpath=gsub("^--file=", "", allparas[getpathindex])
#getbasepathsub=dirname(getpath)
input_fastani=allparas[6]
discutoff=allparas[7]
membercutoff=allparas[8]
outputtag=allparas[9]
load(input_fastani)
ddd=treedist
ddd[treedist<discutoff]=1
ddd[treedist>=discutoff]=0
qqq=graph_from_adjacency_matrix(ddd,mode="undirected",weighted=TRUE,diag=FALSE)
set.seed(100)
qqq02=as_tbl_graph(qqq)
#zzz=activate(qqq02,edges)
#qqq03=qqq02%>%mutate(deg=centrality_degree(mode='all'))
#按照大于10的社区为主画图
community=cluster_louvain(qqq)
membership=membership(community)
membership0=membership
membertable=table(membership)
memsmaller10=names(membertable)[membertable<membercutoff]
memlarger10=setdiff(names(membertable), memsmaller10)
memsmaller10nams=names(membership)[membership%in%memsmaller10]
membership[names(membership)%in%memsmaller10nams]="undefinded"
qqq02=qqq02%>%mutate(Community=as.factor(as.character(membership)))
mem=as.data.frame(membership0)
community_output=data.frame(plasmids=rownames(mem),membership=mem$x)
#community_output=as.data.frame(node=names(membership),membership=membership)
write_tsv(community_output,file="membership_info.txt")

#创建一个颜色向量，其中"undefined"为灰色，其他为自动分配的颜色为qqq02$Community列中的每个唯一值分配一个颜色，其中"undefined"被特别分配为灰色（#808080）放在第一个位置，而后面其他值则通过scales::hue_pal()函数生成的调色板来分配颜色.
unique_communities=unique(V(qqq02)$Community[V(qqq02)$Community != "undefinded"])  
colors_palette <- scales::hue_pal()(length(unique_communities))  
undefinded_color <- "#808080"
community_to_color=setNames(as.vector(colors_palette),unique_communities)  
V(qqq02)$color <- ifelse(V(qqq02)$Community == "undefinded", undefinded_color, community_to_color[V(qqq02)$Community])  

#qqq04=qqq03%>%left_join(membered)
eee = as_edgelist (qqq02,names=FALSE)#qqq04转换为一个边列表（edgelist）,用于表示节点之间的连接关系
forlayout= qgraph.layout.fruchtermanreingold(eee,vcount=vcount(qqq02),area=1*(vcount(qqq02)^2),repulse.rad=(vcount(qqq02)^2.5))#模拟了节点之间的物理力，使得连接的节点聚集在一起，而未连接的节点则尽量远离
#vcount=vcount(qqq04): vcount函数计算qqq04中的节点数量。这个值用于算法中，可能用于确定布局的一些参数。
#area=1*(vcount(qqq04)^2)**: 定义了一个区域的面积，可能是布局时使用的虚拟画布或空间的面积。面积与节点数量的平方成正比，这意味着随着节点数量的增加，布局的空间也会相应增加。  
#repulse.rad=(vcount(qqq04)^2.5)**: 定义了节点之间的排斥力半径。这个值也与节点数量的某个幂次成正比，意味着随着节点数量的增加，排斥力的作用范围也会增加。这有助于避免在大量节点时，节点之间的重叠和拥挤。
pdf(sprintf("network_plot_%s.pdf",outputtag),22,20)
ddu= theme_minimal() +
  theme(
    plot.background = element_rect(fill = "white", color = "white"),  # 背景颜色和边框颜色
    panel.background = element_rect(fill = "white", color = "white"), # 面板背景颜色和边框颜色
    panel.grid.major = element_blank(), # 去除主要网格线
    panel.grid.minor = element_blank(), # 去除次要网格线
    axis.text = element_blank(),        # 去除坐标轴文本
    axis.ticks = element_blank(),       # 去除坐标轴刻度
    axis.title = element_blank(),       # 去除坐标轴标题
    legend.background = element_rect(fill = "white", color = "white") # 图例背景颜色和边框颜色
  )
pcore=ggraph(qqq02,layout=forlayout)+
  geom_edge_link0(aes(edge_width=0.01),color="lightblue",show.legend=FALSE)+
  scale_fill_manual(values = community_to_color)+
  geom_node_point(aes(fill=Community),size=5,shape=21,color="white")+ddu
print(pcore)
dev.off()

source(Sys.which("subNetwork.R"))
