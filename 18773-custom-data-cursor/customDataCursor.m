function dcmH = customDataCursor(h, datalabels)

% customDataCursor allows a user to label each point in a data series with
% custom labels. When the data cursor mode is enabled (DATACURSORMODE ON),
% clicking on a data point will display the custom label, then the x and y
% values of the data point. If more than one data point of the data series
% is in the same location, the data cursor will display all of the labels
% first, then the x and y locations.
%
% Usage: customDataCursor(H,DATALABELS) applies the custom labels found in
% cell array DATALABELS to the line with handle H. DATALABELS must be a
% cell array with the same length as 'XDATA' and 'YDATA' in the line; in
% other words, there must be a label for each data point in the line.
%
% dcmH = customDataCursor(H,DATALABELS) returns the handle to the data
% cursor in dcmH.
%
% Note: CUSTOMDATACURSOR uses the 'UserData' property of a line to store
% and retrieve the labels. If that property is used by another portion of a
% user's program, this function may be broken, or this function may break
% the user's program.
% 
% Example:
%   % generate some data and chart it
%   N = 20;
%   x = rand(N,1);
%   y = rand(N,1);
%   h = plot(x,y,'ko');
%   % make up some labels and apply them to the chart
%   labels = cell(N,1);
%   for ii = 1:N
%       labels{ii} = ii;
%   end
%   customDataCursor(h,labels)

% Check input arguments
if ~exist('h','var')||~exist('datalabels','var')
    error('Improper inputs to function customDataCursor')
elseif ~ishandle(h)
    error('Nonexistent handle passed to function customDataCursor')
elseif length(datalabels) ~= length(get(h,'xdata'))
    error(['Error in input to function customDataCursor: '...
        'number of labels is different than the number of data points in the line'])
end

% Put the labels in the 'userdata' property of the line
set(h,'userdata',datalabels)
% find the handle for the data cursor; set the update function 
dcmH = datacursormode(gcf); 
set(dcmH,'UpdateFcn',@cursorUpdateFcn)

function output_txt = cursorUpdateFcn(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

% position of the data point to label
pos = get(event_obj,'Position');
% read in the labels from 'UserData' of the line
labels = get(get(event_obj,'Target'),'UserData');
% read the x and y data
xvals = get(get(event_obj,'Target'),'XData');
yvals = get(get(event_obj,'Target'),'YData');
% now figure out which data point was selected
datapoint = find( (xvals==pos(1))&(yvals==pos(2)) );

% create the text to be displayed
output_txt = { labels{datapoint};...
    ['X: ',num2str(pos(1),4)];...
    ['Y: ',num2str(pos(2),4)] };

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
end