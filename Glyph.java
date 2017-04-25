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
	    return 0;
	}else if(end >= start + width){
	    return 2;
	}else if(end > start){
	    return 1;
	}else{
	    return 3;
	}
    }
    
    private ArrayList<Integer> treeTraversal(Graph g, int startIndex, int parentIndex){
	ArrayList<Integer> destinations = g.getDestinations(startIndex);

	Collections.sort(destinations, new Comparator<Integer>() {
		@Override
		public int compare(Integer a, Integer b) {
		    return getGridDirection(startIndex, b) - getGridDirection(startIndex, a);
		}
	    });

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
            PVector destination = getGridPosition(e.start).mult(raster_size).add(offset);
            line(start.x, start.y, destination.x, destination.y);
        }
    }
    
    public PShape getOutline(int raster_size) {
	ArrayList<Integer> traversal = treeTraversal();
	
        PShape s;
        s = createShape();
	s.beginShape();

	PMatrix2D rotateClockwise = new PMatrix2D(0, 1, 0, -1, 0, 0);

	int nTrav = traversal.size();
	
	for(int i = 0; i < nTrav; i++){
	    int prev = traversal.get((i-1+nTrav) % nTrav);
	    int current = traversal.get(i);
	    int next = traversal.get((i+1) % nTrav);

	    int dirOld = getGridDirection(prev, current);
	    int dirNew = getGridDirection(current, next);

	    PVector frontLeftCorner = Util.matrixPower(rotateClockwise, oldDir).mult(new PVector(-0.5, 0.5), null);
	    PVector frontRightCorner = rotateClockwise(frontLeftCorner, null);
	    PVector backRightCorner = rotateClockwise(frontRightCorner, null);

	    PVector gridPosition = getGridPosition(current);

	    frontLeftCorner.add(gridPosition);
	    frontRightCorner.add(gridPosition);
	    backRightCorner.add(gridPosition);
	    
	    if(dirOld == (dirNew + 1) % 4){ // left bend
		// don't add any vertecies
	    }else if(dirOld == dirNew){ // no bend
		s.vertex(frontLeftCorner);
	    }else if((dirOld + 1) % 4 == dirNew){ // right bend
		s.vertex(frontLeftCorner);
		s.vertex(frontRightCorner);
	    }else{ // turnaround
		s.vertex(frontLeftCorner);
		s.vertex(frontRightCorner);
		s.vertex(backRightCorner);
	    }
	}
	
	s.endShape(CLOSE);
        return s;
    }
}
