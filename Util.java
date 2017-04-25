class Util{

    public static PMatrix2D matrixPower(PMatrix2D m, int n){
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
}
