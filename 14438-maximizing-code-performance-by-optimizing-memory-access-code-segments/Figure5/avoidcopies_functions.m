function result = avoidcopies_functions
% AVOIDCOPIES_FUNCTIONS
% Compares the time of code segment 3, which does not use in-place function calling, to
% the time for code segment 4, which does. It returns a structure with the
% fields:
%
%   timeSegment3= time for code segment 3
%   timeSegment4= time for code segment 4
%   speedUp = timeSegment3/timeSegment4;
%   percentLessTime = 100*(timeSegment3-timeSegment4)/timeSegment3;
%
% The speedUp value is good for characterizing large improvements, whereas
% the percentLessTime is good at characterizing small improvements. Run a
% few times to remove first time costs.
%
%   Example:
%   >> avoidcopies_functions 

%% Call code segments
result.timeSegment3=segment3;
result.timeSegment4=segment4;

%% Calculate performance improvement
% In terms of speed up and percentage less time
result.speedUp=result.timeSegment3/result.timeSegment4;
result.percentLessTime=100*(result.timeSegment3-result.timeSegment4)/result.timeSegment3;

%% Code segment 3
function time=segment3
N=3e3;
x=rand(N);
tic;
y=myfun(x);
time=toc;

function y=myfun(x)
y=1.2*x;

%% Code segment 4
function time=segment4
N=3e3;
x=rand(N);
tic
x=myfun_ip(x);
time=toc;

function x=myfun_ip(x)
x=1.2*x; % In-place