function amsg = append_crc(message)
% Appends the crc (Low byte, high byte) to message for modbus
% communication. Message is an array of bytes. Developed for (but not
% limmited to) use with a Watlow 96 controller.  
%{
Copyright (c) 2009, Brian Keats All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer. * Redistributions in
binary form must reproduce the above copyright notice, this list of
conditions and the following disclaimer in the documentation and/or other
materials provided with the distribution
      
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
%}
%    
% W. R. Ashurst appended comments:  Usage - the argument 'message' contains
% decimal representation of hex values that comprise the message.  For
% Omega CN7800 at address '004', modbus mode 03 (read 1 register) starting
% address 1000 the message is '040310000001' in hex.  In decimal, it is '4,
% 3, 16, 0, 0, 1'.  The decimal form is passed to this function
% (append_crc) as an array of doubles which gives the result '4 3 16 0 0 1
% 128 159' Thus the MODBUS RTU message to send out via 'fwrite' would be
% [4, 3, 16, 0, 0, 1 128, 159]   I have verified this crc calculation with
% other Omega documentation.  Jan 13, 2012.


N = length(message);
crc = hex2dec('ffff');
polynomial = hex2dec('a001');

for i = 1:N
    crc = bitxor(crc,message(i));
    for j = 1:8
        if bitand(crc,1)
            crc = bitshift(crc,-1);
            crc = bitxor(crc,polynomial);
        else
            crc = bitshift(crc,-1);
        end
    end
end

lowByte = bitand(crc,hex2dec('ff'));
highByte = bitshift(bitand(crc,hex2dec('ff00')),-8);

amsg = message;
amsg(N+1) = lowByte;
amsg(N+2) = highByte;


