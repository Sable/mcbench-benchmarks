function writePerm( variable )
%WRITERANDOM Write the passed variable as a column called 'perm.txt'
% for use by the spectrum thingy

fid = fopen('perm.txt', 'wt');
fprintf(fid, '%d\n', variable);
fclose(fid);