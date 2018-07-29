function channelClose(sockChannel)
	%
	try
		pause(1);
		sockChannel.close();
	catch
		%do nothing
		s	= lasterror;
		channelErrMsg('channelClose:badClose','could not close channel');
		channelErrMsg(s.identifier, s.message);
	end
	
	return;
end

