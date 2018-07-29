function channel = channelConnect(hostName, portNum, soRcvBuffSize, soSndBuffSize, tcpNoDelay, blocking)
% java imports
import java.io.*;
import java.net.*;
import java.nio.*;
import java.nio.channels.*;
	%

	try
		%=======================================
		% Configure the client socket and
		% establish the connection.
		%=======================================
		portNum			= int32(portNum);
		soRcvBuffSize	= int32(soRcvBuffSize);
		soSndBuffSize	= int32(soSndBuffSize);
		isa				= InetSocketAddress(hostName,portNum);
		
		channel		= SocketChannel.open();
		channel.configureBlocking(false);
		sock		= channel.socket();
		sock.setReceiveBufferSize(soRcvBuffSize);
		sock.setSendBufferSize(soSndBuffSize);
		sock.setTcpNoDelay(true);

		channel.connect(isa);
		
		%NOTE: non-blocking sockets do not block when calling
		%finishConnect() but will immediately return true or false if
		%already connected or not.
		%Invoking finishConnect() when the connection failed will cause
		% an exception to be thrown.
		while ~channel.finishConnect()
			pause(0.1); 
		end

	catch
		s	= lasterror;

		try
			channel.close();
		catch
			%do nothing
		end

		rethrow(s);

	end
	
	return;
end

