%==========================================================================
% function onAccept(hObj, event)
%  Template callback function for the OpAcceptCallback of the socket manager.
%==========================================================================
function onAccept(hObj, event) %#ok<INUSD>
global bAutoRequest
	
	%=========================================
	% received data and event timestamp
	%=========================================
	channel = event.channel;	%the SocketChannel that was accepted
	%data	= event.data;		%this is just an accept call - no data
	time	= event.time;		%the time stamp
	
	fprintf(1,'accepted a new client @ %.3f (ms)\n', time);
	
	%=========================================
	% TODO: do all of your configuration here
	%=========================================
	% If you set autoRegister to false then you will
	% need to register the socket channel with the
	% selector yourself.
	
	
	
	
	return;
end