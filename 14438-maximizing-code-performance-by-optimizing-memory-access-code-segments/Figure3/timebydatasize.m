function timebydatasize
% TIMEBYDATASIZE
% Calculates and plots the time taken to perform element-wise multiplication
% of a 1D array, by array size.
%
%  Example:
%  >>timebydatasize

%% Number of interations in inner timing loop.
numIters=10; 

%% Data sizes to test and defived parameters
r=.1; % Resolution of data sizes to test. Reducing to 0.01 takes longer but gives more detail.
arraySizes=[1:1:100 1e2:r*1e2:9e2 1e3:r*1e3:9e3 1e4:r*1e4:9e4  1e5:r*1e5:9e5 ]'; % Arrays sizes to test
numTests=length(arraySizes); % Number of array sizes to test
results=zeros(numTests,1);   % Preallocate results

%% Run tests
for k=1 :numTests % For each array size...
    
    arraySize=arraySizes(k);        % Extract current array size to test
    x=rand(arraySize,1);            % Generate random 1D array of that size
    iterTimes=zeros(numIters,1);    % Preallocate and clear array for inner loop results
    
    for iter=1:numIters             % Time operation a number of times (numIters)
        tic
        y=3*x;                      % Perform operation (scalar multiply of 1D vector)
        iterTimes(iter)=toc;
    end
    
    % Take the median of the multiple times to remove first time costs
    results(k,1)=median(iterTimes)/arraySize;
end

%% Plot time versus data size
loglog(arraySizes,results);
xlabel('Array Size');
ylabel('Time (s)');
title('Time/Element vs. No. of Elements for .*');
grid