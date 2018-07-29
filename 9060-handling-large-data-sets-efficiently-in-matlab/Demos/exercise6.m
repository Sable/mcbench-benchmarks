%% Filename and Format string
% This code loads in the contents of the data file with textscan a block at a
% time and converts the cellarray from textscan into a double array

filename='waferdata.csv'; 
FormatString=['%*f%*f%*f%*f' repmat('%u8',1,9) repmat('%*f',1,7)];

%% Parameters
Headers=3;
NumLines=1e6; % Total number of lines to read
BlockLines=10000; % Size of block
NumBlocks=NumLines/BlockLines; % Number of blocks

%% Open file
fid = fopen(filename); % Open file

%% Preallocate data
data=zeros(NumLines,9,'uint8'); % Pre-allocate space for data

%% Get Headers
cellchunk=textscan(fid,'%s',3,'delimiter','\n'); % Get first 3 lines

%% Read in blocks
for Block=1:NumBlocks
    data((Block-1)*BlockLines+(1:BlockLines),:) = ... 
	cell2mat(textscan(fid,FormatString,BlockLines,'delimiter',','));
    disp(['Block ' num2str(Block) ]); % Display current block to show progress
end

%% Close file
fclose(fid);