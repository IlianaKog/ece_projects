#import pandas as pd
import wikipedia
import networkx as nx
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
import matplotlib.pyplot as plt
import numpy as np
#from bs4 import BeautifulSoup

def find_links_in_page(keyword): #input: title of article
    try:
        page = wikipedia.page(keyword, auto_suggest=False)
        links_inArticle = page.links
        return links_inArticle  #output: links in this article
    
    # except wikipedia.exceptions.DisambiguationError as e:
    #     first_option = e.options[0]
    #     page = wikipedia.page(first_option, auto_suggest=False)
    #     links_inArticle = page.links
    #     return links_inArticle
    
    except (wikipedia.exceptions.PageError, wikipedia.exceptions.DisambiguationError):
        return None #the article will be ignored


def most_relevant_links_in_article(keyword, links_article, model): #input: title, links in the article, model
    similarities = []
    relevant_words = []
    for word in links_article:
        
        sentences = [keyword, word]
        embeddings = model.encode(sentences)
        #similarity of titles of the 2 articles
        similarity = cosine_similarity([embeddings[0]], [embeddings[1]])
        
        if similarity > 0.6:
            similarities.append(float(similarity))
            relevant_words.append(word)
            
    return similarities, relevant_words


def create_Graph(keywords,max_depth, model):
    
    G = nx.DiGraph() #DiGraph
    
    articles = [(word, 0) for word in keywords]

    for current_article, current_depth in articles:

        if current_depth>=max_depth:
            break
        
        links_in_article = find_links_in_page(current_article)
        
        if links_in_article is None:
            continue #continue to next article
        if len(links_in_article) == 0:
            continue #continue to next article
        
        similarities, relevant_words = most_relevant_links_in_article(current_article, links_in_article, model)
        
        for link, similarity in zip(relevant_words, similarities):
            G.add_edge(current_article, link, weight = similarity)
            
        articles.extend((word, current_depth+1) for word in relevant_words)
        
    return G
 


model = SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')   

max_depth = 2
initial_topic = ["Mathematics", "Science", "Engineering", "Technology"]

G = create_Graph(initial_topic, max_depth, model)

#nx.write_gexf(G, "graph_newtopic.gexf")

#Analyze graph
print("-----------Graph Analysis----------------")
print("The graph is directed")

degree_centrality = nx.degree_centrality(G)

eigenvector_centrality = nx.eigenvector_centrality(G)
closeness_centrality = nx.closeness_centrality(G)
betweenness_centrality = nx.betweenness_centrality(G)
degree_histogram = nx.degree_histogram(G)

# Plot the distributions of centrality measures
plt.figure()
plt.hist(list(eigenvector_centrality.values()), color='blue', bins = 20)
plt.title("Eigenvector Centrality Distribution")
plt.figure()
plt.hist(list(closeness_centrality.values()), color='green', bins = 20)
plt.title("Closeness Centrality Distribution")
plt.figure()
plt.hist(list(betweenness_centrality.values()), color='red', bins = 20)
plt.title("Betweenness Centrality Distribution")
#plot the distributions of degree
plt.figure()
plt.hist(list(degree_histogram), color='blue', bins = 20)
plt.title("degree Distribution")

plt.show()

num_of_nodes = len(G.nodes)
print("num of Nodes:", num_of_nodes)
num_of_edges = len(G.edges)
print("num of Edges:", num_of_edges)

density = nx.density(G)
print("Graph density: %.5f" % density)

clustering_coeffs = nx.clustering(G)
avg_clustering = nx.average_clustering(G)
print("Average clustering coeff: %.2f" % avg_clustering)

communities = nx.community.greedy_modularity_communities(G)
num_of_communities = len(communities)
print('Number of communities in graph:', num_of_communities)

is_strongly_connected = nx.is_strongly_connected(G)
print('Is graph strongly connected? :', is_strongly_connected)
is_weakly_connected = nx.is_weakly_connected(G)
print('Is graph weakly connected? :', is_weakly_connected)

num_strongly_components = 0
for C in (G.subgraph(c).copy() for c in nx.strongly_connected_components(G)):
    num_strongly_components += 1

num_weakly_components = 0
for C in (G.subgraph(c).copy() for c in nx.weakly_connected_components(G)):
    num_weakly_components += 1

print("Strongly Connected Components: " , num_strongly_components )
print("Weakly Connected Components: " , num_weakly_components )

if is_strongly_connected:
    diameter = nx.diameter(G)
    radius = nx.radius(G)
    print("Diameter: ", diameter)
    print("Radius: ", radius)


for node in initial_topic:
    descendants = nx.descendants(G, node)
    print('The number of Descendants of node ', node, 'is :', len(descendants))
    ancestors = nx.ancestors(G, node)
    print('The number of Ancestors of node ', node, 'is :', len(ancestors))

source_node = 'Technology'
destination_node = 'Engineering'

def find_shortest_path(G, source_node, destination_node):
    if nx.has_path(G, source_node, destination_node):
        shortest_path = nx.shortest_path(G, source_node, destination_node)
        if len(shortest_path) < 10:
            print('Shortest path of : ', source_node, ' - ', destination_node)
            print(shortest_path)
        else:
            print('Shortest path len of : ', source_node, ' - ', destination_node)
            print(len(shortest_path))
    else:
        print('no path between ', source_node, ' - ', destination_node)

find_shortest_path(G, initial_topic[0], initial_topic[1])
find_shortest_path(G, initial_topic[2], initial_topic[3])
