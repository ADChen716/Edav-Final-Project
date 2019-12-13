library(igraph)
library(readr)
library(networkD3)

artist_df <- read.csv("data/clean/singer_connection/global.csv", header = T)
row.names(artist_df) <- artist_df$X
artist_mat <- select(artist_df, -"X") %>%
  as.matrix()

network <- graph_from_adjacency_matrix(artist_mat, weighted=T, mode="undirected", diag=F)
wc <- cluster_walktrap(network)
members <- membership(wc)
netword_d3 <- igraph_to_networkD3(network, group = members)
forceNetwork(Links =netword_d3$links, Nodes = netword_d3$nodes, 
             Source = 'source', Target = 'target',
             NodeID = 'name', Group = 'group',
             linkDistance = 30, fontSize = 20, 
             opacity = 0.8, charge = -5)