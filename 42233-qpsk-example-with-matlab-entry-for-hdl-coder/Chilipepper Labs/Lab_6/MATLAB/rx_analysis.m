fid = fopen('rx.prn');
M = textscan(fid,'%d %d %d %d %d %d %d','Headerlines',1);
fclose(fid);
i_in  = double(cell2mat(M(3)));
i_out_foc = double(M{4});
q_out_foc = double(M{5});
i_out_toc = double(M{6});
q_out_toc = double(M{7});
 
figure(1)
subplot(1,2,1)
scatter(i_out_foc,q_out_foc)
title('Scatter Plot of rx with FOC');
subplot(1,2,2)
scatter(i_out_toc,q_out_toc)
title('Scatter Plot of rx with TOC');

figure(2)
subplot(2,2,1)
plot(i_in);
title('OTA Receive Signal (real part)');
subplot(2,2,2)
plot(i_out_foc);
title('Signal Post FOC (real part)');
subplot(2,2,3)
plot(i_out_foc);
title('Signal Post TOC (real part)');