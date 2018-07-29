% Creates a plot with markers at extrema specified by indices
%
% data			One dimensional data vector.
% indices 		One dimensional vector of indices (integer) values, all must be 
%                           greater than 0 and less than  or equal to the number of elemenets in data
function [] = plot_data_with_features (data, indices)
    
    markers = data(indices);
   
    plot(data);
    hold on;
    scatter(indices, markers,'fill');
    hold off;
    
end