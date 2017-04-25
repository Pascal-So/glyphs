import java.util.*;

class Edge implements Comparable<Edge> {
    public int start;
    public int destination;
    public double weight;
    
    @Override
    public int compareTo(Edge other){
        if(weight < other.weight){
            return -1;
        }else if(weight == other.weight){
            return 0;
        }else{
            return 1;
        }
    }
    
    public Edge(int start, int destination, double weight){
        this.start = start;
        this.destination = destination;
        this.weight = weight;
    }
    
    public Edge(Edge e){
        start = e.start;
        destination = e.destination;
        weight = e.weight;
    }
    
    public void flip(){
        int tmp = start;
        start = destination;
        destination = tmp;
    }
    
}

// undirected, weighted graph
class Graph {
    private ArrayList<ArrayList<Edge> > nodes; // start is always the current index, destination may be bigger or smaller than current index.

    public Graph() {
        nodes = new ArrayList<ArrayList<Edge> >();
    }
    public Graph(int size) {
        nodes = new ArrayList<ArrayList<Edge> >();
        for(int i = 0; i < size; i ++){
            nodes.add(new ArrayList<Edge> ());
        }
        
    }
    public Graph(int size, ArrayList<Edge> edges){
        nodes = new ArrayList<ArrayList<Edge> >();
        for(int i = 0; i < size; i++){
            nodes.add(new ArrayList<Edge> ());
        }
        
        for(Edge e:edges){
            Edge flipped = new Edge(e);
            flipped.flip();
            
            nodes.get(e.start).add(e);
            nodes.get(e.destination).add(flipped);
        }
    }

    public static Graph createGridGraph(int width, int height, double weight){
    	Graph g = new Graph(width * height);
        
    	for(int y = 0; y < height; y++){
    	    for(int x = 0; x < width; x++){
        		if(y < height - 1){
        		    g.insertEdge(y*width + x, (y+1)*width + x, weight);
        		}
        		if(x < width - 1){
        		    g.insertEdge(y*width + x, y*width + x + 1, weight);
        		}
    	    }
    	}
        
    	return g;
    }

    public int getSize(){
	    return nodes.size();
    }
    
    public ArrayList<Integer> getDestinations(int node){
    	ArrayList<Integer> destinations = new ArrayList<Integer>();
    
    	for(Edge e: nodes.get(node)){
    	    destinations.add(e.destination);
    	}
    
    	return destinations;
    }
    
    public ArrayList<Edge> getEdges() { // returns only one edge per nodepair, start is always lower than destination
        ArrayList<Edge> edges = new ArrayList<Edge>();
        for (int i = 0; i < nodes.size(); i++) {
            for (Edge e : nodes.get(i)) {
                if (e.destination > i) {
                    edges.add(e);
                }
            }
        }

        return edges;
    }

    public boolean hasEdge(int start, int destination){
        for(Edge e:nodes.get(start)){
            if(e.destination == destination){
                return true;
            }
        }
        return false;
    }

    private void removeDirectedEdge(int start, int destination){
        int index = -1;
        for(int i = 0; i < nodes.get(start).size(); i++){
            if(nodes.get(start).get(i).destination == destination){
                index = i;
                break;
            }
        }
        
        if(index != -1){
            nodes.get(start).remove(index);
        }
    }
    
    public void removeEdge(int start, int destination){
        removeDirectedEdge(start, destination);
        removeDirectedEdge(destination, start);
    }

    public void insertEdge(int start, int destination, double weight){ // adds both directions
        // overwrites existing edges
        removeEdge(start, destination);
        
        
        Edge e = new Edge(start, destination, weight);
        Edge flipped = new Edge(e);
        flipped.flip();
        
        nodes.get(start).add(e);
        nodes.get(destination).add(flipped);
    }
    
    public void randomizeWeights(){
        Random r = new Random(43);
        
        ArrayList<Edge> allEdges = getEdges();
        for(Edge e : allEdges){
            double newWeight = r.nextDouble();
            insertEdge(e.start, e.destination, newWeight);
        }
    }

    public Graph mst() {
        ArrayList<Edge> used = new ArrayList<Edge>();
        ArrayList<Edge> allEdges = getEdges();
        
        Collections.sort(allEdges);
        
        UnionFinder union = new UnionFinder(nodes.size());
        
        for(Edge e:allEdges){
            if( ! union.isUnited(e.start, e.destination)){
                union.unite(e.start, e.destination);
                used.add(e);
            }
        }
        
        return new Graph(nodes.size(), used);
    }
}