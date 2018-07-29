function flipxyview (hAxes)
% FLIPXYVIEW - flips (mirror rotates) the horizontal and vertical plot axes 
%
%   FLIPXYVIEW sets the view of the current 2D axes in such a way that the
%   x and y axis interchange positions. The current horizontal axis will
%   become the vertical axis, and vice versa.
%
%   FLIPXYVIEW (AX) rotates the axes specified by the handle AX.
%
%   Note that this function only changes the view and not the x and y
%   values of the plotted points. Applying this function twice will undo
%   the flip.
%
%   Examples:
%
%     x = linspace(0,4*pi,50) ; y = 5*sin(x) ; 
%     % make two subplots
%     for ii=1:2,
%       ah(ii) = subplot(2,2, ii) ; plot(x,y,'bo-') ;
%       xlabel('X') ; ylabel('Y') ;
%     end
%     % flip X- & Y-axis of first subplot
%     flipxyview(ah(1)) ; 
%
%     % Create a errorbar plot, with horizontal error bars
%     y = 1:5 ; x = polyval([2 3 4],y) ; 
%     xerr = 5*rand(size(x)) ; % Errors in X
%     subplot(2,2,3) ; errorbar(y,x,xerr,'bo') ;
%     xlabel('Y') ; ylabel('X') ; % !! note the names
%     flipxyview 
%
%   See also VIEW

% version 2.0 (mar 2010)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History
% created in 2008
% 2.0 (mar 2010) - added help, error checks, comments etc

if nargin==0,
    % get the current axes, without creating one if it does not exists
    hAxes = get(get(0,'currentfigure'),'currentaxes') ;
    if isempty(hAxes),
        % nothing to do ...
        return
    end
end    

if (numel(hAxes) ~= 1) || ~ishandle(hAxes) || ~strcmp(get(hAxes,'Type'),'axes')
    % check if this a valid axes handle (modified from VIEW)
    error([mfilename ':InvalidArgument'], 'The single argument must be a scalar axes handle');
end

AzEl = get(hAxes,'View') ; % current view (Azimuth & Elevation)
if isequal(AzEl, [0 90])
    % standard view (Y vs X): change to flipped view (X vs Y)
    set(hAxes, 'View', [90 -90]);
elseif isequal(AzEl, [90 -90 ])
    % flipped view (X vs Y): change to standard view (Y vs X)
    set(hAxes, 'View', [0 90]);
else
    % neither, that is, not a proper 2D view
    warning([mfilename ':non2Dview'],[upper(mfilename) ' is only supported for 2D views']) ;
end


