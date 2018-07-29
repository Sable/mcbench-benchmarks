function [fid, ad76] = read76

% read U.S. Standard 76 atmosphere data file

% output

%  fid  = file id
%  ad76 = atmospheric density data array

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% open data file

fid = fopen('atmos76.dat', 'r');

% check for file open error

if (fid == -1)
    clc; home;
    fprintf('\n\n  error: cannot find requested data file!!');
    keycheck;
    return;
end

ad76 = fscanf(fid, '%E', [inf]);

status = fclose(fid);


