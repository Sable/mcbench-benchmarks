function [X, Y] = sortPolyFromClockwiseStartingFromTopLeft( X, Y )

% The 1st 2 high values for the y-axis are the top 2 edges
% <upper corners identified>
%top_vertices_Y = sort(Y,2);
top_vertices_Y = sortCoordinatesAccordToX(Y);

    for i=1:4
        for j=1:4
            if top_vertices_Y(i) == Y(j)
                top_vertices_X(i) = X(j);
            end
        end
    end
    
   top_vertices_X = top_vertices_X'; 
   X = top_vertices_X;
   Y = top_vertices_Y;

   % The larger of the x values for the 1st 2 high values for the y-axis
   % belongs to the top-right hand corner
   % <upper left and right corners identified>
   if X(1) > X(2)
       top_vertices_X(1) = X(2); 
       top_vertices_Y(1) = Y(2);        
       top_vertices_X(2) = X(1); 
       top_vertices_Y(2) = Y(1);         
   end
   
   X = top_vertices_X;
   Y = top_vertices_Y;

% The larger of the x values for the last 2 high values for the y-axis
% belongs to the bottom-right hand corner
   % <lower left and right corners identified>
   if X(3) < X(4)
       top_vertices_X(3) = X(4); 
       top_vertices_Y(3) = Y(4);        
       top_vertices_X(4) = X(3); 
       top_vertices_Y(4) = Y(3);         
   end
   
   X = top_vertices_X;
   Y = top_vertices_Y;
end

% Notes
% [X,Y] to be sorted as
%       top_left
%       top_right
%       bottom_right
%       bottom_left
