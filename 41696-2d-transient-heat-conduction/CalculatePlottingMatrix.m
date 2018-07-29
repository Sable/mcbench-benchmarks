function T_plotting = CalculatePlottingMatrix(T_new,x_intervals,y_intervals)

a = 1;

for x_index = 2:1:(x_intervals-1)
    b = 1;
    for y_index = 2:1:(y_intervals-1)        
         T_plotting(a,b) = T_new(x_index,y_index);
         b = b+1;
    end
    
    a = a+1;
end

end