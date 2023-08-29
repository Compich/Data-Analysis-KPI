import networkx as nx

def rank_graph(scores):
    g = nx.Graph()
    g.add_weighted_edges_from(scores)  # Создание графа с весами ребер
    pr = nx.pagerank(g)
    return pr
