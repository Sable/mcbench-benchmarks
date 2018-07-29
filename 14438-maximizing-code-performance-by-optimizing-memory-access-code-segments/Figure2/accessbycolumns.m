function result=accessbycolumns
% ACCESSBYCOLUMNS
% Compares the time of code segment 1, which access a 2D array data by
% rows, to the time for code segment 2, which access a 2D array data by
% columns. It returns a structure with the two fields:
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
%   >> accessbycolumns

%% Call code segments
result.timeSegment1=segment1;
result.timeSegment2=segment2;

%% Calculate performance improvement
% In terms of speed up and percentage less time
result.speedUp=result.timeSegment1/result.timeSegment2;
result.percentLessTime=100*(result.timeSegment1-result.timeSegment2)/result.timeSegment1;

%% Code segment 1
function time=segment1
N=2e3;
x = randn(N);
y = zeros(N);
tic
for r = 1:N % Row 
    for c = 1:N % Column 
        if x(r, c)>= 0     
            y(r,c)=x(r, c);
        end
    end
end
time=toc;

%% Code segment 2
function time=segment2
N=2e3;
x = randn(N);
y = zeros(N);

tic;
for c = 1:N % Column
    for r = 1:N % Row 
        if x(r, c)>= 0     
            y(r,c)=x(r, c); 
        end
    end
end
time=toc;