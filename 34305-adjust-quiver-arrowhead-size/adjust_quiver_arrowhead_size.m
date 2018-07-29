function adjust_quiver_arrowhead_size(quivergroup_handle, scaling_factor)
% Make quiver arrowheads bigger or smaller.
%
% adjust_quiver_arrowhead_size(quivergroup_handle, scaling_factor)
%
% Example:
%   h = quiver(1:100, 1:100, randn(100, 100), randn(100, 100));
%   adjust_quiver_arrowhead_size(h, 1.5);   % Makes all arrowheads 50% bigger.
%
% Inputs:
%   quivergroup_handle      Handle returned by "quiver" command.
%   scaling_factor          Factor by which to shrink/grow arrowheads.
%
% Output: none

% Kevin J. Delaney
% December 21, 2011
% BMT Scientific Marine Services (www.scimar.com)

if ~exist('quivergroup_handle', 'var')
    help(mfilename);
    return
end

if isempty(quivergroup_handle) || any(~ishandle(quivergroup_handle))
    errordlg('Input "quivergroup_handle" is empty or contains invalid handles.', ...
             mfilename);
    return
end

if length(quivergroup_handle) > 1
    errordlg('Expected "quivergroup_handle" to be a single handle.', mfilename);
    return
end

if ~strcmpi(get(quivergroup_handle, 'Type'), 'hggroup')
    errrodlg('Input "quivergroup_handle" is not of type "hggroup".', mfilename);
    return
end

if ~exist('scaling_factor', 'var') || ...
   isempty(scaling_factor) || ...
   ~isnumeric(scaling_factor)
    errordlg('Input "scaling_factor" is missing, empty or non-numeric.', ...
             mfilename);
    return
end

if length(scaling_factor) > 1
    errordlg('Expected "scaling_factor" to be a scalar.', mfilename);
    return
end

if scaling_factor <= 0
    errordlg('"Scaling_factor" should be > 0.', mfilename);
    return
end

line_handles = get(quivergroup_handle, 'Children');

if isempty(line_handles) || (length(line_handles) < 3) || ...
   ~ishandle(line_handles(2)) || ~strcmpi(get(line_handles(2), 'Type'), 'line')
    errordlg('Unable to adjust arrowheads.', mfilename);
    return
end

arrowhead_line = line_handles(2);

XData = get(arrowhead_line, 'XData');
YData = get(arrowhead_line, 'YData');

if isempty(XData) || isempty(YData)
    return
end

%   Break up XData, YData into triplets separated by NaNs.
first_nan_index = find(~isnan(XData), 1, 'first');
last_nan_index  = find(~isnan(XData), 1, 'last');

for index = first_nan_index : 4 : last_nan_index
    these_indices = index + (0:2);
    
    if these_indices(end) > length(XData)
        break
    end
    
    x_triplet = XData(these_indices);
    y_triplet = YData(these_indices);
    
    if any(isnan(x_triplet)) || any(isnan(y_triplet))
        continue
    end
    
    %   First pair.
    delta_x = diff(x_triplet(1:2));
    delta_y = diff(y_triplet(1:2));
    x_triplet(1) = x_triplet(2) - (delta_x * scaling_factor);
    y_triplet(1) = y_triplet(2) - (delta_y * scaling_factor);
        
    %   Second pair.
    delta_x = diff(x_triplet(2:3));
    delta_y = diff(y_triplet(2:3));
    x_triplet(3) = x_triplet(2) + (delta_x * scaling_factor);
    y_triplet(3) = y_triplet(2) + (delta_y * scaling_factor);
    
    XData(these_indices) = x_triplet;
    YData(these_indices) = y_triplet;
end

set(arrowhead_line, 'XData', XData, 'YData', YData);
