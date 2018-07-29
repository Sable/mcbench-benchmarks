function new_Temperature = CalculatedBathAdjustedBoundaryTemperature(T_new,T_old,x_intervals,y_intervals,d_t,rho,Cp,bathTemperature_old)

new_Temperature = 0;
dt = 0;

for x_index = 1:1:x_intervals
    for y_index = 1:1:y_intervals
        dt = dt + abs(T_old(x_index,y_index) - T_new(x_index,y_index));       
    end
end

averageDt = dt/(x_intervals+y_intervals);
averageHeatReleased = rho*Cp*averageDt*d_t;

% Assuming a fluid batch volume of 1 m3
rhoBath = 1000; % water
CpBath = 4190; % water
heatAbsorbedByTheBath = averageHeatReleased;
new_Temperature = heatAbsorbedByTheBath/(rhoBath*CpBath)  + bathTemperature_old;

end