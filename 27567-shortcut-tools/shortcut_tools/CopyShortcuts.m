function CopyShortcuts(oldCategory, newCategory, labels)
%COPYSHORTCUTS Copies shortcuts from one category to another.
% 
% COPYSHORTCUTS(OLDCATEGORY, NEWCATEGORY) copies shortcuts from
% one category to another.  By default, the target category is the
% toolbar.
% 
% COPYSHORTCUTS(OLDCATEGORY, NEWCATEGORY, LABELS) works as above, but
% only copies the shortcuts with labels in LABELS.
% 
% Examples: 
% 
% CopyShortcuts('Shortcuts for Project 1', [], {'Shortcut 1', 'Shortcut 2'})
% 
% See also: AddShortcut, AddShortcutCategory

% Based upon an idea by Iram J. Weinstein.

% $Author: rcotton $	$Date: 2010/08/23 14:35:09 $	$Revision: 1.1 $
% Copyright: Health and Safety Laboratory 2010

SetDefaultValue(2, 'newCategory', DefaultToolbarCategoryName());
SetDefaultValue(3, 'labels', []);

shortcuts = GetShortcuts(oldCategory, labels);

for i = 1:length(shortcuts)
   shortcuts(i).category = newCategory;
end

arrayfun(@AddShortcut, shortcuts);

end
