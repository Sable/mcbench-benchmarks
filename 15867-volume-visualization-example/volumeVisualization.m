function s = volumeVisualization(x,y,z,v)
%volumeVisualization Engine for choosing y-z planes to view.
%   s = volumeVisualization(X,Y,Z,V) returns a structure 
%   containing information about the visualization of volume
%   data described by X,Y,Z,V.  The fields are:
%          addSlicePlane -- function handle to add a slice
%                           plane at location x
%   deleteLastSlicePLane -- function handle to delete the
%                           last slice plane added
%                   xMin -- minimum x location for a plane
%                   xMax -- maximum x location for a plane
%
%      Example:
%      [x,y,z,v] = flow;
%      s = volumeVisualization(x,y,z,v);
%      s.addSlicePlane(3.7)
%      s.addSlicePlane(7.5)
%      pause
%      s.deleteLastSlicePlane()
%      pause
%      s.deleteLastSlicePlane()

%   Copyright 2007 The MathWorks, Inc.

%% Store handles to the various planes
%initialize handle to axis
%initialize handle to slice plane
hAxis = [];         
hSlicePlanes = [];  

%% Create data for generic slice through yz-plane
[yd,zd] = meshgrid(linspace(min(y(:)),max(y(:)),100), ...
    linspace(min(z(:)),max(z(:)),100));

%% Plot the volume initially
initDisplay()

%% Nested Functions
    function addSlicePlane(xLoc)
    %addSlicePlane   Add a slice plane xLoc.
        xd            = xLoc*ones(size(yd));
        newSlicePlane = slice(hAxis, x, y, z, v, xd, yd, zd);
        hSlicePlanes   = [ hSlicePlanes, newSlicePlane ];
        set(newSlicePlane,'FaceColor'      ,'interp',...
                          'EdgeColor'      ,'none'  ,...
                          'DiffuseStrength',.8       );
    end

    function deleteLastSlicePlane()
    %deleteLastSlicePlane Delete the last slice plane added.
        if ~isempty(hSlicePlanes)
            delete(hSlicePlanes(end));
            hSlicePlanes = hSlicePlanes(1:end-1);
        end
    end

    function initDisplay()
    %initDisplay  Initialize Display.

        % Draw back and bottom walls
        if isempty(hAxis) || ~ishandle(hAxis)
            hAxis = gca;
            hold on;
        end
        hx = slice(hAxis, x, y, z, v, ...
            max(x(:)),       [],       []) ;
        hy = slice(hAxis, x, y, z, v, ...
            [],       max(y(:)),       []) ;
        hz = slice(hAxis, x, y, z, v, ...
            [],              [],min(z(:))) ;

        % Make everything look nice
        set([hx hy hz],'FaceColor','interp',...
            'EdgeColor','none')
        set(hAxis,'FontSize',18,'FontWeight','Bold');
        xlabel('X');ylabel('Y');zlabel('Z')
        daspect([1,1,1])
        axis tight
        box on
        view(-38.5,16)
        colormap (jet(128))
    end

s.addSlicePlane = @addSlicePlane;
s.deleteLastSlicePlane = @deleteLastSlicePlane;
s.xMin = min(x(:));
s.xMax = max(x(:));

end
