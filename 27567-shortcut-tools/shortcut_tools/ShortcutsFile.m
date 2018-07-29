function file = ShortcutsFile()
%SHORTCUTSFILE Returns the path to shortcuts.xml.
% 
% FILE = SHORTCUTSFILE() returns the path to the XML file storing the
% information about the shortcuts.
% 
% Examples: 
% 
% open(ShortcutsFile());
% 
% Parse the XML with xml_io_tools from
% http://www.mathworks.co.uk/matlabcentral/fileexchange/12907-xmliotools
% shortcutsXml = xml_read(ShortcutsFile());
% 
% See also: prefdir

% $Author: rcotton $	$Date: 2010/08/23 14:35:09 $	$Revision: 1.1 $
% Copyright: Health and Safety Laboratory 2010

file = fullfile(prefdir, 'shortcuts.xml');

end
