%                               431-400 Year Long Project 
%                           LA1 - Medical Image Processing 2003
%  Supervisor     :  Dr Lachlan Andrew
%  Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                    Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                    Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
%
%  File and function name : sort_coord.m
%  Version                : 3.0
%  Date of completion     : 18 December 2003   
%  Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
% 
% Inputs :
%           coord   -   Input coordinates of the island, [X,Y]
%           direction - Direction of sorting, 'clockwise' or 'anti-clockwise'
%           'discontinuous' or 'continuous' (optional) 
%                    - force the program to ignore discontinuouties in the borders 
%                      if set to discontinuous.
%                      (Default - 'continuous')
%           'progress track' or 'no progress track' (optional)
%                    - Displays a statement of progress
%                      (Default - 'no progress track')
%           connectivity (optional) - 4 or 8 connectivity (Default - 8 connectivity)
%
% Outputs :
%           output_coord - Ouput coordinates sorted in the desired direction in [X,Y]
%
% Description :
%   Sorts the border of an island in the clockwise or anti-clockwise direction
% 
% Usage >> output_coord = sort_coord_pixel(coord,direction)
% 
% Example >> [X,Y] = sort_coord_pixel([InputX,InputY],'clockwise');
%	     [X,Y] = sort_coord_pixel([InputX,InputY],'clockwise',4);
%            [X,Y] = sort_coord_pixel([InputX,InputY],'anti-clockwise'); 
%            [X,Y] = sort_coord_pixel([InputX,InputY],'clockwise','continuous');
%            [X,Y] = sort_coord_pixel([InputX,InputY],'anti-clockwise','discontinuous');
%            [X,Y] = sort_coord_pixel([InputX,InputY],'clockwise','progress track');
%            [X,Y] = sort_coord_pixel([InputX,InputY],'anti-clockwise','no progress track');

function output_coord = sort_coord_pixel(coord,direction,varargin)
% Default settings
connectivity = 8;
option = 'continuous';
option2 = 'no progress track';
start_coord = [];

% Test input options
if length(varargin) > 0
    for n = 1:1:length(varargin)
        if isnumeric(varargin{n})
            [r,c] = size(varargin{n});
            if (c == 2)
                start_coord = varargin{n};
            elseif (varargin{n} == 4) | (varargin{n} == 8)
                connectivity = varargin{n};
            else
                error('Error in connectivity selection');
            end
        elseif strcmp(varargin{n},'continuous') | strcmp(varargin{n},'discontinuous')
            option = varargin{n};
        elseif strcmp(varargin{n},'progress track') | strcmp(varargin{n},'no progress track')
            option2 = varargin{n};        
        end
    end
end

% Determine direction of sorting
if connectivity == 8
	if strcmp(direction,'clockwise')
		% clockwise rotation
		rotation_sequence = [-1  0;...
                    	 	  0 -1;...
                    	 	  1  0;...
                    	 	  0  1;...
                             -1 -1;...
                    	 	  1 -1;...
                    	 	  1  1;...
                    	 	 -1  1];    % [Xcoord,Ycoord]
		% anti-clockwise rotation
	elseif strcmp(direction,'anti-clockwise')
		rotation_sequence = [ 1  0;...
                    	 	  0 -1;...
                    	 	 -1  0;...
                    	 	  0  1;...
                    	 	  1 -1;...
                    	 	 -1 -1;...
                    	 	 -1  1;...
                              1  1];    % [Xcoord,Ycoord]
	else
        error('Invalid direction');                  
	end
elseif connectivity == 4
	if strcmp(direction,'clockwise')
		% clockwise rotation
		rotation_sequence = [ -1  0;...
                     	 	   0 -1;...
                               1  0;...
                       	 	   0  1];    % [Xcoord,Ycoord]
		% anti-clockwise rotation
	elseif strcmp(direction,'anti-clockwise')
		rotation_sequence = [ 1  0;...
                    	 	  0 -1;...
                    	 	 -1  0;...
                    	 	  0  1];    % [Xcoord,Ycoord]
	else
        error('Invalid direction');                  
	end
else
    error('Invalid connectivity selection')
end
% Ensure that all coordinate entries only appear once
coord = unique(coord,'rows');              

[row,column] = size(coord);
output_coord = zeros(row,column);

if isempty(start_coord)
	% Find the coordinate that is top-right portion of the image for anti-clockwise
	% and the coordinate that is bottom-left portion of the image for clockwise
	if strcmp(direction,'clockwise')
		maxY = min(coord(:,2));
		pos  = find(coord(:,2) == maxY);
		pos  = find((coord(:,1) == min(coord(pos,1))) & (coord(:,2) == maxY));    
	elseif strcmp(direction,'anti-clockwise')
		minY = min(coord(:,2));
		pos  = find(coord(:,2) == minY);
		pos  = find((coord(:,1) == max(coord(pos,1))) & (coord(:,2) == minY));
	end
	output_coord(1,:) = coord(pos,:);
	coord(pos,:) = [];
else
    %If user gives the starting coordinates, make use of it
    pos = find((coord(:,1) == start_coord(1)) & (coord(:,2) == start_coord(2)));
    output_coord = start_coord;
    if ~isempty(pos)
        coord(pos,:) = [];    
    end
end


% Sorting algorithm
n=0;
while ~isempty(coord)
    n=n+1;
    if strcmp(option2,'progress track')
        disp(strcat('sort_coord_pixel :-',num2str(n),'-of-',num2str(row-1),...
                    '     coordinates left :-',num2str(length(coord(:,1)))));
    end    
    % Initially assume that there is no matching coordinate entry
	for current_seq = 1:1:length(rotation_sequence(:,1))
        % Calculate the next coordinates given this particular rotation
        next_coord = output_coord(n,:) + rotation_sequence(current_seq,:);
        % Check to see if any of the remainding coordinates matches this next coord
        indicator = find((coord(:,1)==next_coord(1)) & (coord(:,2)==next_coord(2)));
        
        if isempty(indicator)
            place_num = -1;
        else
            if length(indicator) > 1
                error('To many selections');
            end
            % If there is an entry, record the coordinate, delete from the
            % list of remainding coordinates and exit from this "for" loop
            output_coord(n+1,:) = next_coord;
            coord(indicator,:) = [];
            place_num = 1;
            break;
        end
	end
    if place_num < 0
        % If there was no matching coordinate entry from the previous 
        % "for" loop then the loop is not closed
        if strcmp(option,'continuous');
            error('coordinates not continously connected');
        end
        output_coord(n+1,:) = next_coord(1,:);
    end
end

