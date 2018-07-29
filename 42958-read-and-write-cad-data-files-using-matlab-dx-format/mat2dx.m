%% -- mat2dx.m --
% 
% this function outputs a DX file for viewing in VMD or PyMOL. It uses
% six inputs to function properly (subvariables of "DXdata"). While only
% one is necessary (the 3D matrix called "densityMatrix"), the others shape
% and position the 3D matrix in space. A minimum point and a voxel length
% are required to do this. The minimum point is recorded as the "minX"
% "minY" and "minZ" variables.
% As of July 2012, file output format is as defined on
% http://www.poissonboltzmann.org/file-formats/mesh-and-data-formats/opendx-scalar-data
%
%
% -- required inputs (1) --
%
% input value           meaning
%
% input.densityMatrix  rectangular-prism 3D matrix holding density values.
%                       All XYZ values correspond to spatial location of
%                       data. 
%
% -- optional inputs (5): generates defaults when not user-specified --
%
% input value        meaning                           default value
%
% input.outfile      output file name                 "mat2dx.dx"
% input.minX         origin (min) X coord (angstroms)  0.00
% input.minY         origin (min) Y coord (angstroms)  0.00
% input.minZ         origin (min) Z coord (angstroms)  0.00
% input.voxelLength  length to side of voxel (angst.)  1.00
% 
% 
% -- example usage: output a spherical gradient 10 angstroms in radius --
% 
% [X Y Z] = meshgrid(-10:10);                        % make a 3D gradient
% input.densityMatrix = ((X.^2 + Y.^2 + Z.^2).^0.5); % construct 3D space
% isosurface(input.densityMatrix);                   % plot in matlab
% mat2dx(input);                                     % output as DX file
% 
% -- example usage: normalize DX output --
% 
% DXdata = dx2mat('DXfile.dx');                      % interpret DX data
% mat3D = DXdata.densityMatrix;                      % make name convenient
% maxValue = max(max(max(mat3D)));                   % find max value
% minValue = min(min(min(mat3D)));                   % find min value
% valueRange = maxValue - minValue;                  % find range of data
% DXdata.densityMatrix = (mat3D-minValue)/valueRange; % normalize and save
% DXdata.outfile = 'DXfile_normaized.dx';            % rename output
% mat2dx(DXdata);                                    % write to DX file


function mat2dx(DXdata)
%% review input data

% check required input
if ~isfield(DXdata, 'densityMatrix')
    fprintf(['this profram requires a 3D matrix "densityMatrix"\n' ...
        'to function properly\n\texiting...']);
    return;
end

% check optional inputs
if ~isfield(DXdata, 'minX')
    fprintf('no minX variable given, default is 0.00\n');
    DXdata.minX = 0;
end
if ~isfield(DXdata, 'minY')
    fprintf('no minY variable given, default is 0.00\n');
    DXdata.minY = 0;
end
if ~isfield(DXdata, 'minZ')
    fprintf('no minZ variable given, default is 0.00\n');
    DXdata.minZ = 0;
end
if ~isfield(DXdata, 'outfile')
    fprintf('no output file name given, default is mat2dx.dx\n');
    DXdata.outfile = 'mat2dx.dx';
end
if ~isfield(DXdata, 'voxelLength')
    fprintf('no voxel length given, default is 1.00 angstroms\n');
    DXdata.voxelLength = 1;
end

fprintf('outputting 3D data to %s\n', DXdata.outfile);

%% prepare variables for output function

% relabel variables
outfile = DXdata.outfile;
minX = DXdata.minX;
minY = DXdata.minY;
minZ = DXdata.minZ;
voxelLength = DXdata.voxelLength;
densityMatrix = DXdata.densityMatrix;

% convenience variables
dimen = size(densityMatrix);
totalElements = prod(dimen);
overFlowVals = mod(totalElements,3);
numRows = floor(totalElements / 3);

% reshape data for fast output
densityMatrix = reshape(permute(densityMatrix, [3 2 1]), [1 totalElements]);
out3DMat = reshape(densityMatrix(1:end - overFlowVals), [3 numRows])';

%% output data into file

% begin file creation
FILE = fopen(outfile, 'w');

% output header information
fprintf( FILE, 'object 1 class gridpositions counts%8.0f%8.0f%8.0f\n', ...
    dimen(1), dimen(2), dimen(3));
fprintf( FILE, 'origin%16g%16g%16g\n', minX, minY, minZ);
fprintf( FILE, 'delta%16g 0 0\n', voxelLength);
fprintf( FILE, 'delta 0 %16g 0\n', voxelLength);
fprintf( FILE, 'delta 0 0 %16g\n', voxelLength);
fprintf( FILE, 'object 2 class gridconnections counts%8.0f%8.0f%8.0f\n', ...
    dimen(1), dimen(2), dimen(3));
fprintf( FILE, 'object 3 class array type double rank 0 items  %g follows\n', ...
    totalElements);

% output density information
newLine = 0;
for n = 1:numRows
    fprintf(FILE,'%16E%16E%16E\n',out3DMat(n,:));
    % output status --> often not needed! Function is too fast!
    if ~mod(n, floor(numRows/20))
        fprintf('   %6.0f%%',n/numRows*100);
        newLine = newLine + 1;
        if ~mod(newLine,5)
            fprintf('\n');
        end
    end
end
if overFlowVals > 0 % values not in complete row
    for n = 1:overFlowVals
        fprintf(FILE,'%16E',densityMatrix(end-n+1));
    end
    fprintf(FILE,'\n');
end
fprintf('\n');

% output file tail
fprintf( FILE, ['attribute "dep" string "positions"\n' ...
                'object "regular positions regular connections" class field\n' ...
                'component "positions" value 1\n' ...
                'component "connections" value 2\n' ...
                'component "data" value 3\n']);

%fprintf( FILE, 'object "Untitled" call field\n'); % alternate tail

fclose(FILE);

end