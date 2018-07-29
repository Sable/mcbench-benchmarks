%% -- dx2mat.m --
% 
% this function reads in a DX file and translates it into a 3D matrix in
% matlab. DX files are file formats for storing 3D data in plaintext, and
% they are readable by PyMOL and VMD. One inputs the DX file path, and the
% program outputs a structure with all the information about the DX
% 
% As of July 2012, file output format is as defined on
% http://www.poissonboltzmann.org/file-formats/mesh-and-data-formats/opendx-scalar-data
% 
% The output of this can be read by mat2dx.m
% 
% -- required inputs (1) --
%
% input value           meaning
%
% file name             a string that leads to the DX file path
%
% -- outputs (5) --
%
% output value         meaning                           example value
%
% DXdata.densityMatrix  rectangular-prism 3D matrix holding density values.
%                       All XYZ values correspond to spatial location of
%                       data.
% 
% DXdata.outfile      output file name                 "mat2dx.dx"
% DXdata.minX         origin (min) X coord (angstroms)  0.00
% DXdata.minY         origin (min) Y coord (angstroms)  0.00
% DXdata.minZ         origin (min) Z coord (angstroms)  0.00
% DXdata.voxelLength  length to side of voxel (angst.)  1.00 or [1.10 2.30 ]
% 
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
% mat2dx(DXdata);

function [DXdata] = dx2mat(readFile)
tic;

%% read every line in file

% initialize file (read all into memory)
fprintf('reading in file %s\n', readFile);
FileID = fopen(readFile);
rawText = fread(FileID,inf,'*char');

% close file
fclose(FileID);

%% interpret introductory data

fprintf('importing data about 3D matrix\n');

% parse lines by end-of-lines
splitLines = strread(rawText, '%s', 'delimiter', '\n');
numLines = length(splitLines);

% use introductory data to deduce file length and grid positions
voxelLength = [0 0 0]';
lineCounter = 1;
while ( lineCounter < numLines )
    
    % find number of voxels in each dimension
    if ~isempty(strmatch('object 1 class gridpositions counts', splitLines(lineCounter)))
        
        % decode string
        strResults = regexp(splitLines(lineCounter), '(\d+)','match');
        numResults = str2double(strResults{1}(:));
        
        % save voxel counts
        numXvoxels = numResults(2);
        numYvoxels = numResults(3);
        numZvoxels = numResults(4);
    end
    
    % find origin or data
    if ~isempty(strmatch('origin', splitLines(lineCounter)))
        
        % decode string
        strResults = regexp(splitLines(lineCounter), '(\d+)','match');
        numResults = str2double(strResults{1}(:));
        
        % save voxel counts
        minX = numResults(1);
        minY = numResults(2);
        minZ = numResults(3);
    end
    
    % find voxel length in each dimension
    if ~isempty(strmatch('delta ', splitLines(lineCounter)))
        
        % decode string
        strResults = regexp(splitLines(lineCounter), '(\d+)','match');
        numResults = str2double(strResults{1}(:));
        
        % record voxel dimensions
        voxelLength = voxelLength + numResults;
    end
    
    % find total number of data points
    if ~isempty(strmatch('object 3 class array type double rank 0 items', splitLines(lineCounter)))
        
        % decode string, save results
        strResults = regexp(splitLines(lineCounter), '(\d+)','match');
        totalDXelements = str2double(strResults{1}(3));
        
        firstLineOfData = lineCounter + 1;
    end
    
    % exit while loop
    if (exist('numXvoxels', 'var') && sum(voxelLength ~= 0) == 3 && ...
            exist('minX', 'var') && exist('totalDXelements', 'var'))
        lineCounter = numLines;
    end
    
    lineCounter = lineCounter + 1;
    
end

% check number of 3D data elements
if ( (numXvoxels * numYvoxels * numZvoxels) ~= totalDXelements )
    fprintf('ERROR!\n\tdimensional mismatch in number of 3D elements!\n');
    return;
end

%% interpret 3D grid data

fprintf('reading in 3D data\n');

% pull in main bulk of data
linearMatrix = zeros(1, totalDXelements);
lineCounter = firstLineOfData;
lastLineOfData = firstLineOfData + ceil(totalDXelements / 3) - 1;
matCounter = 1;
newLine = 0;
while ( lineCounter < lastLineOfData )
    
    strResults = regexp( splitLines(lineCounter), '(\S+)','match');
    numResults = str2double(strResults{1}(:));
    
    linearMatrix(matCounter:matCounter+2) = numResults;
    
    lineCounter = lineCounter + 1;
    matCounter  = matCounter + 3;
    
    if ~mod(lineCounter, floor(totalDXelements/20))
        fprintf('   %6.0f%%',lineCounter/ceil(totalDXelements / 3)*100);
        newLine = newLine + 1;
        if ~mod(newLine,5)
            fprintf('\n');
        end
    end
    
end

% pull in last line of data
strResults = regexp( splitLines(lastLineOfData), '(\S+)','match');
numResults = str2double(strResults{1}(:));
linearMatrix(matCounter:end) = numResults;

fprintf('      100%%\n');

%% prepare output

fprintf('finishing ...\n');

DXdata.outfile = readFile;

% save information
DXdata.minX = minX;
DXdata.minY = minY;
DXdata.minZ = minZ;

if ( sum(voxelLength == voxelLength(1)) == 3 )
    DXdata.voxelLength = voxelLength(1);
else
    DXdata.voxelLength = voxelLength';
end

% 3D matrix
densityMatrix = permute(reshape(linearMatrix, [numZvoxels numYvoxels numXvoxels]), [3 2 1]);
DXdata.densityMatrix = densityMatrix;

toc;

end