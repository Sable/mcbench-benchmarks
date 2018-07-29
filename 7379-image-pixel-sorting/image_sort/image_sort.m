function [data_ordered]= image_sort(x,y)
% IMAGE_SORT Sorts the given data points (pixels of an image) 
%            in the data_ordered array   
%
%    Usage: [data_ordered]= image_sort(x,y)
%
%    Warning: 
%    It is assumed that the nearest pixel is not farther 
%    than sqrt(2^15)=180 pixels 
%
%    Written and tested in Matlab R14SP1
%    Date: 01.01.2005 
%
%    Author: Atakan Varol
%    email: atakanvarol@su.sabanciuniv.edu
%    homepage: http://students.sabanciuniv.edu/~atakanvarol/

x  = int16(x);          % Convert double type integers in int16
y  = int16(y);          % Convert double type integers in int16
len_data = length(x);   % Length of the data
data_ordered = zeros(len_data,2,'int16');   % output vector for the sorted data
inf_int16 = intmax('int16');         % inf for int16 data type 
temp = ones(1,len_data,'int16');     % empty matrix to increase speed
d = zeros(len_data,'int16');         % create an empty matrix
a=1;

% Create the distances matrix
xd =  x(:,temp);  xd = xd - xd';  % calculate the x distances
yd =  y(:,temp);  yd = yd - yd';  % calculate the y distances
ix = 1:len_data + 1:len_data*len_data;   % select the diagonal indices
d(ix) = inf_int16;                       % set zero values to infinity
d = d + xd.*xd + yd.*yd;                 % calculate the magnitude of the distances

% Select the closest points
for index = 1:len_data                     % for all the points
    [C,I] = min(d(:,a));                   % find the nearest point
    data_ordered(index,:) = [x(I), y(I)];  % store the nearest point
    d(a,:) = inf_int16;                    % remove the selected point from the list by setting its values to infinity
    a = I;                                 % new point is the closest point
end