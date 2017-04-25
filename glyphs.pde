import java.util.*;
int glyph_brightness = 200;

void setup(){
    
    size(1080, 720);
    background(35);
    
    stroke(glyph_brightness);
    strokeCap(PROJECT);
    strokeWeight(7);
    fill(glyph_brightness);
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
    
        Comparator<Integer> comp = new Comparator<Integer>() {
            @Override
            public int compare(Integer a, Integer b) {
                return getGridDirection(startIndex, a) - getGridDirection(startIndex, b);
            }
        };
    
        Collections.sort(destinations, comp);
    
        // outedges are now sorted in clockwise direction (assuming (0, 0) is in the top left corner)
    
        int parentPos = -1;
        int nOut = destinations.size();
        
        for(int i = 0; i < nOut; i++){
            if(destinations.get(i) == parentIndex){
                parentPos = i;
                break;
            }
        }
        if(parentPos == -1){
            parentPos = 0;
            destinations.add(0, -1);
            // add a dummy value, this is safe because we must be in the top left corner
        }
    
        ArrayList<Integer> out = new ArrayList<Integer>();
        
        for(int i = (parentPos+1)%nOut; i != parentPos; i = (i+1) % nOut){
            out.add(startIndex);
            out.addAll(treeTraversal(g, destinations.get(i), startIndex));
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
        s.stroke(0);
        s.strokeWeight(0.1);

        PMatrix2D rotateClockwise = new PMatrix2D(0, 1, 0, -1, 0, 0);

        int nTrav = traversal.size();

        nTrav -- ;
        traversal.remove(nTrav);
        //nTrav/=2;

        println(traversal);

        for(int i = 0; i < nTrav; i++){
            int prev = traversal.get((i-1+nTrav) % nTrav);
            int current = traversal.get(i);
            int next = traversal.get((i+1) % nTrav);

            int dirOld = getGridDirection(prev, current);
            int dirNew = getGridDirection(current, next);

            PVector frontLeftCorner = matrixPower(rotateClockwise, dirOld).mult(new PVector(-0.2, 0.2), null);
            PVector frontRightCorner = rotateClockwise.mult(frontLeftCorner, null);
            PVector backRightCorner = rotateClockwise.mult(frontRightCorner, null);
            PVector backLeftCorner = rotateClockwise.mult(backRightCorner, null);

            PVector gridPosition = getGridPosition(current);

            frontLeftCorner.add(gridPosition);
            frontRightCorner.add(gridPosition);
            backRightCorner.add(gridPosition);
            backLeftCorner.add(gridPosition);
            
            
            s.vertex(backLeftCorner.x, backLeftCorner.y);

            
            if(dirOld == (dirNew + 1) % 4){ // left bend
                // don't add any vertecies
            }else if(dirOld == dirNew){ // no bend
                s.vertex(frontLeftCorner.x, frontLeftCorner.y);
            }else if((dirOld + 1) % 4 == dirNew){ // right bend
                s.vertex(frontLeftCorner.x, frontLeftCorner.y);
                s.vertex(frontRightCorner.x, frontRightCorner.y);
            }else{ // turnaround
                s.vertex(frontLeftCorner.x, frontLeftCorner.y);
                s.vertex(frontRightCorner.x, frontRightCorner.y);
                s.vertex(backRightCorner.x, backRightCorner.y);
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
            g.drawTree(rasterSize, x, y);
        }
    }*/
    
    Glyph g = new Glyph(glyphWidth, glyphHeight);
    g.drawTree(rasterSize, 30, 30);
    
    PShape outline = g.getOutline();
    
    outline.scale(rasterSize); //<>//
    
    shape(outline, 30, 30);
    /*
    PShape s = createShape();
    
    
    s.beginShape();
    
    s.noFill();
    s.vertex(300, 200);
    s.vertex(300, 250);
    s.vertex(350, 200);
    s.endShape(CLOSE);
    
    shape(s, 0, 0);
    */
    text(outline.getVertexCount(), 400, 200);
}