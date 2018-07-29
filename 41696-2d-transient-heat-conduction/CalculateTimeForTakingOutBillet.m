function boolean = CalculateTimeForTakingOutBillet(T_new,reference_Temperature,x_intervals,y_intervals)
boolean = 0;
count = 0;

for x_index = 2:1:(x_intervals-1)
    for y_index = 2:1:(y_intervals-1)
        if(abs(T_new(x_index,y_index))-reference_Temperature < 01 ) 
        count = 1;
        end
    end
    if(count >= ((x_intervals*y_intervals)/2))
        boolean = 1;
        break;
    end
end

end