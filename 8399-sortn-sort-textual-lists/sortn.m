function [sortedArr,finalIndex] = sortn(orgArr)

% SORTN - Sort cell array or char array in textual and numerical mode.
%               Primary sort by first letter, secondary by second letter and so on.
%               Numbers are considered an numerical values.
%               
%               Sorting Rules:
%                           'a' comes before 'b' and so on.
%                           Numbers come before letters
%                           Numbers are compared according to their value
%                           Short string comes before a long one (when first chars are identical) 
%                           Ignore characters that are not letters or
%                           numbers.
%                           SORTN is NOT case sensitive.
%
%               The main interest in this function is that it can sort
%               numbers with text, so string like 'a60' comes before 'a100'
%
%[SORTED_CELL_ARRAY , INDEXES] = SORTN(CELL_ARRAY) - Sorts the cells array
%                or char array and returns sorted cell array and indexes
%                vector of new arranged cell array.
%
%EXAMPLE:
%               cell_arr = {'abcde54f';
%                                       'aabde54f'}
%
%              [sorted,indexes]=sortn(cell_arr)
%
%               sorted = 
%                                   'aabde54f'
%                                   'abcde54f'
%               indexes = 
%                                       2
%                                       1                          
%
%
%
%               cell_arr = {'abcde154f';
%                                       'abcde54f'}
%
%              [sorted,indexes]=sortn(cell_arr)
%
%               sorted = 
%
%                                   'abcde54f'
%                                   'abcde154f'
%               indexes =
%
%                                   2
%                                   1    
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if ischar(orgArr)   %function works with cell array, so if char input, convert to cell array
    tempList = lower(orgArr);
    orgArr = cellstr(orgArr);
else
    tempList = char(lower(orgArr));
end

finalIndex = (1:length(orgArr))';   %create the index vector to be changed
g = {};
for i=1:size(tempList)  %go over all strings and break each one to single letters and numbers
    tempCellArr = breakString(tempList(i,:));   %break one string from the cell array
    g = AssignCellArray(tempCellArr, g);    %add the breaked string to cell matrix
end
%[g,indexes] = SortByColumn2(g,5);
for i=size(g,2):-1:1    %go over cell matrix of breaked strings and sort is from last column to the first

    [g,indexes] = SortByColumn(g,i);    %sort the i column
    
    orgArr = orgArr(indexes);   %update cell array order by the indexes
    finalIndex = finalIndex(indexes);   %update final index order
    
end

sortedArr =orgArr ;


function [sortedArr,indexes] = SortByColumn(arr,column);    
%this function sort each column of the breaked cell-matrix
%sorting is done by converting each textual number to its real value
%and later assign every letter its ascii value plus the maximum of all
%numbers. 
%the sorting is pure numeric (Matlab sort) so numbers are always before
%letters.

tempColumn = zeros(size(arr,1),1);
for i=1:length(tempColumn)
    if ~isempty(str2num(char(arr(i,column)))); %finds all numbers including non-real numbers
        tempColumn(i) = str2num(char(arr(i,column)))+1; %assign numbers to the vactor
    end
end
maxNum = max(tempColumn);
u2 = isletter(char(arr(:,column))); %find all letters
tempColumn(u2) = char(arr(u2,column)) + maxNum; %assign numerical representation of letters that is bigger then the numbers

[tempSort,indexes] = sort(tempColumn);
sortedArr = arr(indexes,:);



function newArr = AssignCellArray(assignmentVector, assignTo)
%this function helps adding cell-arrays to the breaked strings cell-matrix


assignToSize = size(assignTo,2);
assignmentVectorSize = length(assignmentVector);
if assignToSize==0
    newArr = assignmentVector;
    
elseif (assignToSize==assignmentVectorSize)
    newArr = [assignTo;assignmentVector];
elseif (assignToSize>assignmentVectorSize)
    assignmentVector((assignmentVectorSize+1):assignToSize)={' '};
    newArr = [assignTo;assignmentVector];
else
    assignTo(:,(assignToSize+1):assignmentVectorSize)={' '};
    newArr = [assignTo;assignmentVector];
end


function groups = breakString(stringToBreak)
%this function breaks a string to its single letters and numbers,
%producing cell array for a single string.

if ~ischar(stringToBreak)   %convert to char array
    tempString = char(stringToBreak);
else
    tempString=stringToBreak;
end
counter = 1;
i=1;
groups = {};
while i<=length(tempString) %go over all chars in the string
    if  ~isletter(tempString(i)) & isempty(str2num(tempString(i)))   %tempString(i)==' '   %Skip spaces
        i=i+1;
        continue;
    end
    if isempty(str2num(tempString(i)))  %in case of a letter - just add it to the array
        groups(counter)={tempString(i)};
        counter = counter + 1;
        i = i + 1;
    else
        groups(counter) = {tempString(i)};
        i = i+1;
        while (i<=length(tempString) & ~isempty(str2num(tempString(i))))    %in case of number,
            %add it to the array and search for following numbers
            groups(counter)={[char(groups(counter)) tempString(i)]};
            i = i + 1;
        end
        counter = counter + 1;
    end
end