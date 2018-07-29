function shortcutNames = GetShortcutNames(category)
%GETSHORTCUTNAMES Returns the names of existing shortcuts.
% 
% SHORTCUTNAMES = GETSHORTCUTNAMES(CATEGORY) returns the
% names of existing  shortcuts in the category, those in the
% 'Toolbar Shortcuts' by default.
% 
% Examples: 
% 
% shortcutNames = GetShortcutNames();
% 
% See also: GetShortcuts, AddShortcut

% $Author: rcotton $	$Date: 2010/10/01 13:58:56 $	$Revision: 1.2 $
% Copyright: Health and Safety Laboratory 2010

shortcutUtils = GetShortcutUtils();

SetDefaultValue(1, 'category', DefaultToolbarCategoryName());

shortcutVector = ...
   shortcutUtils.getShortcutsByCategory(category);

if isempty(shortcutVector)
   shortcutNames = {};
   return
end

shortcutArray = shortcutVector.toArray();
shortcutNames = cell(shortcutArray.size);
for i = 1:length(shortcutNames)
   shortcutNames{i} = char(shortcutArray(i).getLabel());   
end

end
