function amsg = append_crc(message)
% Appends the crc (Low byte, high byte) to message for modbus
% communication. Message is an array of bytes. Developed for (but not
% limmited to) use with a watlow 96 controller.

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