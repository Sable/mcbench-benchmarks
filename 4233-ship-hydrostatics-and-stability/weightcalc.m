%WEIGHT_CALC    MATLAB file that performs weight calculations
%   Calls a file of ship data.  Prints an output file called weights.out.
%   For details see Subsection 7.2.2 in the book. 
%   Companion file to Biran, A. (2003), Ship Hydrostatics and Stability,
%   Oxford: Butterworth-Heinemann.

!rename weights.out weights.old      % prepare space for new data file
disp('Enter name of data file, then write RETURN and press ENTER ')
keyboard
fname = 'weights.out';
fid = fopen(fname, 'w');
title = [ sname ', weight calculations' ];
fprintf(fid, '%40s\n', title)
fprintf(fid, '---------------------------------------------------------------------------\n')
fprintf(fid, '     Weight item          Mass      vcg      z-Moment    vcg      x-Moment\n')
fprintf(fid, '----------------------------------------------------------------------------\n')


Displ = sum(wdata(:, 1));
vmom  = wdata(:, 1).*wdata(:, 2);
KG    = sum(vmom)/Displ;
lmom  = wdata(:, 1).*wdata(:, 3);
LCG   = sum(lmom)/Displ;

head = '%16s %11.2f %7.2f %12.2f %8.2f %13.2f\n';
[ m, n ] = size(wdata);
for k = 1:m
    name = names(k, :);
    fprintf(fid, head, name, wdata(k, 1), wdata(k, 2), vmom(k), wdata(k, 3), lmom(k))
end
fprintf(fid, '---------------------------------------------------------------------------\n')
subtitle = 'Total           ';
fprintf(fid, head, subtitle, Displ, KG, sum(vmom), LCG, sum(lmom))