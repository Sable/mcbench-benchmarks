%==========================================================================
% function threadMessage()
%  Prints the specified message stating the thread that is printing it.
%
% Usage:
% threadMessage(idStr, msgStr);
%
% Example:
% $> threadMessage('uh-oh!','jude ate somebody')
%	thread(main):uh-oh!,jude ate somebody
%
% Author: Jude Collins
% Date: 27 Aug 2012
%==========================================================================
function threadMessage(idStr, msgStr)
	t	= java.lang.Thread.currentThread();
	me	= char(t.getName());
	if nargin < 2 || isempty(msgStr)
		fprintf(1,'thread(%s): %s\n', me, idStr);
	else
		fprintf(1,'thread(%s): %s,%s\n', me, idStr, msgStr);
	end
	return;
end
