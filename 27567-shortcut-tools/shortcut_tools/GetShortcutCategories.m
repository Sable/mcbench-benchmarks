function categories = GetShortcutCategories()
%GETSHORTCUTCATEGORIES Gets the available shortcut categories.
% 
% CATEGORIES = GETSHORTCUTCATEGORIES() gets the available shortcut
% categories.
% 
% Examples: 
% 
% categories = GetShortcutCategories();
% 
% See also: AddShortcutCategory, GetToolbarShortcutNames

% $Author: rcotton $	$Date: 2010/10/01 13:58:56 $	$Revision: 1.2 $
% Copyright: Health and Safety Laboratory 2010

shortcutUtils = GetShortcutUtils();

categories = cellstr(char(shortcutUtils.getShortcutCategories()));

end
