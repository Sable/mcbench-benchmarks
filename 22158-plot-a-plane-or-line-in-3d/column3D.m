function arrowHandle = column3D(pos, deltaValues, colorCode, stemRatio)
% COLUMN3D - plot column in three dimensions
% ( very slight modification of ARROW3D.m written by Shawn Arseneau)


% arrowHandle = arrow3D(pos, deltaValues, colorCode, stemRatio) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     Used to plot a single 3D arrow with a cylindrical stem and cone arrowhead
%     pos = [X,Y,Z] - spatial location of the starting point of the arrow (end of stem)
%     deltaValues = [QX,QY,QZ] - delta parameters denoting the magnitude of the arrow along the x,y,z-axes (relative to 'pos')
%     colorCode - Color parameters as per the 'surf' command.  For example, 'r', 'red', [1 0 0] are all examples of a red-colored arrow
%     stemRatio - The ratio of the length of the stem in proportion to the arrowhead.  For example, a call of:
%                 arrow3D([0,0,0], [100,0,0] , 'r', 0.82) will produce a red arrow of magnitude 100, with the arrowstem spanning a distance
%                 of 82 (note 0.82 ratio of length 100) while the arrowhead (cone) spans 18.  
% 
%     Example:
%       arrow3D([0,0,0], [4,3,7]);  %---- arrow with default parameters
%       axis equal;
% 
%    Author: Shawn Arseneau
%    Created: September 14, 2006
%    Updated: September 18, 2006
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin<2 || nargin>4     
        error('Incorrect number of inputs to arrow3D');     
    end
    if numel(pos)~=3 || numel(deltaValues)~=3
        error('pos and/or deltaValues is incorrect dimensions (should be three)');
    end
    if nargin<3                 
        %colorCode = 'interp';                               
        colorCode = 'flat';                               
    end
    if nargin<4                 
        %stemRatio = 0.75;                                   
        stemRatio = 1;                                   
    end    

    X = pos(1); %---- with this notation, there is no need to transpose if the user has chosen a row vs col vector
    Y = pos(2);
    Z = pos(3);
    
    [sphi, stheta, srho] = cart2sph(deltaValues(1), deltaValues(2), deltaValues(3));  
    
    %******************************************* CYLINDER == STEM *********************************************
    %cylinderRadius = 0.05*srho;
    %cylinderRadius = 0.03*srho;
    cylinderRadius = .8;
    cylinderLength = srho*stemRatio;
    [CX,CY,CZ] = cylinder(cylinderRadius);      
    CZ = CZ.*cylinderLength;    %---- lengthen
    
    %----- ROTATE CYLINDER
    [row, col] = size(CX);      %---- initial rotation to coincide with X-axis
    
    newEll = rotatePoints([0 0 -1], [CX(:), CY(:), CZ(:)]);
    CX = reshape(newEll(:,1), row, col);
    CY = reshape(newEll(:,2), row, col);
    CZ = reshape(newEll(:,3), row, col);
    
    [row, col] = size(CX);    
    newEll = rotatePoints(deltaValues, [CX(:), CY(:), CZ(:)]);
    stemX = reshape(newEll(:,1), row, col);
    stemY = reshape(newEll(:,2), row, col);
    stemZ = reshape(newEll(:,3), row, col);

    %----- TRANSLATE CYLINDER
    stemX = stemX + X;
    stemY = stemY + Y;
    stemZ = stemZ + Z;
    
    hStem = surf(stemX, stemY, stemZ, 'FaceColor', colorCode, 'EdgeColor', 'none'); 
































