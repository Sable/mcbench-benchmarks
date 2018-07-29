function keypress(varargin)
%updates global variables to indicate button status

global dxnkey;
global dxnpressed;
global shiftpressed;
global spacepressed;

key = get(gcbf,'CurrentKey');
% disp(key)
if dxnpressed && strcmp(key,dxnkey)
	%do nothing
elseif strcmp(key,'shift') && ~shiftpressed
	shiftpressed=1;
elseif strcmp(key,'space') && ~spacepressed
% 	disp(toc);
	spacepressed=1;
elseif strcmp(key,'leftarrow') || strcmp(key,'uparrow') || strcmp(key,'rightarrow') || strcmp(key,'downarrow')
	dxnkey=key;
	dxnpressed=1;
end;