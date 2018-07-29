function collectObjects(fig)
% Helper function for browseFigure.m


% Get handles of already present objects
objHandle = get(fig, 'UserData');
% Find handles of new objects
newObjects  = findobj(fig,'Visible','on','-not','Type','figure');
% Make new objects invisible
set(newObjects, 'Visible', 'off');
% Add new objects handles
objHandle{end+1} = newObjects;
% Pass object handles to figure's UserData
set(fig, 'UserData', objHandle);
axHandle = findobj(newObjects, 'Type', 'axes');
% Make handles invisible to avoid overwriting of the axes
set(axHandle, 'HandleVisibility', 'off');
