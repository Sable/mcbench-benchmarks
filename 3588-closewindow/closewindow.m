function closewindow(name)
%CLOSEWINDOW Close a window.
%   CLOSEWINDOW(NAME) closese the window with a certain NAME.

% Matthew J. Simoneau, June 2003
% Copyright 2003 The MathWorks, Inc.

if ~ispc
    error('This only works on Windows.');
end

if ~libisloaded(mfilename);
    loadlibrary('user32.dll',@userproto,'alias',mfilename);
end

h = calllib(mfilename,'FindWindowA',[],name);
calllib(mfilename,'CloseWindow',h);

%===============================================================================
function [fcns,structs,enuminfo] = userproto

fcns=[]; structs=[]; enuminfo=[]; fcns.alias={};

%  HWND _stdcall FindWindowA(LPCSTR,LPCSTR); 
fcns.name{1} = 'FindWindowA';
fcns.calltype{1} = 'stdcall';
fcns.LHS{1} = 'voidRef';
fcns.RHS{1} = {'int8Ref', 'string'};

fcns.name{2} = 'CloseWindow';
fcns.calltype{2} = 'stdcall';
fcns.LHS{2} = 'int32';
fcns.RHS{2} = {'voidRef'};
