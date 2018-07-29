fid = fopen('rx_data.prn');
M = textscan(fid,'%d %d %d %d %d','Headerlines',1);
fclose(fid);
i_out_toc  = double(cell2mat(M(3)));
q_out_toc  = double(M{4});
byte_array = double(M{5});
byte_array = byte_array';

figure(1)
subplot(1,2,1)
scatter(i_out_toc,q_out_toc)
title('Scatter Plot of rx with TOC');
subplot(1,2,2)
plot(i_out_toc);
title('Signal Post TOC (real part)');

[a,b,bytes] = find(byte_array);

numRecBytes = bytes(1)
%+2 represents number of header bits
msgBytes = bytes((1+2):(numRecBytes+2));

native2unicode(msgBytes)
