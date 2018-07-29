function helpCategoryName = DefaultHelpCategoryName()
%DEFAULTHELPCATEGORYNAME Returns the default help category name.
% 
% HELPCATEGORYNAME = DEFAULTHELPCATEGORYNAME() returns the default
% help category name, 'Help Browser Favorites'.
% 
% Examples: 
% 
% helpCategoryName = DefaultHelpCategoryName();
% 
% See also: DefaultToolbarCategoryName

% $Author: rcotton $	$Date: 2010/08/23 14:35:09 $	$Revision: 1.1 $
% Copyright: Health and Safety Laboratory 2010

shortcutUtils = GetShortcutUtils();

helpCategoryName = char(shortcutUtils.getDefaultHelpCategoryName());

end
