function AddShortcutCategories(categories)
%ADDSHORTCUTCATEGORIES  Adds a new category of shortcut.
% 
% If CATEGORY is a character array, ADDSHORTCUTCATEGORIES(CATEGORY) adds
% a new category of shortcut named CATEGORY.
% 
% If CATEGORY is a cell array of strings,
% ADDSHORTCUTCATEGORIES(CATEGORY) adds a new category of shortcut for
% each string in CATEGORY.
% 
% Examples: 
% 
% Provide sample usage code here
% 
% See also: List related files here

% $Author: rcotton $	$Date: 2010/10/01 13:58:56 $	$Revision: 1.1 $
% Copyright: Health and Safety Laboratory 2010

if ischar(categories)
   categories = cellstr(categories);
end

shortcutUtils = GetShortcutUtils();
cellfun(@(category) shortcutUtils.addNewCategory(category), categories);

end
