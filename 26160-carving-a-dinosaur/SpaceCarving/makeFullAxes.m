function makeFullAxes( axh )
%makeFullAxes: make some axes fill the available space
%
%   makeFullAxes(axh) turns of axis labels etc for the axes in AXH and
%   makes the axes fill the available space. In practical terms this just
%   means setting the axes position to be the axes outer-position.
%
%   makeFullAxes(figh) applies the changes to all axes in the figure FIGH.

%   Author: Ben Tordoff
%   Copyright 2009 The Mathworks, Inc.
%   $Revision: 11$   $Date: 2009-11-11$

if strcmpi( get( axh, 'type' ), 'figure' )
    axh = findobj( axh, 'type', 'axes' );
end
axis( axh, 'off' );

if numel( axh ) > 1
    % We assume equal sizes for multiple axes
    outPos = cell2mat( get(axh,'OuterPosition') );
    width = min( outPos(:,3) );
    height = min( outPos(:,4) );
    outPos(:,3) = width;
    outPos(:,4) = height;
    for ii=1:numel( axh )
        set( axh(ii), 'Position', outPos(ii,:) );
    end
else
    myPos = get( axh, 'OuterPosition' );
    myPos(1:2) = max( myPos(1:2), [0 0] );
    myPos(3:4) = min( myPos(3:4), [1 1] );
    set( axh, 'Position', myPos ); 
end