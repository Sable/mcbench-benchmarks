function timebystride
% TIMEBYSTRIDE
% Calculates and plots the time taken to perform element-wise multiplication
% of a 1D row vector extracted from a 2D array of varying column/stride size.
%
%  Example:
%  >>timebystride

%% Number of interations in inner timing loop.
numIters=10; 

%% Stride sizes to test and defived parameters
arraySize=10000;  % Row size
r=.1;   % Resolution of sizes to test. Reducing to 0.01 takes very long but gives shows all sizes 
strideSizes=[1:1:100 1e2:r*1e2:1e3]'; % Stride sizes to test
numTests=length(strideSizes); % Number of stride sizes to test
results=zeros(numTests,1);    % Preallocate results

%% Run tests
for k=1 :numTests % For each stride size...
    
    strideSize=strideSizes(k);      % Extract current stride size to test
    x=rand(strideSize,arraySize);   % Generate random 1D array of that size
    iterTime=zeros(numIters,1);     % Preallocate and clear array for inner loop results
    
    for iter=1:numIters             % Time operation a number of times (numIters)
        tic
        y=3*x(1,:);                 % Perform operation (scalar multiply of 1D row vector)
        iterTime(iter)=toc;
    end
    
    % Take the median of the multiple times to remove first time costs
    results(k,1)=median(iterTime)/arraySize;
end

%% Plot time versus stride size
semilogx(strideSizes,results);
xlabel('Column/stride size');
ylabel('Time (s)');
title('Time/Element vs. Stride Size for Multiplying a 10k Row Vector');
grid