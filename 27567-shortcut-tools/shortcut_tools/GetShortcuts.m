function shortcuts = GetShortcuts(category, labels)
%GETSHORTCUTS Returns details of existing toolbar shortcuts.
% 
% SHORTCUTS = GETSHORTCUTS(CATEGORY) returns the labels, callback, icon
% path and whether or not the shortcut is editable, for each existing
% toolbar shortcut in the category; those in the 'Toolbar Shortcuts' by
% default.
% 
% SHORTCUTS = GETSHORTCUTS(CATEGORY, LABELS) works as
% above, but only returns shortcuts with labels matching LABELS.
% 
% Examples: 
% 
% shortcuts = GetShortcuts();
% 
% See also: GetShortcutNames, AddShortcut

% $Author: rcotton $	$Date: 2010/08/23 14:35:09 $	$Revision: 1.1 $
% Copyright: Health and Safety Laboratory 2010

shortcutUtils = GetShortcutUtils();

SetDefaultValue(1, 'category', DefaultToolbarCategoryName());

filter = nargin >= 2 && ~isempty(labels);

shortcutArray = ...
   shortcutUtils.getShortcutsByCategory(category).toArray();

shortcuts = struct('label', {}, 'callback', {}, ...
   'icon', {}, 'category', {}, 'editable', {});

for i = 1:shortcutArray.length
   label = char(shortcutArray(i).getLabel());
   if ~filter || strcontains(label, labels)
      shortcuts(end + 1).label = label;           %#ok<AGROW>
      shortcuts(end).callback = ...
         char(shortcutArray(i).getCallback());
      shortcuts(end).icon = ...
         char(shortcutArray(i).getIconPath());
      shortcuts(end).category = category;
      shortcuts(end).editable = ...
         shortcutArray(i).isEditable;
   end
end

end
