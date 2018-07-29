function result = avoidcopies_operators
% AVOIDCOPIES_OPERATORS
% Compares the time of code segment 1, which does not use in-place function calling, to
% the time for code segment 2, which does. It returns a structure with the
% fields:
%
%   timeSegment1= time for code segment 1
%   timeSegment2= time for code segment 2
%   speedUp = timeSegment1/timeSegment2;
%   percentLessTime = 100*(timeSegment1-timeSegment2)/timeSegment1;
%
% The speedUp value is good for characterizing large improvements, whereas
% the percentLessTime is good at characterizing small improvements. Run a
% few times to remove first time costs.
%
%   Example:
%   >> avoidcopies_operators 

%% Call code segments
result.timeSegment1=segment1;
result.timeSegment2=segment2;

%% Calculate performance improvement
% In terms of speed up and percentage less time
result.speedUp=result.timeSegment1/result.timeSegment2;
result.percentLessTime=100*(result.timeSegment1-result.timeSegment2)/result.timeSegment1;

%% Code segment 1
function time=segment1
N=3e3;
x=rand(N);
tic;
y=x*1.2;
time=toc;

%% Code segment 2
function time=segment2
N=3e3;
x=rand(N);
tic
x=x*1.2; % In-place
time=toc;