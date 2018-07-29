function make_train_lut

hks_i = comm.KasamiSequence('SamplesPerFrame', 65,'Index',1);
hks_q = comm.KasamiSequence('SamplesPerFrame', 65,'Index',3);
x_i = step(hks_i);
x_q = step(hks_q);
t_i = x_i*2-1;
t_q = x_q*2-1;

fid = fopen('TB_i.m','w+');
fprintf(fid,'function y = TB_i\n');
fprintf(fid,'%%#codegen\n');
fprintf(fid,'y = [\n');
fprintf(fid,'%1d\n',t_i);
fprintf(fid,'];\n');
fclose(fid);
fid = fopen('TB_q.m','w+');
fprintf(fid,'function y = TB_q\n');
fprintf(fid,'%%#codegen\n');
fprintf(fid,'y = [\n');
fprintf(fid,'%1d\n',t_q);
fprintf(fid,'];\n');
fclose(fid);
