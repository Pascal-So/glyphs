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

class Graph {
    private ArrayList<ArrayList<Edge> > nodes;

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



    private ArrayList<Edge> getEdges() {
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

    public Graph mst() {
        ArrayList<Edge> used = new ArrayList<Edge>();
        ArrayList<Edge> allEdges = getEdges();
        
        Collections.sort(allEdges);
        
        UnionFinder u = new UnionFinder(nodes.size());
        
        
        return new Graph();
    }
}