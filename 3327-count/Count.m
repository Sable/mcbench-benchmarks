function Result = Count(data,condition)

% COUNT (A,B)
% 
% Counts the number of elements in A that match the criteria specified in B.
% 
% Example:
% 
% Data = [1 2 3 4 3 2 7 6 9 1 1 2 5 9 9];
% 
% Count(Data,'==9')
% 
% ans =
% 
%      3
%
% Richard Medlock, 2001.

nElements = length(data);
IndexIDs = 1:nElements;
Result = eval(['data' condition]);
Result = IndexIDs(Result);
Result = length(Result);