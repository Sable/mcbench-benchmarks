function make_srrc_lut

OS_RATE = 8;

f = firrcos(2*OS_RATE,.25,.25,1,'rolloff','sqrt');
f = f/sum(abs(f)); % make sure no matter what we don't go beyond 1

fid = fopen('SRRC.m','w+');
fprintf(fid,'function y = SRRC\n');
fprintf(fid,'%%#codegen\n');
fprintf(fid,'y = [\n');
fprintf(fid,'%13.12f\n',f);
fprintf(fid,'];\n');
fclose(fid);