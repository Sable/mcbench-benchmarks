function T_old = ApplyBC(T_old,x_intervals,y_intervals,left_Temperature,upper_Temperature,right_Temperature,bottom_Temperature)

% Left BC
for x_index = 1
    for y_index = 1:1:y_intervals
        T_old(x_index,y_index) =  left_Temperature;
    end
end

% Right BC
for x_index = x_intervals
    for y_index = 1:1:y_intervals
        T_old(x_index,y_index) =  right_Temperature;
    end
end

% Bottom BC
for y_index = 1
    for x_index = 1:1:x_intervals
        T_old(x_index,y_index) =  bottom_Temperature;
    end
end


% Top BC
for y_index = y_intervals
    for x_index = 1:1:x_intervals
        T_old(x_index,y_index) =  upper_Temperature;
    end
end

end