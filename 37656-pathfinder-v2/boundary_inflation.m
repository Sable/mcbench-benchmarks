function inflated_boundaries = boundary_inflation(external_boundaries, footprint)
%Function outputs vertices representing a more conservative (inflated) version of the original walls/boundaries
%based on the footprint (required clearance) of the robot

%Initialize empty arrays
midpoint_x = zeros(1, size(external_boundaries,1));
midpoint_y = zeros(1, size(external_boundaries,1));
shifted_midpoint_x_a = zeros(1, size(external_boundaries,1));
shifted_midpoint_y_a = zeros(1, size(external_boundaries,1));
shifted_midpoint_x_b = zeros(1, size(external_boundaries,1));
shifted_midpoint_y_b = zeros(1, size(external_boundaries,1));
inside_point_x = zeros(1, size(external_boundaries,1));
inside_point_y = zeros(1, size(external_boundaries,1));
orientation = zeros(1, size(external_boundaries,1));
inflated_boundaries = zeros(size(external_boundaries,1), 2);

%Extract adjacent vertices
for current_wall_index = 1:1:size(external_boundaries,1)
    
    if current_wall_index < size(external_boundaries,1)
        
        %Assign two adjacent points as wall ends (x_1;y_1) and (x_2;y_2)
        
        point_1 = [external_boundaries(current_wall_index,1);external_boundaries(current_wall_index,2)];
        x_1 = point_1(1);
        y_1 = point_1(2);
        
        point_2 = [external_boundaries(current_wall_index+1,1);external_boundaries(current_wall_index+1,2)];
        x_2 = point_2(1);
        y_2 = point_2(2);
        
    elseif current_wall_index == size(external_boundaries,1)
        
        %Assign the last point as (x_1;y_1) and the first point in the list as (x_2;y_2)
        
        point_1 = [external_boundaries(current_wall_index,1);external_boundaries(current_wall_index,2)];
        x_1 = point_1(1);
        y_1 = point_1(2);
        
        point_2 = [external_boundaries(1,1);external_boundaries(1,2)];
        x_2 = point_2(1);
        y_2 = point_2(2);
        
    end
    
    %Calculate midpoint of current wall
    midpoint_x(current_wall_index) = (x_1 + x_2)/2;
    midpoint_y(current_wall_index) = (y_1 + y_2)/2;
    
    %Calculate orientation of current wall
    orientation(current_wall_index) = atan( (y_2 - y_1)/(x_2 - x_1) );
    
    %Copy midpoint and shift by amount equal to footprint, perpendicular to
    %wall in both directions
    shifted_midpoint_x_a(current_wall_index) = midpoint_x(current_wall_index) + footprint*cos(orientation(current_wall_index) + pi/2);
    shifted_midpoint_y_a(current_wall_index) = midpoint_y(current_wall_index) + footprint*sin(orientation(current_wall_index) + pi/2);
    shifted_midpoint_x_b(current_wall_index) = midpoint_x(current_wall_index) + footprint*cos(orientation(current_wall_index) - pi/2);
    shifted_midpoint_y_b(current_wall_index) = midpoint_y(current_wall_index) + footprint*sin(orientation(current_wall_index) - pi/2);
    
    %Check if shifted midpoints are outside or right on top of walls
    %IN = 1 means particles are inside the walls, IN = 0 means particles are outside the walls
    %ON = 1 means particles are right on the walls, ON = 0 means particles are NOT right on the walls
    [IN_a ON_a] = inpolygon(shifted_midpoint_x_a(current_wall_index), shifted_midpoint_y_a(current_wall_index), external_boundaries(:,1),external_boundaries(:,2));
    [IN_b ON_b] = inpolygon(shifted_midpoint_x_b(current_wall_index), shifted_midpoint_y_b(current_wall_index), external_boundaries(:,1),external_boundaries(:,2));
    
    
    
    if IN_a == 1 && ON_a == 0 && IN_b == 1 && ON_b == 0 %If both shifted midpoints are inside walls
        
        %Check for shifted midpoints that has "jumped over a wall" based on
        %availability of direct line of sight between the shifted and
        %original midpoint
        
        %Discard the shifted midpoint of which the line of sight from the
        %original midpoint is obscured by a wall
                
        %Assign observer (original midpoint) and target node (shifted midpoint) coordinates
        observer_state = [midpoint_x(current_wall_index); midpoint_y(current_wall_index)];
        current_target_node_a = [shifted_midpoint_x_a(current_wall_index);shifted_midpoint_y_a(current_wall_index)];
        current_target_node_b = [shifted_midpoint_x_b(current_wall_index);shifted_midpoint_y_b(current_wall_index)];
        
        %Check which node (shifted midpoint) is directly visible to
        %observer (original midpoint)
        visibility_a = line_of_sight(observer_state, current_target_node_a, external_boundaries);
        visibility_b = line_of_sight(observer_state, current_target_node_b, external_boundaries);
        
        %Only accept shifted midpoints with direct line of sight from original midpoint
        if visibility_a == 1
            
            inside_point_x(current_wall_index) = shifted_midpoint_x_a(current_wall_index);
            inside_point_y(current_wall_index) = shifted_midpoint_y_a(current_wall_index);
            
        elseif visibility_b == 1
            
            inside_point_x(current_wall_index) = shifted_midpoint_x_b(current_wall_index);
            inside_point_y(current_wall_index) = shifted_midpoint_y_b(current_wall_index);
            
        end
        
    elseif IN_a == 1 && ON_a == 0 % If shifted midpoint a is inside and not on top of wall
        
        inside_point_x(current_wall_index) = shifted_midpoint_x_a(current_wall_index);
        inside_point_y(current_wall_index) = shifted_midpoint_y_a(current_wall_index);
        
    elseif IN_b == 1 && ON_b == 0 % If shifted midpoint b is inside and not on top of wall
        
        inside_point_x(current_wall_index) = shifted_midpoint_x_b(current_wall_index);
        inside_point_y(current_wall_index) = shifted_midpoint_y_b(current_wall_index);
        
    end
    
end


%Calculate a new set of vertices that represent the inflated boundaries
for current_wall_index = 1:1:size(external_boundaries,1)
    
    if current_wall_index < size(external_boundaries,1)
        
        %Assign two subsequent shifted midpoints as references to calculate
        %new wall vertices
        x_a = inside_point_x(current_wall_index);
        y_a = inside_point_y(current_wall_index);
        theta_a = orientation(current_wall_index);
        
        x_b = inside_point_x(current_wall_index + 1);
        y_b = inside_point_y(current_wall_index + 1);
        theta_b = orientation(current_wall_index + 1);
        
    elseif current_wall_index == size(external_boundaries,1)
        
        %Assign the last point as (x_a;y_a) and the first point in the list as (x_b;y_b)
        x_a = inside_point_x(current_wall_index);
        y_a = inside_point_y(current_wall_index);
        theta_a = orientation(current_wall_index);
        
        x_b = inside_point_x(1);
        y_b = inside_point_y(1);
        theta_b = orientation(1);
        
    end
    
    %Refer to "Shifted vertices calculation with explanation.docx"
    
    r_b_numerator = y_b - y_a - (x_b - x_a)*tan(theta_a);
    r_b_denominator = cos(theta_b)*tan(theta_a) - sin(theta_b);
    
    inflated_boundaries(current_wall_index,1) = x_b + r_b_numerator/r_b_denominator*cos(theta_b);
    inflated_boundaries(current_wall_index,2) = y_b + r_b_numerator/r_b_denominator*sin(theta_b);
    
end