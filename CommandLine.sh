# Question 1
echo "1. Is there any node that acts as a significant connector between the different parts of the graph?"
most_connected_node=$(grep -o 'target="[0-9]*"' citation_graph.graphml | cut -d'"' -f2 | sort | uniq -c | sort -nr | head -n 1)
echo "Yes, Here is the most connected node: $most_connected_node"

# Question 2
echo "2. How does the degree of citation vary among the graph nodes?"
degree_range=$(grep -o 'target="[0-9]*"' citation_graph.graphml | cut -d'"' -f2 | sort | uniq -c | sort -nr | awk '{print $1}' | uniq | awk 'BEGIN {ORS=", "} {print}')
echo "  The degree of citations varies from: $degree_range"

# Question 3
echo "3. What is the average length of the shortest path among nodes?"

# Using Python to calculate the average shortest path length
python -c '
import networkx as nx

# Load the graph from a GraphML file
citation_graph = nx.read_graphml("citation_graph.graphml")

# Function to calculate the average shortest path length for a graph or its connected components
def calculate_average_shortest_path(graph):
    if nx.is_strongly_connected(graph):
        # Calculate the average shortest path length for the entire strongly connected graph
        return nx.average_shortest_path_length(graph), 1
    else:
        print("   Graph is not strongly connected.")

        # Calculate average shortest path length for each connected component
        connected_components = list(nx.strongly_connected_components(graph))
        total_paths = 0
        for i, component in enumerate(connected_components, start=1):
            component_average_distance = nx.average_shortest_path_length(graph.subgraph(component))
            total_paths += component_average_distance

        return total_paths, i

# Calculate the average shortest path length and the number of connected components
average_length, component_count = calculate_average_shortest_path(citation_graph)

# Calculate the final average shortest path length
if component_count > 1:
    final_average_length = average_length / component_count
    print(f"   Average shortest path length (across connected components): {final_average_length}")
else:
    print(f"   Average shortest path length (strongly connected graph): {average_length}")
'
