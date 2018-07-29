function R=ImportSurferGrd(filename)
% ImportSurferGrid reads an ASCII format surfer .GRD file and returns the
% data matrix in R. NaN values, which are written as 1.7308+38 in surfer
% are replaced with NaN to prevent crashing.
% Input:
%      filename = name of the file to be read, including ".grd" extension
% Output:
% R - matrix containing data (e.g elevation)
%James Ramm 2011
if exist(filename,'file')
grdfile=fopen(filename,'r');    % Open file
else
    error('ImportGrid:NoFile','File does not exist');
end


code=fgetl(grdfile);            % Reads surfer code 'DSAA'
% Grid dimensions (number of nodes, 2nd line of surfer file)
aux=str2num(fgetl(grdfile)); nx=aux(1); % columns
ny=aux(2); % rows
% X limits, 3rd line of .grd file
aux=(fgetl(grdfile)); %xmin=aux(1); xmax=aux(2);
% Y limits, 4th line of .grd file
aux=(fgetl(grdfile)); %ymin=aux(1); ymax=aux(2);
% Z limits, 5th line
aux=(fgetl(grdfile)); %zmin=aux(1); aux(2);
% Reads Z matrix
[R] = fscanf(grdfile, '%f', [nx,ny]);

% transpose matrix as matlab indices are (rows, columns) not (columns, rows).
R = R';
fclose(grdfile);
% Get rid of those crappy surfer nan values and replace with NaN 
[I,J]= size(R);


for i = 1:I
    for j=1:J
        if R(i,j)>100000
            R(i,j) = NaN;
        end
    end
end
end



