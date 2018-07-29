function printWithInternetExplorer(url)
%printWithInternetExplorer Print a URL with Internet Explorer.
%   printWithInternetExplorer(URL) prints out the URL.

% Matthew J. Simoneau
% Copyright 2002-2004 The MathWorks, Inc.

if (nargin == 0)
   url = 'http://www.mathworks.com/';
end

h = actxserver('internetexplorer.application');
h.set('visible',1);

h.invoke('Navigate2',url);
while ~isequal(h.get('ReadyState'),'READYSTATE_COMPLETE')
   % Wait for the page to load.
   disp wait
   pause(.05)
end

% Print options.
% http://msdn.microsoft.com/library/default.asp?url=/library/en-us/com/oen_a2z_22sk.asp
OLECMDID_PRINT = 6;
% http://msdn.microsoft.com/library/default.asp?url=/library/en-us/com/oen_a2z_5k38.asp
OLECMDEXECOPT_DONTPROMPTUSER = 2;

% Print.
h.ExecWB(OLECMDID_PRINT,OLECMDEXECOPT_DONTPROMPTUSER);

% We need to wait for printing to stop before closing the browser.  I don't know
% how to find out if it is done, so just wait for 5 seconds.
pause(5);
h.invoke('Quit');