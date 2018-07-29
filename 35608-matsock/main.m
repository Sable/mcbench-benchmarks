
% Used to control auto requesting more data in the
% onReceive callback function.
global bAutoRequest; bAutoRequest = true; %#ok<NASGU>

%==========================================
% Start the EchoServer
%==========================================
import com.jude.nio.*

echoPorts	= int32(10057:10059);
echoServer	= EchoServer(echoPorts);	%the default port is 10059
echoServer.start();

pause(1.0);

%==========================================
% Open client socket (SocketChannel) and
% connect to the echo server.
%==========================================
hostName		= 'localhost';	%'127.0.0.1'	%server address
portNum			= echoPorts(1);			%server listening port num
soRcvBuffSize	= 1024*1024*2;			%2 MByte
soSndBuffSize	= 1024*1024*2;
tcpNoDelay		= true;					%write immediately, no delays
blocking		= false;				%faster than a speeding bullet...

socks(1)	= channelConnect(...
					hostName, ...
					portNum, ...
					soRcvBuffSize, ...
					soSndBuffSize, ... 
					tcpNoDelay, ...	%hard coded to true
					blocking ); %hard coded to false

%You can now use this socket channel to read and write from
%like you might normally do...

data		= echoServerTestBuffer();
len			= channelWrite(socks(1), data);
fprintf(1,'  Wrote %.0f bytes\n', len);

tot = 0;
while( tot < numel(data) ) 
	len		= channelRead(socks(1));
	fprintf(1,'  Read %.0f bytes\n', len);
	tot		= tot + len;
end

% ...or you could register the socketChannel1 with the
% SocketManager so that the registered callback fires
% whenever there is data to be read.

%==========================================
% SocketManager
% Manage those sockets!
%==========================================
socketManager	= initSocketManager();
% Register a callback that will fire when data is available
% to be read on the connection.
set(socketManager,'OpReadCallback',@onReceive);
socketManager.register(socks(1),4);


%==========================================
% write/read data to/from the echo server
%==========================================
bAutoRequest= false; %#ok<NASGU>
data		= echoServerTestBuffer();
len			= channelWrite(socks(1), data);

% your callback function should have just fired...

%You can also have several socket managers running and any number of
%sockets registered on them.  Well, at least in theory, I have not tested
%it yet, would you like to be the first?  I hope to make some more changes
%soon and add them to this demo file...

% Example: connect 2 more sockets to the EchoServer
% let them all send and receive 1 MByte chunks.
numPorts	= numel(echoPorts);
for nn=2:numPorts
	socks(nn)	= channelConnect(hostName, echoPorts(nn), soRcvBuffSize, soSndBuffSize, tcpNoDelay, blocking );
	socketManager.register(socks(nn),4);
end


% let her rip for a few seconds
bAutoRequest= true;
data		= echoServerTestBuffer();
for nn=1:numPorts
	sock	= socks(nn);
	len		= channelWrite(sock,data);
end
pause(2.0);
bAutoRequest = false;

%shut everything down
for nn=1:numPorts, channelClose(socks(nn)); end
pause(1.0);
echoServer.close();
socketManager.close();



