function [ value] = interploateFieldStrengthForDistance( fieldStrengths, distance, antennaHeightIndex)
%interploateFieldStrengthForDistance Step 4:  Determine the lower and higher nominal distances from Table 1
% closest to the required distance. If the required distance coincides with
% a value in Table 1, this should be regarded as the lower nominal distance
% and the interpolation process of Step 8.1.5 is not required.   
if fieldStrengths(1,1) > distance
    disp('error')
    error
end

for i = 1:length(fieldStrengths)
    if fieldStrengths(i,1) >= distance
        upper_distance_index  = i;
        break
    end
end
    
lower_distance_index = upper_distance_index - 1;

if (fieldStrengths(upper_distance_index,1) == distance) 
    value = fieldStrengths(upper_distance_index,antennaHeightIndex+1);
elseif (fieldStrengths(lower_distance_index ,1) == distance) 
    value = fieldStrengths(lower_distance_index ,antennaHeightIndex+1);
else
    e_lower = fieldStrengths(lower_distance_index,antennaHeightIndex+1);
    e_upper = fieldStrengths(upper_distance_index,antennaHeightIndex+1);
    
    d_lower = fieldStrengths(lower_distance_index,1);
    d_upper = fieldStrengths(upper_distance_index,1);

    value = e_lower + (e_upper - e_lower) * (log10((distance / d_lower)) / log10((d_upper / d_lower))); 
end

end

