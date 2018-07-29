%==========================================================================
% function channelRead()
%  Reads bytes from from the SocketChannel.
%  
% Author: Jude Collins
% Date: 09 March 2012
%
%==========================================================================
function [len buffer] = channelRead(sockChannel, numBytes)
	%
	len = 0;
	buffer = [];
	
	if nargin > 1 && numBytes < 0
		channelErrMsg('channelRead:negativeBytes','numBytes must be >= 0');
		error('channelRead:negativeBytes','numBytes must be >= 0');
	end
	
	if ~sockChannel.isConnected
		warning('channelRead:notConnected','sockChannel is not connected');
		return;
	end
	
	if nargin < 2
		numBytes	= sockChannel.socket.getReceiveBufferSize();
		%TODO: why am I limiting myself to 2Mb? 
		numBytes	= min(numBytes, 1024*1024*2);
		
		array	= zeros(1,numBytes,'int8');
		buffer	= java.nio.ByteBuffer.wrap(array);

		try
			len		= sockChannel.read(buffer);
		catch
			s	= lasterror;
			channelErrMsg('channelRead:badHeapRead','could not read data');
			sockChannel.close();
			rethrow(s);
		end
	else
		
		totalBytes	= 0;
		
		array	= zeros(1,numBytes,'int8');
		buffer	= java.nio.ByteBuffer.wrap(array);
		tic
		try
			% NOTE: this is dangerous, you do not really want to do this.
			% I am not sure why I even bothered to put this in here.
			% TODO: remove this or set a timeout to read numBytes.
			while totalBytes < numBytes
				len		= sockChannel.read(buffer);
				if len > 0 
					totalBytes	= totalBytes + len;
					%fprintf(1,'Read %.0f bytes @%s (sec) \n', double(len), toc);
				end
			end
		catch
			s	= lasterror;
			channelErrMsg('channelRead:badHeapRead','could not read data');
			sockChannel.close();
			rethrow(s);
		end
	end
		

	return;
end

