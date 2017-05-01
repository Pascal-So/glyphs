import java.util.*;
color background_colour = color(33, 49, 64);
color glyph_colour = color(236, 239, 241);

void setup(){
    
    size(1850, 920);
    background(background_colour);
    
    stroke(glyph_colour);
    strokeCap(PROJECT);
    strokeWeight(7);
    fill(glyph_colour);
    noLoop();

}

PMatrix2D matrixPower(PMatrix2D m, int n){
    PMatrix2D out = m.get();
    if(n <= 0){
        return new PMatrix2D();
    }
    
    while(n > 1){
        out.apply(out);
        if(n % 2 == 1){
        out.apply(m);
        }
        n/=2;
    }
    
    return out;
}

class Glyph {
    Graph tree;
    int width, height;
    
    public Glyph(int width, int height){
        this.width = width;
        this.height = height;
        Graph g = Graph.createGridGraph(width, height, 1d);
        g.randomizeWeights();
        tree = g.mst();
    }

    private PVector getGridPosition(int index){
        int x = index % width;
        int y = index / width;
        
        return new PVector(x, y);
    }

    private int getGridDirection(int start, int end){
        if(end <= start - width){
            return 2;
        }else if(end >= start + width){
            return 0;
        }else if(end > start){
            return 1;
        }else{
            return 3;
        }
    }
    
    private ArrayList<Integer> treeTraversal(Graph g, final int startIndex, int parentIndex){
        ArrayList<Integer> destinations = g.getDestinations(startIndex);

    	ArrayList<Integer> destinationsByDirection = new ArrayList<Integer>();
            for(int i = 0; i < 4; i++){
    	    destinationsByDirection.add(-1);
    	}
    
    	int parentDirection = getGridDirection(startIndex, parentIndex);
    	
    	for(Integer dest:destinations){
    	    destinationsByDirection.set(getGridDirection(startIndex, dest), dest);
    	}
    
    	// noop for root node, because -1 must be to the left
    	destinationsByDirection.set(parentDirection, -1); 
    
        ArrayList<Integer> out = new ArrayList<Integer>();
        
        for(int i = (parentDirection + 3) % 4; i != parentDirection; i = (i + 3) % 4){
            if(destinationsByDirection.get(i) >= 0){
                out.add(startIndex);
                out.addAll(treeTraversal(g, destinationsByDirection.get(i), startIndex));
            }
        }
        out.add(startIndex);
    
        return out;
    }

    private ArrayList<Integer> treeTraversal(){
        return treeTraversal(tree, 0, -1);
    }

    
    public void drawTree(int raster_size, int x, int y){
        ArrayList<Edge> edges = tree.getEdges();
        PVector offset = new PVector(x, y);
        for(Edge e : edges){
            PVector start = getGridPosition(e.start).mult(raster_size).add(offset);
            PVector destination = getGridPosition(e.destination).mult(raster_size).add(offset);
            line(start.x, start.y, destination.x, destination.y);
        }
    }
    
    public PShape getOutline() {
        ArrayList<Integer> traversal = treeTraversal();
    
        PShape s;
        s = createShape();
        s.beginShape();
        s.noFill();
        s.strokeWeight(3/22);

        PMatrix2D rotateClockwise = new PMatrix2D(0, -1, 0, 1, 0, 0);

        int nTrav = traversal.size();

        nTrav -- ;
        traversal.remove(nTrav);


        for(int i = 0; i < nTrav; i++){
            int prev = traversal.get((i-1+nTrav) % nTrav);
            int current = traversal.get(i);
            int next = traversal.get((i+1) % nTrav);

            int oldDir = getGridDirection(prev, current);
            int newDir = getGridDirection(current, next);


            PVector corner = matrixPower(rotateClockwise, 4-oldDir).mult(new PVector(0.25, -0.25), null);

            PVector gridPosition = getGridPosition(current);

            PVector vertex = new PVector(0, 0);

    	    int diffDir = (oldDir-newDir+5)%4;
    	    
    	    for(int j = 0; j <= diffDir; j++){
                    PVector.add(gridPosition, corner, vertex);
                    s.vertex(vertex.x, vertex.y);
    
                    corner = rotateClockwise.mult(corner, null);
                    
    	    }
        }
        
        s.endShape(CLOSE);
        return s;
    }
}


ArrayList<PVector> getShapeVertecies(PShape s){
    ArrayList<PVector> out = new ArrayList<PVector>();
    for(int i = 0; i < s.getVertexCount(); i++){
        out.add(s.getVertex(i));
    }
    return out;
}

void draw(){
    

    int rasterSize = 14;
    
    int glyphHeight = 3;
    int glyphWidth = 5;
    
    /*for(int y = 20; y < height - rasterSize * glyphHeight; y += rasterSize * (glyphHeight + 1)){
        for(int x = 20; x < width - rasterSize * glyphWidth; x += rasterSize * (glyphWidth + 1)){
            Glyph g = new Glyph(glyphWidth, glyphHeight);
            PShape outline = g.getOutline();
            g.drawTree(rasterSize, x, y);
            outline.scale(rasterSize);
    
            //shape(outline, x, y);
        
        }
    }*/
    
    int glyphMinWidth = 2;
    int glyphMaxWidth = 9;
    
    Random r = new Random();
    
    
    // generate word like structures
    for(int y = 20; y < height - rasterSize * glyphHeight; y += rasterSize * (glyphHeight + 1)){
        for(int x = 20; x < width - rasterSize * glyphMaxWidth; x += rasterSize/2){
            int len = r.nextInt(glyphMaxWidth - glyphMinWidth) + glyphMinWidth;
            
            Glyph g = new Glyph(len, glyphHeight);
            g.drawTree(rasterSize, x, y);
            
            x += len * rasterSize;
        }
    }
    
    //Glyph g = new Glyph(glyphWidth, glyphHeight);
    //g.drawTree(rasterSize, 30, 30);
    
    //PShape outline = g.getOutline();
    
    //outline.scale(rasterSize); //<>//
    
    //shape(outline, 150, 30);

    //text(outline.getVertexCount(), 400, 200);
}