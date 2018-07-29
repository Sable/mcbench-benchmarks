%==========================================================================
% function onReceive(hObj, event)
%  Template callback function for the OpReadCallback of the socket manager.
%==========================================================================
function onReceive(hObj, event) %#ok<INUSL,IN%#ok<MSNU> USD>
global bAutoRequest
	
	%=========================================
	% received data and event timestamp
	%=========================================
	channel = event.channel;	%the SocketChannel that triggered the event
	data	= event.data;		%the received data (int8 array)
	time	= event.time;		%the time stamp
	
	numBytes	= numel(data);
	
	str = sprintf('read %.0f bytes on %s @%.3f(sec)', numBytes, char(channel.toString()), time);
	threadMessage('onReceive', str);
	
	%=========================================
	% TODO: do all of your processing here.
	%=========================================
	
	
	if ~isempty( findstr('10059',char(channel.toString())) ) %#ok<FSTR>
		disp('If you put a break point here you will see that the other channels');
		disp(' are still being processed while you wait here.');
	end
	
	
	
	%=========================================
	% Request more data.
	% NOTE: the socket manager runs on its own
	% thread and so you can set bAutoRequest
	% to false at anytime you like on the Matlab
	% command prompt to stop the
	% never-ending request-process loop once
	% it is enabled.
	%=========================================
	
	if( bAutoRequest )
		request		= echoServerTestBuffer();
		channelWrite(channel, request);
	end
	
	
	
	return;
end

