import java.util.Collections;
int glyph_brightness = 200;

void setup(){
    
    size(640, 360);
    background(35);
    
    noStroke();
    fill(glyph_brightness);
    noLoop();

}

Graph createGridGraph(int width, int height, double weight){
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


class Glyph {
    Graph tree;
    int width, height;
    
    public Glyph(int width, int height){
        this.width = width;
        this.height = height;
        Graph g = createGridGraph(width, height, 1d);
        g.randomizeWeights();
        tree = g.mst();
    }
    
    
    private PVector getGridPosition(int index){
        int x = index % width;
        int y = index / width;
        
        return new PVector(x, y);
    }

    
    public void drawGlyph(int raster_size, int x, int y){
        ArrayList<Edge> edges = tree.getEdges();
        PVector offset = new PVector(x, y);
        for(Edge e : edges){
            PVector start = getGridPosition(e.start).mult(raster_size).add(offset);
            PVector destination = getGridPosition(e.start).mult(raster_size).add(offset);
            line(start.x, start.y, destination.x, destination.y);
        }
    }
    
    public PShape toShape(int raster_size) {
        PShape s;
        s = createShape();
        return s;
    }
}



void draw(){
    Glyph g = new Glyph(10, 5);
    
    g.drawGlyph(5, 100, 100);
}