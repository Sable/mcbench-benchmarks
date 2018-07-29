%==========================================================================
% function threadName()
%  Returns the name of this thread.
%
% Author: Jude Collins
% Date: 27 Aug 2012
%==========================================================================
function me = threadName()
	t	= java.lang.Thread.currentThread();
	me	= char(t.getName());
	return;
end
