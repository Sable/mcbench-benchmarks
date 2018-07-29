function updateAncestorListeners(h_group,update_fcn)
%updateAncestorListeners Set up listeners to ancestors. 
%   updateAncestorListeners(H_GROUP,UPDATE_FCN) sets up listeners to all
%   ancestors of H_GROUP that have Position, XLim, or YLim properties. H_GROUP
%   is an hggroup object. UPDATE_FCN is a function handle that is called when
%   any of the ancestor properties change.
% 
%   It's important to use updateAncestorListeners when you are drawing objects
%   in a way that may depend on the current Position, XLim, or YLim properties
%   of ancestors. If these properties change, you need to redraw your
%   object. Using updateAncestorListeners makes the code drawing objects more
%   robust to user actions like zooming and resizing.

%   Copyright 2005 The MathWorks, Inc.
%   $Revision $  $Date: 2005/05/27 14:07:37 $
  
% Clear the old listeners.
setappdata(h_group, 'AncestorPositionListeners', []);

h_parent = get(h_group, 'Parent');
root = 0;
listeners = [];
property_list = {'Position', 'XLim', 'YLim'};
while h_parent ~= root
  % Some ancestor objects might not have Position properties.
  properties = get(h_parent);
  for k = 1:numel(property_list)
    property = property_list{k};
    if isfield(properties, property)
      parent_handle = handle(h_parent);
      listener = handle.listener(parent_handle, ...
                                 parent_handle.findprop(property), ...
                                 'PropertyPostSet', update_fcn);
      if isempty(listeners)
        listeners = listener;
      else
        listeners(end + 1) = listener;
      end
    end
  end
  h_parent = get(h_parent, 'Parent');
end

setappdata(h_group, 'AncestorPositionListeners', listeners);

