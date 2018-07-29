function AddBrowserFavourite(label, callback)
%ADDBROWSERFAVOURITE Adds a favourite to the help browser.
% 
% ADDBROWSERFAVOURITE(LABEL, CALLBACK) adds a favourite to the help
% browser.
% 
% NOTE: Although typical usage would be to open a help page, it is
% possible to call any MATLAB code.
% 
% Examples: 
% 
% AddBrowserFavourite('mean', 'doc mean');
% 
% AddBrowserFavourite('MATLAB Central', ...
%    'web http://www.mathworks.co.uk/matlabcentral/ -helpbrowser');
% 
% See also: AddToolbarShortcut, AddShortcutCategory

% $Author: rcotton $	$Date: 2010/08/23 14:35:09 $	$Revision: 1.1 $
% Copyright: Health and Safety Laboratory 2010

shortcutUtils = GetShortcutUtils();

shortcutUtils.addHelpShortcut(label, callback);

end
