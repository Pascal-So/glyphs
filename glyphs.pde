import java.util.Collections;
int glyph_brightness = 200;

void setup(){
    
    size(640, 360);
    background(35);
    
    stroke(glyph_brightness);
    fill(glyph_brightness);
    noLoop();

}




void draw(){
    Glyph g = new Glyph(10, 5);

    int rasterSize = 5;
    
    g.drawTree(rasterSize, 100, 100);
    draw(g.getOutline(rasterSize), 200, 100);
}
