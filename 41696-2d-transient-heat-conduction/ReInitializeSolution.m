function T_old = ReInitializeSolution(T_new,new_Temperature,x_intervals,y_intervals)

% For temperatures at points in the domain which are not at the boundary
for x_index = 2:1:x_intervals-1
    for y_index = 2:1:y_intervals-1

        T_old(x_index,y_index) = T_new(x_index,y_index);
    
    end
end

% for points at the boundary
% Left BC
for x_index = 1
    for y_index = 1:1:y_intervals
        T_old(x_index,y_index) =  new_Temperature;
    end
end

% Right BC
for x_index = x_intervals
    for y_index = 1:1:y_intervals
        T_old(x_index,y_index) =  new_Temperature;
    end
end

% Bottom BC
for y_index = 1
    for x_index = 1:1:x_intervals
        T_old(x_index,y_index) =  new_Temperature;
    end
end


% Top BC
for y_index = y_intervals
    for x_index = 1:1:x_intervals
        T_old(x_index,y_index) =  new_Temperature;
    end
end

end