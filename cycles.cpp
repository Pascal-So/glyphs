#include<bits/stdc++.h>

#define point std::pair<int, int>

std::vector<point> adjacent_points(point p){
    std::vector<point> out;
    out.push_back({p.first + 1, p.second});
    out.push_back({p.first, p.second + 1});
    out.push_back({p.first - 1, p.second});
    out.push_back({p.first, p.second - 1});
    return out;
}

std::vector<std::vector<point> > hamilton_cycles_on_grid(int width, int height,
							 point start, point current,
							 std::vector<std::vector<bool> > & visited, int nr_visited){
    std::vector<std::vector<point> > out;

    visited[current.second][current.first] = true;
    ++ nr_visited;

    auto adjacents = adjacent_points(current);
    for(auto p:adjacents){
	if(p.first < 0 || p.second < 0 || p.first >= width || p.second >= height){
	    continue;
	}
	if(p == start && nr_visited == width * height){
	    // end
	    std::vector<point> current_path = {current};
	    out.push_back(current_path);
	}
	if(!visited[p.second][p.first]){
	    // recursive call
	    auto paths = hamilton_cycles_on_grid(width, height, start, p, visited, nr_visited);
	    for(auto & path:paths){
		path.push_back(current);
	    }
	    out.insert(out.end(), paths.begin(), paths.end());
	}
    }

    visited[current.second][current.first] = false;
    -- nr_visited;

    return out;
}

int main(){
    int width = 4;
    int height = 3;
    
    std::vector<std::vector<bool> > empty_visited (height, std::vector<bool> (width, false));
    auto cycles = hamilton_cycles_on_grid(width, height, {0, 0}, {0, 0}, empty_visited, 0);

    for(auto & cycle:cycles){
	for(auto p:cycle){
	    std::cout<<"(" << p.first << ", " << p.second << ") | ";
	}
	std::cout<<"\n";
    }
}
