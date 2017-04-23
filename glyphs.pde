import java.util.Collections;
int glyph_brightness = 200;


size(640, 360);
background(35);

noStroke();
fill(glyph_brightness);





class Glyph {
    public PShape toShape(int raster_size) {
        PShape s;
        s = createShape();
        return s;
    }
}



beginShape();
vertex(0, 0);
vertex(0, 10);
vertex(10, 10);
vertex(10, 0);
endShape(CLOSE);