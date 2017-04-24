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
    
    public Glyph(int width, int height){
        Graph g = createGridGraph(width, height, 1d);
        g.randomizeWeights();
        tree = g.mst();
        g = null;
    }
    
    public PShape toShape(int raster_size) {
        PShape s;
        s = createShape();
        return s;
    }
}



void draw(){
    beginShape();
    vertex(0, 0);
    vertex(0, 10);
    vertex(10, 10);
    vertex(10, 0);
    endShape(CLOSE);
}