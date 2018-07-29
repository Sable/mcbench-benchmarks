function runs = contiguous(A,varargin)
%   RUNS = CONTIGUOUS(A,NUM) returns the start and stop indices for contiguous 
%   runs of the elements NUM within vector A.  A and NUM can be vectors of 
%   integers or characters.  Output RUNS is a 2-column cell array where the ith 
%   row of the first column contains the ith value from vector NUM and the ith 
%   row of the second column contains a matrix of start and stop indices for runs 
%   of the ith value from vector NUM.    These matrices have the following form:
%  
%   [startRun1  stopRun1]
%   [startRun2  stopRun2]
%   [   ...        ...  ]
%   [startRunN  stopRunN]
%
%   Example:  Find the runs of '0' and '2' in vector A, where
%             A = [0 0 0 1 1 2 2 2 0 2 2 1 0 0];  
%    
%   runs = contiguous(A,[0 2])
%   runs = 
%           [0]    [3x2 double]
%           [2]    [2x2 double]
%
%   The start/stop indices for the runs of '0' are given by runs{1,2}:
%
%           1     3
%           9     9
%          13    14
%
%   RUNS = CONTIGUOUS(A) with only one input returns the start and stop
%   indices for runs of all unique elements contained in A.
%
%   CONTIGUOUS is intended for use with vectors of integers or characters, and 
%   is probably not appropriate for floating point values.  You decide.  
%

if prod(size(A)) ~= length(A),
    error('A must be a vector.')
end

if isempty(varargin),
    num = unique(A);
else
    num = varargin{1};
    if prod(size(num)) ~= length(num),
        error('NUM must be a scalar or vector.')
    end
end

for numCount = 1:length(num),
    
    indexVect = find(A(:) == num(numCount));
    shiftVect = [indexVect(2:end);indexVect(end)];
    diffVect = shiftVect - indexVect;
    
    % The location of a non-one is the last element of the run:
    transitions = (find(diffVect ~= 1));
    
    runEnd = indexVect(transitions);
    runStart = [indexVect(1);indexVect(transitions(1:end-1)+1)];
    
    runs{numCount,1} = num(numCount);
    runs{numCount,2} = [runStart runEnd];
    
end
