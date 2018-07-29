function visibility = line_of_sight(observer_state, current_target_node, external_boundaries)
%Functions determines whether the current target node is visible from the
%current observer position

%Dissect observer state into coordinates
x_observer = observer_state(1);
y_observer = observer_state(2);

%Dissect current target node ccordinates
x_current_target = current_target_node(1);
y_current_target = current_target_node(2);

%Create empty distance array and initialize counter
distance_array = zeros(1,size(external_boundaries,1));
i = 0;

for k = 1:1:size(external_boundaries,1)
    
    if k < size(external_boundaries,1)
        
        %Assign two adjacent points as wall ends (x_1;y_1) and (x_2;y_2)
        
        point_1 = [external_boundaries(k,1);external_boundaries(k,2)];
        x_1 = point_1(1);
        y_1 = point_1(2);
        
        point_2 = [external_boundaries(k+1,1);external_boundaries(k+1,2)];
        x_2 = point_2(1);
        y_2 = point_2(2);
        
    elseif k == size(external_boundaries,1)
        
        %Assign the last point as (x_1;y_1) and the first point in the list as (x_2;y_2)
        
        point_1 = [external_boundaries(k,1);external_boundaries(k,2)];
        x_1 = point_1(1);
        y_1 = point_1(2);
        
        point_2 = [external_boundaries(1,1);external_boundaries(1,2)];
        x_2 = point_2(1);
        y_2 = point_2(2);
        
    end
    
    %Calculate beam and wall direction vectors
    beam_direction_vector = [(x_current_target - x_observer) ; (y_current_target - y_observer)];
    wall_direction_vector = [(x_2-x_1); (y_2-y_1)];
    
    %Check for cosine of angle between the lines
    intersection_check = (dot(beam_direction_vector,wall_direction_vector))/( norm(beam_direction_vector)*norm(wall_direction_vector));
    
    if intersection_check ~= 1 && intersection_check ~= -1 %Make sure that the lines are not parallel (and therefore will intersect)
        
        %Find p (distance to wall expressed as a multiplier to the direct distance between the observer and curent target node)
        p_calculation_numerator = (x_2 - x_1)*(y_1 - y_observer) - (y_2 - y_1)*(x_1 - x_observer);
        p_calculation_denominator = (x_2 - x_1)*(y_current_target - y_observer) - (y_2 - y_1)*(x_current_target - x_observer);
        p = p_calculation_numerator/p_calculation_denominator;
        
        %Check if particle is actually facing wall (true if p >= 0)
        if p >= 0
            
            if (y_2 - y_1) == 0 %Check if wall is horizontal
                
                %find q (intersection position along wall vector)
                q = ( x_observer - x_1 + p*(x_current_target - x_observer) )/(x_2 - x_1);
                
            elseif (x_2 - x_1) == 0 %Check if wall is vertical
                
                %find q
                q = ( y_observer - y_1 + p*(y_current_target - y_observer ) )/(y_2 - y_1);
                
            else %If wall is neither vertical nor horizontal
                
                %find q
                q = ( y_observer - y_1 + p*(y_current_target - y_observer ) )/(y_2 - y_1); %Can use any of the two previous equations for calculating q
                
            end
            
            %Check if intersection happened within the wall ends
            if q >= 0 && q <= 1
                
                %Store the p-value
                i = i + 1;
                distance_array(i) = p;
                
            end
            
        end
        
    end
    
end

%Get the minimum value only from the first i entries; the other entries may be zero
%or residual from previous iterations
p_min = min(distance_array(1:i));

if p_min == 0 %If observer coordinates coincide with a wall
    
    nonzero_entry_index = (distance_array(1:i) ~= 0); %Only consider nonzero entries i.e. walls that are not coincident with the observer
    p_min = min(distance_array(nonzero_entry_index)); %Overwrite p_min to a nonzero value
    
end

if p_min < 1 %If wall encountered between observer and current target node
    
    visibility = 0; %Robot does not have a direct line of sight to the current target node
    
else
    
    %Establish whether the path from the current to the target node passes beyond the boundaries
    
    %Calculate the midpoint between the current and target nodes
    x_midpoint = 0.5*(x_observer + x_current_target);
    y_midpoint = 0.5*(y_observer + y_current_target);
    
    %Determine if the midpoint is within the boundaries
    [IN ON] = inpolygon(x_midpoint,y_midpoint,external_boundaries(:,1),external_boundaries(:,2));
    
    %If the path between the current and target nodes lie within the boundaries
    if IN == 1 || ON == 1
        
        visibility = 1; %Robot has a direct line of sight to the target node
        
    else
        
        visibility = 0; %Robot does not have a direct line of sight to the current target node
        
    end
    
end











