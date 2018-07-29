function T = SetMegaTemperatureMatrix(T_new,time,time_index,x_intervals,y_intervals)

T = zeros(time,x_intervals,y_intervals);

for x_index = 1:1:x_intervals
    for y_index = 1:1:y_intervals

        T(time_index,x_index,y_index) = T_new(x_index,y_index);
    
    end
end

end