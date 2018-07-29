function boolean = ExitConditionEvaluation(T_new,T_reference,x_intervals,y_intervals)

boolean = 0;
Tempcount = 0;

for x_index = 2:1:x_intervals-1
    for y_index = 2:1:y_intervals-1
         Tempcount = Tempcount + T_new(x_index,y_index);
    end
end

if(round(Tempcount/((x_intervals-1)*(y_intervals-1))) <= T_reference)
boolean = 1;
end

end