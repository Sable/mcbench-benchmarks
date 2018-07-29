function channel = serverBind(hostName, portNum)
import java.io.*;
import java.net.*;
import java.nio.*;
import java.nio.channels.*;

soRcvBuffSize	= 1024*1024*2;		%2 MByte
soSndBuffSize	= 1024*1024*2;
	try
		%==================================================
		% Configure the server and bind it to a port.
		%==================================================
		isa		= InetSocketAddress(hostName,portNum);
		channel = ServerSocketChannel.open();
		sock	= channel.socket();
		sock.setReceiveBufferSize(soRcvBuffSize);
		sock.setReuseAddress(true);
		channel.configureBlocking(false);
		sock.bind(isa);
	
	catch
		s	= lasterror;

		try
			channel.close();
		catch
			%do nothing
		end

		rethrow(s);
	end
end
