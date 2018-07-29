function inplacememory
% INPLACEMEMORY
% Runs code segment 1, which does not use in-place function calling, then
% code segment 2, which does.  Watch the Task Manager on Windows or
% equivalent tools on other platforms as it runs. Pauses are inserted to
% make transitions more visible. For best viewing results, make the page
% file as small as possible (or zero)) and the array as big as possible
% that will fit in RAM (will be much slower if using page file).
%
%   Example:
%   >> inplacememory 

%% Data size
N=100e6; % 100 million bytes

%% Code segment 1
a=zeros(N,1,'uint8'); % Generate int8 arrays so that the size in bytes is the same as the length
pause(5)

b=a*1.2; % Needs an additon 100 million bytes
pause(5)

clear b a
pause(5)

%% Code segment 2
a=zeros(N,1,'uint8'); % Generate int8 arrays so that the size in bytes is the same as the length
pause(5)

a=a*1.2; % No additional memory required
pause(5)