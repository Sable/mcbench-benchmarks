function keyrelease(varargin)
%updates global variables to indicate key releases

global dxnkey;
global dxnpressed;		
global shiftpressed;
global spacepressed;

key = get(gcbf,'CurrentKey');

if strcmp(key,'shift')
	shiftpressed=0;
elseif strcmp(key,'space');
	spacepressed=0;
elseif strcmp(key,dxnkey)
	dxnpressed=0;
end;