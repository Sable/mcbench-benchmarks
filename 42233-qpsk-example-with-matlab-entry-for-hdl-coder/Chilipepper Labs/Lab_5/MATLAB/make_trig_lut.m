function make_trig_lut

ii = (0:(2^12-1))/2^12;
c = cos(2*pi*ii);
s = sin(2*pi*ii);

fid = fopen('COS.m','w+');
fprintf(fid,'function y = COS\n');
fprintf(fid,'%%#codegen\n');
fprintf(fid,'y = [\n');
fprintf(fid,'%14.12f\n',c);
fprintf(fid,'];\n');
fclose(fid);
fid = fopen('SIN.m','w+');
fprintf(fid,'function y = SIN\n');
fprintf(fid,'%%#codegen\n');
fprintf(fid,'y = [\n');
fprintf(fid,'%14.12f\n',s);
fprintf(fid,'];\n');
fclose(fid);
