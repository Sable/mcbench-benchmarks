%==========================================================================
% function echoServer()
%  Generates a 1 MByte byte array with the size written in bytes 5-8.
%==========================================================================
function array = echoServerTestBuffer()
	msgSize		= 1024*1024;
	array		= zeros(1,msgSize,'int8');
	array(6)	= int8(16);
end
