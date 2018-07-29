function test

%Some data to shared
Data = round(10* rand(2000));

%standard non-parrellel version
if ~matlabpool('size')
    matlabpool('open', 'local');
end

%Create a list of function to perform on the matrix
funlist = {@(x)sum(x(:))};  % a simple function to highlist the comunications overhead
funlist = repmat(funlist, 1, matlabpool('size'));

%standard approach, a full copy of Data on all processes
tic;
parfor i = 1:numel(funlist)
    result(i) = feval(funlist{i}, Data);
end
toc  %Elapsed time is 2.748853 seconds
drawnow

%using shared version
tic;
SharedMemory('clone', 'shared_mem', Data);               %place a copy of data in global memory
parfor i = 1:numel(funlist)
    Data_Shared = SharedMemory('attach', 'shared_mem');  %create a shallow copy of data from the global memory
    result(i) = feval(funlist{i}, Data_Shared);
    SharedMemory('detach', 'shared_mem', Data_Shared);   %detach the shallow copy making Data_Shared safe for Matlab to clear
    SharedMemory('free', 'shared_mem');                  %release the global memory from this process (perform after the detach)
end
SharedMemory('free', 'shared_mem');                      %The shared memory is now detached from all processes and will be delete
toc  %Elapsed time is 1.399766 seconds.
     



