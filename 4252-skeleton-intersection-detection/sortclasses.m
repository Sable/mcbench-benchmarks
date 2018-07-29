%                                431-400 Year Long Project 
%                           LA1 - Medical Image Processing 2003
%  Supervisor     :  Dr Lachlan Andrew
%  Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                    Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                    Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
% 
%  File and function name : sortclasses3
%  Version                : 3.2
%  Date of completion     : 1 October 2003   
%  Written by    :   Siew Teng Lee    102519  s.lee1@ugrad.unimelb.edu.au
%
%  Inputs        :   given_inputs - The known input coordinates. [X,Y]
%                    separation_distance - Separation distance of the neighbouring pixels 
%                                          from the current coordinate
%                    connectivity - The connectivity of 4 or 8 from the current coordinate is 
%                                   possible. Connectivity of 8 covers all pixels surrounding the
%                                   current coordinate. These pixels are considered as neighbours
%                                   and same class if they are within the distance specified by
%                                   separation_distance. Connectivity of 4 covers all horizontal
%                                   and vertical pixels from the current coordinate. These 4 pixels
%                                   are considered neighbours is they are within the separation 
%                                   distance.
%
%  Outputs       :   Results in a set of Mx2 matrices. The number of these matrices
%                    depends on number of different classes the inputs are sorted into.                   
%
%                    
%  Description   :
%       To sort the coordinates into the same class if they are neighbouring pixels. A surrounding pixel 
%       from a current coordinate is considered a neighbour if it satisfies the separation distance 
%       and connectivity variables. The inputs are initially scaled to a certain factor before
%       being sorted. The output gives the sorted classes with its values scaled back to its
%       original value.


function output = sortclasses(given_inputs, separation_distance, connectivity)


output = {};
pixel_class = [];

% Initialize the class with the first input coordinate. If the given input is null, warn the user.
scaling_factor = 1;
if ~isempty(given_inputs)
    if separation_distance < 1
        scaling_factor = 1/separation_distance;          % Inputs are scaled up for easier
        given_inputs = scaling_factor.*given_inputs;     % implementation of the program and to work 
        separation_distance = 1;                         % around a bug previously found in sortclasses2.m
    end;
    pixel_class = given_inputs(1,:);
    % Remove the first coordinate 
    given_inputs(1,:) = [];
else
    error('Warning: There are no inputs to sort')
end
    
[Nrow,Ncolumn] = size(pixel_class);

while ~isempty(given_inputs)
    n=1;
    
    while n <= Nrow
        X = pixel_class(n,1);
        Y = pixel_class(n,2);

        % Separation distance of the neighbouring pixels from the current coordinate can be specified here
        pos_in_given_inputs = [];
        for m = separation_distance
                
            if connectivity == 8        % Generates 8 neighbouring pixels around current coordinate
                coord = [X-m,Y-m;...
                         X-m,Y  ;...
                         X-m,Y+m;...
                         X  ,Y+m;...
                         X  ,Y-m;...
                         X+m,Y-m;...
                         X+m,Y  ;...
                         X+m,Y+m];
            elseif connectivity == 4    % Generates 4 neighbouring pixels around current coordinate
                coord = [X-m,Y  ;...
                         X  ,Y+m;...
                         X  ,Y-m;...
                         X+m,Y  ];
            else 
                error('Wrong connectivity')
            end
         
            % Checks if the 8 coordinates around the pixel is an element of input coords. If it is, return 1 and 0 otherwise.
            Member = ismember(given_inputs, coord, 'rows');
         
            % Returns the indices of M where there is a match
            pos_in_given_inputs2 = find(Member==1);
            pos_in_given_inputs = [pos_in_given_inputs;pos_in_given_inputs2];
%             if ~isempty(pos_in_given_inputs)
%                 break
%             end
        end
        
         % The matched position coordinates
         matched_coord = given_inputs(pos_in_given_inputs,:);
         
         % If there are matched coordinates, append to the class and remove the already checked coordinate.
         if ~isempty(pos_in_given_inputs)
             pixel_class = [pixel_class; matched_coord];
             given_inputs(pos_in_given_inputs,:) = [];
         end
         
         % Update the nth row
         n = n+1;
         [Nrow,Ncolumn] = size(pixel_class);

     end
    
output = {output{:},pixel_class};

    % The inner while loop is exited when there are no more matched coordinates for the particular class. 
    % Start on a new class if there are remaining coordinates to sort.
    if ~isempty(given_inputs)
        pixel_class = given_inputs(1,:);
        given_inputs(1,:) = [];
    else
        pixel_class = [];
    end
    
end

if ~isempty(pixel_class)
    output = {output{:}, pixel_class};
end

if ~isempty(output)
    for i = 1:1:length(output)
        output{i} = output{i}/scaling_factor;
    end
end

