%#eml
function [new_data] = get_center_data(min,med,max,center_data)
if center_data <= min || center_data >= max
    new_data = med;
else 
    new_data = center_data;
end

