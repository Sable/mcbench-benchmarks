function toolbarCategoryName = DefaultToolbarCategoryName()
%DEFAULTTOOLBARCATEGORYNAME Returns the default toolbar category name.
% 
% TOOLBARCATEGORYNAME = DEFAULTTOOLBARCATEGORYNAME() returns the default
% toolbar category name, 'Toolbar Shortcuts'.
% 
% Examples: 
% 
% toolbarCategoryName = DefaultToolbarCategoryName();
% 
% See also: DefaultHelpCategoryName

% $Author: rcotton $	$Date: 2010/08/23 14:35:09 $	$Revision: 1.1 $
% Copyright: Health and Safety Laboratory 2010

shortcutUtils = GetShortcutUtils();

toolbarCategoryName = ...
   char(shortcutUtils.getDefaultToolbarCategoryName());

end
