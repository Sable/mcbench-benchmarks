% function demoServer



% Setup a server and register it with the socket manager
hostName	= 'localhost';
portNum		= 10054;
server		= serverBind(hostName, portNum);


%==========================================
% SocketManager
% Manage those sockets!
%==========================================
socketManager	= initSocketManager();
set(socketManager,'OpAcceptCallback',@onAccept);
set(socketManager,'OpReadCallback',@onReceive);
socketManager.register(server,true,4);


%==========================================
% Open client socket (SocketChannel) and
% connect to the server.
%==========================================
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


%=========================================
% Write some data
%=========================================

data		= echoServerTestBuffer();
len			= channelWrite(socks(1), data);
fprintf(1,'  Wrote %.0f bytes\n', len);


%shut everything down
channelClose(server);
for nn=1:numel(socks), channelClose(socks(nn)); end
pause(1.0);
socketManager.close();




