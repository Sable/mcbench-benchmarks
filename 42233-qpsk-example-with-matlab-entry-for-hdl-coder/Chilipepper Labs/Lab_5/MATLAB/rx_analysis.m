fid = fopen('rx.prn');
M = textscan(fid,'%d %d %d %d %d %d','Headerlines',1);
fclose(fid);
i_in  = double(cell2mat(M(3)));
i_out = double(M{4});
q_out = double(M{5});
offset = double(M{6});

figure(1)
scatter(i_out,q_out)
title('Scatter Plot of rx with FOC');

figure(2)
subplot(1,2,1)
plot(i_in);
title('OTA Receive Signal (real part)');
subplot(1,2,2)
plot(i_out);
title('Signal Post FOC (real part)');

figure(3)
plot(offset);
title('Phase Estimate');