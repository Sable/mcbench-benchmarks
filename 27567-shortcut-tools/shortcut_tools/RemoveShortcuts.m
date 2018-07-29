function RemoveShortcuts(category, labels)
%REMOVESHORTCUTS Removes the shortcuts specified by label and category.
% 
% REMOVESHORTCUTS(CATEGORY) removes the all the shortcuts from the
% specified category, which by default is the toolbar.
% 
% REMOVESHORTCUTS(CATEGORY, LABELS) works as above, but only removes the
% shortcuts with the specified labels.
% 
% Examples: 
% 
% RemoveShortcuts();                                  % clears the toolbar
% RemoveShortcuts(DefaultHelpCategoryName());         % clears browser favourites
% cellfun(@RemoveShortcuts, GetShortcutCategories);   % clears everything
% 
% See also: AddShortcut

% $Author: rcotton $	$Date: 2010/10/01 13:58:56 $	$Revision: 1.2 $
% Copyright: Health and Safety Laboratory 2010

shortcutUtils = GetShortcutUtils();

SetDefaultValue(1, 'category', DefaultToolbarCategoryName());
SetDefaultValue(2, 'labels', GetShortcutNames(category));

if isempty(labels)
   return
end

if ischar(labels)
   labels = cellstr(labels);
end

if ~isvector(labels)
   disp(labels);
end

try
   cellfun(@(label) shortcutUtils.removeShortcut(category, label), labels);
catch ex
   disp(ex);
end
   
   
end
