%                               431-400 Year Long Project 
%                           LA1 - Medical Image Processing 2003
%  Supervisor     :  Dr Lachlan Andrew
%  Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                    Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                    Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
%
%  File and function name : plot_circle.m
%  Version                : 4.0
%  Date of completion     : 20 August 2003   
%  Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
% 
% Inputs :
%     X               -   The X coordinates of the center of this circle
%     Y               -   The Y coordinates of the center of this circle
%     Radius          -   The radius of this circle >= 0
%     intervals (optional) - The number of evenly spaced points along the X axis 
%                            inclusive of the start and end coordinates
%                           (needed by 'interval' algorithm)
%     algorithm (optional) - Allows the choice of the following algorithms
% 							= 'angle' (default)
%                                 Calculates the node points by its angle
% 							= 'interval'
%                                  Takes the number of intervals and spaces the 
%                                  X coordinates out according to the integer 
%                                  value of intervals 
% 							= 'bresenham'
%                                  Uses the "Bresenham's incremental circle algorithm" 
%                                  on Page 84-85, Chapter 2, "Procedural Elements for 
%                                  Computer Graphics, Second Edition" by David F. Rogers,
%                                  UniM Engin 006.6 ROGE,
%                                  Produces a digital integer approximation of a circle 
%                                  that is suitable for plotting a circle in a matrix
% 							= 'bresenhamSolid'
%                                  Uses the "Bresenham's incremental circle algorithm" 
%                                  that have been modified to produce a solid circle instead
%                                  instead of the circumference
%
% Outputs :
%     output_coord    -   Results in a [M x 2] matrix :
%                         The coordinates desired: 
%                                      X coordinates are output_coord(:,1) and 
%                                      Y coordinates are output_coord(:,2)
%                         and the first and last coordinates are the same to 
%                         ensure that a complete closed circle is formed
% 
% Description :
%     To calculate the coordinates needed to draw a circle given the details of the
% circle, for use by the 'plot' function
% 
% Usage >> output_coord = plot_circle(X,Y,Radius);    or
%          output_coord = plot_circle(X,Y,Radius,intervals,algorithm);
%          plot(output_coord(:,1),output_coord(:,2),'r*-');
% 
%       >> output_coord = plot_circle(X,Y,Radius,'bresenham');
%          output_image = zeros(500);
%          [M,N] = size(output_coord);
%          for q = 1:1:M
%              output_image(output_coord(q,1),output_coord(q,2)) = 1;
%          end
%          imshow(output_image);

function output_coord = plot_circle(X,Y,Radius,varargin)
outputX = [];
outputY = [];
temp_mod = 1;
cal_mode = 'angle'; %default
intervals = NaN;

% =============================================================
% Check optional inputs
% =============================================================
if (length(varargin) > 0)
    for a = 1:1:length(varargin)
        if isstr(varargin{a}) == 1
            if ((strcmp(varargin{a},'angle') == 1)|...
                (strcmp(varargin{a},'interval') == 1)|...
                (strcmp(varargin{a},'bresenham') == 1)|...
                (strcmp(varargin{a},'bresenhamSolid') == 1)...
               )
                cal_mode = varargin{a};
            end
        elseif isfinite(varargin{a}) == 1
            intervals = varargin{a};    
        else
            error('Invalid arguments');
        end
    end
end

% =============================================================
% Initialization of 'interval'
% =============================================================
if strcmp(cal_mode,'interval') == 1
	% Satisfies requirement for calculation by the given intervals
    if isnan(intervals) == 1
        error('No interval given');
    end
	temp_mod = mod(intervals,2);
	interval = (intervals - temp_mod) / 2;
	interval_size = (Radius+Radius)/intervals;
	valueX = 0;
	if temp_mod == 1
		outputX = [0];
        outputY = [Radius];
    else
        valueX = (-1/2)*interval_size;
	end       
    cal_mode = 'interval';
end

% =============================================================
% Calculate the 1st quardrant 
% =============================================================
	% ************************************************************
	% 	by the angle, scaled by the given radius
	% ************************************************************
if strcmp(cal_mode,'angle') == 1
	increment_angle = pi*(1/Radius);
	curr_angle = pi/2;
	loop=0;
	while curr_angle>0   
	loop=loop+1;
        outputX = [outputX(:);sqrt(Radius^2-(Radius*sin(curr_angle))^2)];
        outputY = [outputY(:);sqrt(Radius^2-(Radius*cos(curr_angle))^2)];
        curr_angle = curr_angle-increment_angle;
	end
	outputX = [outputX(:);Radius];
	outputY = [outputY(:);0];
elseif strcmp(cal_mode,'interval') == 1
	% ************************************************************
	% 	by the given x-interval
	% ************************************************************
	valueX = valueX + interval_size;
	while valueX < Radius 
        outputX = [outputX(:);valueX];
        outputY = [outputY(:);sqrt((Radius*Radius)-(valueX*valueX))];
        valueX = valueX + interval_size;
	end
    outputX = [outputX(:);Radius];
    outputY = [outputY(:);0];
elseif (strcmp(cal_mode,'bresenham') == 1) | (strcmp(cal_mode,'bresenhamSolid') == 1)
    X = round(X);
    Y = round(Y);
    Radius = round(Radius);
	% ************************************************************
    % Taken from Chapter 2, Page 84-85, David F. Rogers, 
    % "Procedural Elements for Computer Graphics,Second Edition"
	% ************************************************************
    x_i = 0;
    y_i = Radius;
    theta_i=2*(1-Radius);
    Limit = 0;
    while y_i >= Limit
        % Set Pixel
        if (strcmp(cal_mode,'bresenham') == 1) 
            % Plot the circumference
            outputX = [outputX(:);x_i];
            outputY = [outputY(:);y_i];
        elseif (strcmp(cal_mode,'bresenhamSolid') == 1)
            % Create a solid circle
            tempY = [0:1:y_i]';
            tempX = tempY;
            tempX(:) = x_i;
            outputX = [outputX(:);tempX];
            outputY = [outputY(:);tempY];
        else
            error('Invalid option');
        end
        % determine if case 1 or 2, 4 or 5, or 3
        if theta_i < 0
            delta = 2*(theta_i + y_i) - 1;
            % determine whether case 1 or 2
            if delta <= 0
                % move horizontally
                x_i = x_i + 1;
                theta_i = theta_i + (2*x_i) + 1;
            else
                % move diagonally
                x_i = x_i + 1;
                y_i = y_i - 1;
                theta_i = theta_i + (2*(x_i - y_i)) + 2;
            end
        elseif theta_i > 0
            delta_prime = 2*(theta_i - x_i) -1;
            % determine whether case 4 or 5
            if delta_prime <= 0
                % move diagonally
                x_i = x_i + 1;
                y_i = y_i - 1;
                theta_i = theta_i + (2*(x_i - y_i)) + 2;
            else
                % move vertically
                y_i = y_i - 1;
                theta_i = theta_i - (2*y_i) + 1;
            end
        elseif theta_i == 0
                % move diagonally
                x_i = x_i + 1;
                y_i = y_i - 1;
                theta_i = theta_i + (2*(x_i - y_i)) + 2;          
        end
    end
end
% =============================================================
% Calculate the 2nd quardrant
% =============================================================
length_outputX = length(outputX);
if temp_mod == 1
	% Avoids duplicate coordinates
	outputX = [outputX([length_outputX:-1:2])*(-1);outputX(:)];
	outputY = [outputY([length_outputX:-1:2]);outputY(:)];
else
    outputX = [outputX([length_outputX:-1:1])*(-1);outputX(:)];
	outputY = [outputY([length_outputX:-1:1]);outputY(:)];
end

% =============================================================
% Calculate the 3rd and 4th quardrant and to close the loop
% =============================================================
length_outputY = length(outputY)-1;
outputX = [outputX(:);outputX([length_outputY:-1:1])];
outputY = [outputY(:);outputY([length_outputY:-1:1])*(-1)];
% =============================================================
% Shift the circle to the desired center
% =============================================================
outputX = outputX+X;
outputY = outputY+Y;
output_coord = [outputX,outputY];

% If a solid is asked for make sure there are no duplicates
if (strcmp(cal_mode,'bresenhamSolid') == 1)
    output_coord = unique(output_coord,'rows');
end