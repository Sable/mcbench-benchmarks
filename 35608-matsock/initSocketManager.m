%==========================================================================
% function initSocketManager()
%  Java class that keeps track of socket events for the registered
%  SocketChannels, and also enables Matlab callbacks to process those
%  events.
%
% Author: Jude Collins
% Date: 22 March 2012
%
%==========================================================================
function socketManager = initSocketManager()
import com.jude.nio.*
	
	try
		socketManager	= SocketManager.init();

	catch
		s = lasterror();
		try
			socketManager.close();
		catch
			%do nothing
		end
		rethrow(s);
	end
	
	return;
end

