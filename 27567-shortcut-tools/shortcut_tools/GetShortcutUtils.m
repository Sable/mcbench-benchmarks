function shortcutUtils = GetShortcutUtils()
%GETSHORTCUTUTILS Gets an instance of ShortcutUtils.
% 
%  SHORTCUTUTILS = GETSHORTCUTUTILS() gets an instance of ShortcutUtils.
% 
% Examples: 
% 
% shortcutUtils = GetShortcutUtils();
% methods(shortcutUtils)
% methodsview(shortcutUtils)

% $Author: rcotton $	$Date: 2010/08/23 14:35:09 $	$Revision: 1.1 $
% Copyright: Health and Safety Laboratory 2010

CheckForJVM();
shortcutUtils = com.mathworks.mlwidgets.shortcuts.ShortcutUtils;

end
