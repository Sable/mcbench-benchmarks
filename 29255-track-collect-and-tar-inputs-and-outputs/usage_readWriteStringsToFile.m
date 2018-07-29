% close all; clc;

processStatus = [processStatus, newline, ...
                     datestr(now), ' >> ', '[Start text outputing].'];
 
targetFile = 'in.txt';
targetFile = strcat(inputFilesFolder, '\', targetFile);

processStatus = [processStatus, newline, ...
                     datestr(now), ' >> ', 'Reading text file ...'];
 
% Read the contents an array
fid = fopen(targetFile);
linesFromFile = fread(fid, '*char')';
fclose(fid);

% Read the contents an array in ascii dec values
fid = fopen(targetFile);
linesFromFileInAscii = fread(fid, '*uint8')';
fclose(fid);

% '\r\t' == [13   10]
newlineInAscii1 = [13 10]; % carriage return + newline (used in most text files)
% '\r\t' unaddressed yet
newlineInAscii2 = [13 9]; % newlineChar = '\r\t';

% scan for both to be sure
locationOfCarriageReturnChar = strfind(linesFromFileInAscii, newlineInAscii1(1));
% locationOfHorizontalTabChar = strfind(linesFromFileInAscii, newlineInAscii1(2));

fileContents = [];
startPos = 1;

for i=1:length(locationOfCarriageReturnChar)
    if(linesFromFileInAscii(locationOfCarriageReturnChar(i)+1) == newlineInAscii1(2))
        fileContents = [fileContents {linesFromFile(startPos:(locationOfCarriageReturnChar(i)-1))}];
        startPos = locationOfCarriageReturnChar(i)+2; % skip over 2 character
    end    
end

fileContents = [fileContents {linesFromFile(startPos:end)}];

% locationOfCarriageReturnChar = strfind(linesFromFileInAscii, newlineInAscii2(1));
% locationOfHorizontalTabChar = strfind(linesFromFileInAscii, newlineInAscii2(2));

lineCount = 0;

for i = 1:length(fileContents)
   if (length(char(fileContents(i))) ~= 0)
        lineCount = lineCount + 1;
        nonEmptyLines(lineCount) = fileContents(i);
   end
end

nonEmptyLinesInAscii = [];

nonEmptyLinesInAscii = uint8(char(nonEmptyLines(1)));

for i = 2:lineCount
    lineToBeAddressed = uint8(char(nonEmptyLines(i)));
    nonEmptyLinesInAscii = [nonEmptyLinesInAscii newlineInAscii1 lineToBeAddressed]; % fit in the newlineInAscii1
end
    
targetFile = 'out.txt';
targetFile = strcat(outputFilesFolder, '\', targetFile);

processStatus = [processStatus, newline, ...
                     datestr(now), ' >> ', 'Writing text file ...'];
 
% write to file
fid = fopen(targetFile, 'w');
fwrite(fid, char(nonEmptyLinesInAscii), '*char');
fclose(fid);

processStatus = [processStatus, newline, ...
                     datestr(now), ' >> ', '[END text outputing].'];
 