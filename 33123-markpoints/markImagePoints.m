function pointLocations = markImagePoints(imgax,varname,clr)
% Pass in a handle to an image-containing axes 
% (optional; default is returned by imgca);
%
% Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% 3/25/2011
%
% Copyright 2011 MathWorks, Inc.


if nargin == 0 || isempty(imgax)
    imgax = imgca;
end
axes(imgax);%#ok
imghandle = imhandles(imgax);
if isempty(imghandle)
    error('MarkImagePoints: specified axes does not contain an image!')
end
imghandle = imghandle(1); % Just in case there are multiple images in the axes
parentfig = ancestor(imgax,'figure');
pointLocationsRequested = nargin > 1;
pointLocations = [];
if pointLocationsRequested
    requestedvar = varname;
    if isempty(requestedvar)
        requestedvar = 'MarkedPoints';
    end
end
if nargin < 3
    clr = [1 0 0]; %default = red
end
oldTitleProps = get(get(imgax,'title'));
tmp       = title(imgax,'Click to define object(s). Press <ENTER> to finish selection.');
set(tmp,'color',clr,'fontsize',12, 'fontweight','b','tag','markImagePoints', 'Visible', 'on');
currBDF   = get(imgax,'ButtonDownFcn');
currKPF   = get(parentfig,'KeyPressFcn');
set(imgax,'ButtonDownFcn','');
set(imghandle,'ButtonDownFcn',@placePoint);
set(parentfig,'KeyPressFcn',  @noMorePoints);

    function roi = impoint2(varargin)
        % impoint2: improved impoint object
        roi      = impoint(varargin{:});
        % Add a context menu for adding points
        l        = findobj(roi,'type','hggroup');
        uic      = unique( get(l,'UIContextMenu') );
        for u = 1:numel(uic)
            uimenu( uic(u), 'Label', 'Delete', 'Callback', @deleteROI )
        end
        
        function deleteROI(src,evt) %#ok
            delete(roi);
        end
        
    end

    function pointLocations = noMorePoints(~,evt)
        finished  = strcmpi(evt.Key,'return');
        if finished
            % Delete title, reset original functionality
            %delete(findall(parentfig,'tag','markImagePoints'));
            set(findall(parentfig,'tag','markImagePoints'),...
                'string',oldTitleProps.String,...
                'color',oldTitleProps.Color,...
                'tag',oldTitleProps.Tag,...
                'fontsize',oldTitleProps.FontSize,...
                'fontweight',oldTitleProps.FontWeight,...
                'visible',oldTitleProps.Visible);
            set(imghandle,'ButtonDownFcn','');
            set(parentfig,'KeyPressFcn','');
            set(imgax,'ButtonDownFcn',currBDF);
            set(parentfig,'KeyPressFcn',currKPF);
            if pointLocationsRequested
                roi = findall(imgax,'type','hggroup');
                pointLocations = NaN(numel(roi),2);
                for ii = 1:numel(roi)
                    tmp = get(roi(ii),'children');
                    pointLocations(ii,1) = get(tmp(1),'xdata');
                    pointLocations(ii,2) = get(tmp(1),'ydata');
                end
                assignin('base',requestedvar,pointLocations);
            end
        end
        
    end

    function placePoint(varargin)
        point_loc = get(imgax,'CurrentPoint');
        point_loc = point_loc(1,1:2);
        impoint2(imgax,point_loc);
    end

end