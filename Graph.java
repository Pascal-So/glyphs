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
    public Graph(int size, ArrayList<Edge> edges){
        nodes = new ArrayList<ArrayList<Edge> >();
        for(int i = 0; i < size; i++){
            nodes.set(i, new ArrayList<Edge> ());
        }
        
        for(Edge e:edges){
            Edge flipped = new Edge(e);
            flipped.flip();
            
            nodes.get(e.start).add(e);
            nodes.get(e.destination).add(flipped);
        }
    }

    private ArrayList<Edge> getEdges() { // returns only one edge per nodepair, start is always lower than destination
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

    public void insertEdge(int start, int destination, double weight){ // adds both directions
        if(hasEdge(start, destination)){
            return;
        }
        
        Edge e = new Edge(start, destination, weight);
        Edge flipped = new Edge(e);
        flipped.flip();
        
        nodes.get(start).add(e);
        nodes.get(destination).add(flipped);
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