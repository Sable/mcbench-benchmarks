function result=preallocate
% PREALLOCATE
% Compares the time of code segment 1, which does not use preallocation, to
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
%   >> preallocate

%% Call code segments
result.timeSegment1=segment1;
result.timeSegment2=segment2;

%% Calculate performance improvement
% In terms of speed up and percentage less time
result.speedUp=result.timeSegment1/result.timeSegment2;
result.percentLessTime=100*(result.timeSegment1-result.timeSegment2)/result.timeSegment1;

%% Code segment 1
function time=segment1
N=10e3;
tic;  
x(1)=1000;
for k=2:N
    x(k)=1.05*x(k-1);
end
time=toc;  

%% Code segment 2
function time=segment2
N=10e3; 
tic;     
x=zeros(N,1); % Preallocate
x(1)=1000;
for k=2:N
    x(k)=1.05*x(k-1);
end
time=toc;   