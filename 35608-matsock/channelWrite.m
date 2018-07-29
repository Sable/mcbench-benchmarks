%==========================================================================
% function channelWrite()
%  
% Author: Jude Collins
% Date: 09 March 2012
%
%==========================================================================
function len = channelWrite(sockChannel, data)
	%
	
	s		= whos('data');
	class	= s.class;
	
	
	if( strcmp(class,'java.nio.HeapByteBuffer') )
		try
			data.flip();
			len = sockChannel.write(data);
			data.compact();
		catch
			s	= lasterror;
			channelErrMsg('channelWrite:badHeapWrite','could not write data');
			sockChannel.close();
			rethrow(s);
		end
	else
		
		if( strcmp(class,'int8') )
			stuffBuff	= java.nio.ByteBuffer.wrap(data);
			stuffBuff.position(int32(numel(data)));
			stuffBuff.flip();
		else
			stuff		= typecast(data,'int8');
			stuffBuff	= java.nio.ByteBuffer.wrap(stuff);
			stuffBuff.position(int32(numel(stuff)));
			stuffBuff.flip();
		end
		
		try
			len = sockChannel.write(stuffBuff);
		catch
			s	= lasterror;
			channelErrMsg('channelWrite:badHeapWrite','could not write data');
			sockChannel.close();
			rethrow(s);
		end
		
	end

	return;
end

