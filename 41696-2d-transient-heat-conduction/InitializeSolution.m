function T_old = InitializeSolution(T_old,initial_Temperature,left_Temperature,upper_Temperature,right_Temperature,bottom_Temperature,x_intervals,y_intervals)

% For temperatures at points in the domain which are not at the boundary
for x_index = 2:1:x_intervals-1
    for y_index = 2:1:y_intervals-1

        T_old(x_index,y_index) = initial_Temperature;
    
    end
end

% For temperatures at the boundaries // Application of BC's

T_old = ApplyBC(T_old,x_intervals,y_intervals,left_Temperature,upper_Temperature,right_Temperature,bottom_Temperature);

end