library(DiagrammeR)

grViz("
digraph DAG {

  # Intialization of graph attributes
  graph [overlap = true]

  # Initialization of node attributes
  node [shape = box,
        fontname = Helvetica,
        color = blue,
        type = box,
        fixedsize = true]

  # Initialization of edge attributes
  edge [color = green,
        rel = yields]

  # Node statements
 '销售净利率';'总资产收益率';'权益乘数';

  # Edge statements
  '销售净利率'->'总资产收益率'; '总资产收益率'->'权益乘数';
 
}
")
'总资产收益率';'总资产收益率';'权益乘数';'销售净利率';'总资产周转率';'净利润';'营业收入';'平均资产总额','全部成本';'投资收益';'所得税';'其他';'营业成本';'销售费用';'管理费用';'财务费用'



## Not run: 
# Create an empty graph
graph <- create_graph()

# Create a graph with nodes but no edges
nodes <- create_nodes(nodes = c("a", "b", "c", "d"))

graph <- create_graph(nodes_df = nodes)
display_graph_object(graph, width = 640)
# Create a graph with nodes with values, types, labels
nodes <- create_nodes(nodes = c("a", "b", "c", "d"),
                      label = TRUE,
                      type = c("type_1", "type_1",
                               "type_5", "type_2"),
                      shape = c("circle", "circle",
                                "rectangle", "rectangle"),
                      values = c(3.5, 2.6, 9.4, 2.7))

graph <- create_graph(nodes_df = nodes)

# Create a graph from an edge data frame, the nodes will
edges <- create_edges(from = c("a", "b", "c"),
                      to = c("d", "c", "a"),
                      rel = "leading_to")

graph <- create_graph(edges_df = edges)

# Create a graph with both nodes and nodes defined, and,
# add some default attributes for nodes and edges
graph <- create_graph(nodes_df = nodes,
                      edges_df = edges,
                      node_attrs = "fontname = Helvetica",
                      edge_attrs = c("color = blue",
                                     "arrowsize = 2"))

## End(Not run)