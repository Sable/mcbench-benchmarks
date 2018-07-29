%                               431-400 Year Long Project 
%                               LA1 - Medical Image Processing 2003
% Supervisor     :  Dr Lachlan Andrew
% Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                   Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                   Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
%
% File and function name : place_values
% Version                : 2.0
% Date of completion     : 21 August 2003   
% Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
% 
% Input   :   Img         - The image whose values are to be extracted from
%             XY          - The X and Y coordinates
%                           X coordinates XY(:,1)
%                           Y coordinates XY(:,2)
%             assigned_values - The values to be assigned to at the given 
%                               coordinates.
%                               Must have the same number of rows as XY and 
%                               only 1 column.
% 
% Output  :   output_image - The resultant image after assigning the values
% 
% Description:
%       Assigned the values onto the image at the specified coordinates 
%       in the same order as specified. If the coordinates is in decimal, 
%       then it is rounded to the nearest pixel integer value
%
% Usage >> output_image = place_values(XY,assigned_values,Img)
%
% See Also : get_values.m

function output_image = place_values(XY,assigned_values,Img)
[row1,column1] = size(XY);
[row2,column2] = size(assigned_values);
if (column1 ~= 2) | isempty(Img) | (column2 ~= 1) | (row1 ~= row2)
    error('Error in inputs');
end

[IY,IX] = size(Img);
% Initialize the output image
output_image = Img;
%rounds the coordinates to the nearest pixel integer value
XY = round(XY);

% Find all positions that are within the image
pos = find((1 <= XY(:,1)) & (XY(:,1) <= IX) & ...
           (1 <= XY(:,2)) & (XY(:,2) <= IY) );
XY = XY(pos,:);
[r,c] = size(assigned_values);
assigned_values = assigned_values(pos);
[r2,c2] = size(assigned_values);
if [r,c] ~= [r2,c2]
    warning('Some values not inserted');
end
% Extract the data from the image at these points
if ~isempty(pos)   
    % Coordinate conversion
    position = ((XY(:,1)-1) .* IY) + XY(:,2);
    % Get the data
	output_image(position) = assigned_values;
end