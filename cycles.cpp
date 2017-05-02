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

    std::vector<point> adjacents;
    /*if(start == current && start == std::make_pair(0, 0)){
	adjacents.push_back({1, 0});
	}else{*/
	adjacents = adjacent_points(current);
	//}
    for(auto p:adjacents){
	//std::cout<<p.first << " " << p.second << std::endl;
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

int get_area(std::vector<point> & cycle){
    if(cycle.empty()){
	return 0;
    }

    point last = cycle.back();

    int area = 0;
    
    for(const auto & p:cycle){
	if(last.second == p.second){ // moving horizontally
	    area += (p.first - last.first) * p.second;
	}
	last = p;
    }

    return abs(area);
}

point get_dimensions(const std::vector<point> &cycle){
    int max_x = 0;
    int max_y = 0;

    for(auto &p:cycle){
	max_x = std::max(p.first, max_x);
	max_y = std::max(p.second, max_y);
    }

    return {max_x + 1, max_y + 1};
}

std::vector<point> flip_vertically(const std::vector<point> & cycle){
    point dimensions = get_dimensions(cycle);

    std::vector<point> out;
    for(auto &p:cycle){
	point flipped = {p.first, dimensions.second - p.second - 1};
	out.push_back(flipped);
    }

    return out;
}

std::vector<point> flip_horizontally(const std::vector<point> & cycle){
    point dimensions = get_dimensions(cycle);

    std::vector<point> out;
    for(auto &p:cycle){
	point flipped = {dimensions.first - p.first - 1, p.second};
	out.push_back(flipped);
    }

    return out;
}

std::vector<point> shift_to_start(const std::vector<point> & cycle){
    int start_index = 0;
    int n = cycle.size();
    for(int i = 0; i < n; ++i){
	if(cycle[i] == std::make_pair(0, 0)){
	    start_index = i;
	    break;
	}
    }

    std::vector<point> out = cycle;

    std::rotate(out.begin(), out.begin()+start_index, out.end());
    
    return out;
}

std::vector<point> reverse(const std::vector<point> &cycle){
    int n = cycle.size();
    if(n == 0){
	return cycle;
    }

    std::vector<point> out;
    for(int i= n-2; i >= 0; --i){
	out.push_back(cycle[i]);
    }
    out.push_back(cycle.back());

    return out;
}

std::vector<point> normalize(const std::vector<point> & cycle){
    std::vector<std::vector<point> > orientations;

    orientations.push_back(cycle);
    orientations.push_back(flip_horizontally(orientations.back()));
    orientations.push_back(flip_vertically(cycle));
    orientations.push_back(flip_horizontally(orientations.back()));

    for(int i = 0; i < 4; ++i){
	orientations.push_back(reverse(orientations[i]));
    }

    for(int i = 0; i < 8; ++i){
	orientations[i] = shift_to_start(orientations[i]);
    }

    std::sort(orientations.begin(), orientations.end());
    return orientations[0];
}

template<typename T>
std::vector<T> uniq(const std::vector<T> & in){
    if(in.empty()){
	return in;
    }

    std::vector<T> out;
    T last = in[0];
    bool past_first = false;
    for(auto & e:in){
	if( ! past_first || e != last){
	    out.push_back(e);
	    last = e;
	}
	past_first = true;
    }
    return out;
}

void normalize_set(std::vector<std::vector<point> > & cycles){
    for(int i = 0; i < cycles.size(); ++i){
	cycles[i] = normalize(cycles[i]);
    } 

    std::sort(cycles.begin(), cycles.end());

    cycles = uniq(cycles);
}

void draw_cycle(const std::vector<point> & cycle){
    
}

int main(){
    int width = 6;
    int height = 5;
    
    std::vector<std::vector<bool> > empty_visited (height, std::vector<bool> (width, false));
    auto cycles = hamilton_cycles_on_grid(width, height, {0, 0}, {0, 0}, empty_visited, 0);

    normalize_set(cycles);
    
    for(auto & cycle:norm_cycles){
	for(auto p:cycle){
	    std::cout<<"(" << p.first << ", " << p.second << ") | ";
	}
	std::cout<<"  area = " << get_area(cycle);
	std::cout<<"\n";
    }
}
