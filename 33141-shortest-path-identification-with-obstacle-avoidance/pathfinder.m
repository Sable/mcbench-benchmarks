function waypoint_coordinates = pathfinder(start_point, end_point, external_boundaries)

%Function finds the shortest path from a start point to an end point in a 
%2D arena whilst avoiding obstacles

%OUTPUT:
%Output is in the form of a Nx2 matrix
%Collumns 1 and 2 represent the waypoint  x and y coordinates respectively
%Each row N represents one of the waypoints
%Waypoints sorted from the start point to the end point

%INPUTS:
%Start and end points can either be collumn or row matrices with the first
%and second entries corresponding to the x and y coordinates respectively
%External boundaries is in the form of an Mx2 matrix
%Each of the M rows represent one vertex of the external wall of the arena
%The first and second collumns represent the x and y coordinates of each
%vertex
%NB: The extrnal boundaries will always be taken to form a closed polygon

%% Main body of function

%Initialize empty arrays
initial_combined_nodes = zeros(size(external_boundaries,1)+2,3);

%Create initial unvisited nodes array
initial_combined_nodes(1,1:2) = [start_point(1), start_point(2)];
initial_combined_nodes(2:size(external_boundaries,1)+1,1:2) = external_boundaries;
initial_combined_nodes(size(external_boundaries,1)+2,1:2) = [end_point(1), end_point(2)];

%Assign placeholder/tentative distances to all nodes as infinity
initial_combined_nodes(:,3) = Inf*ones(size(initial_combined_nodes,1),1);

%Identify nodes visible from starting point
visible_nodes_ID = zeros(1,size(initial_combined_nodes,1));

%% Create a library listing the visible neighbours of all of the nodes and their distances with respect to the reference nodes 

%Initialize library as an empty three dimensional array
visible_neighbours_library =  zeros(size(initial_combined_nodes,1),size(initial_combined_nodes,2),size(initial_combined_nodes,1));

%Initialize visible nodes index to zero
visible_index = 0;

for reference_node_ID = 1:size(initial_combined_nodes,1)
    
    %Copy the initial_combined_nodes into a new combined_nodes entry
    %This will form a new 'page' for each of the reference nodes
    combined_nodes = initial_combined_nodes;
    
    for target_ID = 1:size(initial_combined_nodes,1)
        
        %Assign observer and target nodes
        observer_state = initial_combined_nodes(reference_node_ID,:);
        current_target_node = initial_combined_nodes(target_ID,:);
        
        %Check visibility of target node from observer
        %visibility = line_of_sight(observer_state, current_target_node, initial_combined_nodes);
        visibility = line_of_sight(observer_state, current_target_node, external_boundaries);
        
        if visibility == 1 %If target is visible
            
            %Record the visible node ID
            visible_index = visible_index + 1;
            visible_nodes_ID(visible_index) = target_ID;
            
            %Overwrite recorded distance
            combined_nodes(target_ID,3) = sqrt((current_target_node(1) - observer_state(1))^2 + (current_target_node(2) - observer_state(2))^2);
                        
        end
        
    end
    
    %Create a three dimensional array representing a library of the visible neighbours with respect to the reference node
    %The reference node ID is represented by the 'page' number
    visible_neighbours_library(:,:,reference_node_ID) = combined_nodes;
    
end

%Initialize unvisited_nodes
unvisited_nodes = zeros(1,size(initial_combined_nodes,1));

%Generate a list of all available nodes and assign them to the unvisited nodes set
for index = 1:size(initial_combined_nodes)
    unvisited_nodes(index) = index;
end

%Copy the first 'page' of the visible_neighbours_library as the initial
%shortest path array
shortest_path_array = visible_neighbours_library(:,:,1);

%Initialize all of the precursor nodes to 1 (the starting point)
shortest_path_array(:,4) = 1;

%Take out the starting point (node 1) from the unvisited nodes set
current_node = 1;
unvisited_nodes = setdiff(unvisited_nodes, current_node);

%Repeat until the set of unvisited nodes is depleted
while size(unvisited_nodes,2) > 0
    
    %Find the node with the smallest nonzero cumulative distance to be assigned as the next current node
    cumulative_distances = shortest_path_array(unvisited_nodes,3);
    [~, current_node_ID_index] = min(cumulative_distances); %First output (~) is not used
    
    %Extract the current node
    current_node_ID = unvisited_nodes(current_node_ID_index);
    
    %Take out the current node from the set of unvisited nodes
    unvisited_nodes = setdiff(unvisited_nodes, current_node_ID);
    
    %Refer to the library to find the distance to visible (neighboring) and UNVISITED nodes
    for unvisited_node_index = 1:size(unvisited_nodes,2)
        
        %Assign one of the unvisited nodes as the target node
        target_node_ID = unvisited_nodes(unvisited_node_index);
        
        %Visibility is implied if the distance recorded between the current and target nodes (in the library) is less than infinity
        if visible_neighbours_library(target_node_ID,3,current_node_ID) < Inf
            
            %Calculate the (tentative) cumulative distance for the target node
            cumulative_distance_to_current_node = shortest_path_array(current_node_ID,3);
            distance_from_current_to_target_node = visible_neighbours_library(target_node_ID,3,current_node_ID);
            new_cumulative_distance = cumulative_distance_to_current_node + distance_from_current_to_target_node;
            
            %Find the PREVIOUS cumulative distance to the target node
            previous_cumulative_distance_to_target_node = shortest_path_array(target_node_ID,3);
            
            %If a smaller cumulative distance from the starting node to the
            %target node, passing through the current node was obtained
            if new_cumulative_distance < previous_cumulative_distance_to_target_node
                
                %Overwrite the previous cumulative distance to the smaller value
                shortest_path_array(target_node_ID,3) = new_cumulative_distance;
                
                %Replace the last precursor node with current_node_ID
                shortest_path_array(target_node_ID,4) = current_node_ID;
                
            end
            
        end
        
    end
    
end


%% Extract the shortest path

%Initialize path array
path = zeros(1,size(shortest_path_array,1));

%Assign the end point ID as the first entry on the path array
path_index = 1;
path(path_index) = size(initial_combined_nodes,1);

while path(path_index) > 1 %Repeat until the starting node is reached
    
    path_index = path_index + 1;
    path(path_index) = shortest_path_array(path(path_index-1),4);
    
end

%Reverse order of path array so that it now points from the starting point to the end point
%Only consider the first path_index entries; the remaining are only placeholder values (zeros)
path = fliplr(path(1:path_index));

%Extract the waypoints identified by the entries in the path array
waypoint_coordinates(:,1) = initial_combined_nodes(path,1);
waypoint_coordinates(:,2) = initial_combined_nodes(path,2);