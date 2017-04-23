import java.util.*;

class UnionFinder{
    
    private ArrayList<Integer> parent;
    
    private int getRoot(int a){
        int directParent = parent.get(a);
        if(directParent != a){
            parent.set(a, getRoot(directParent));
        } 
        return parent.get(a);
    }
    
    public UnionFinder(int size){
        parent = new ArrayList<Integer>();
        
        for(int i = 0; i < size; i++){
            parent.add(i);
        }
    }
    
    
    public void unite(int a, int b){
        int rootA = getRoot(a);
        int rootB = getRoot(b);
        
        parent.set(rootA, rootB);
    }
    
    public boolean isUnited(int a, int b){
        int rootA = getRoot(a);
        int rootB = getRoot(b);
        
        return rootA == rootB;
    }
    
}