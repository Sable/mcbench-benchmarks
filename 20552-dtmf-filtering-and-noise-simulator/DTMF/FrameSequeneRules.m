function [DialedNum] = FrameSequeneRules(A);

%Computes the most probable dialed number based on design rules
%Input Variables
%           A    = Input Frame Decode Matrix 
%
% Output Variables
%    DialedNum   = Number determined after analyzing a block of frames 

% Checking for minimum number of arguments
if nargin < 1
    error('Not enough input arguments');
end

PossibleNums=cell(1,length(A));
RepeatSequence=[];
t=1;
k=1;

% Check to see what is repeating most number of times other than a pause
% signal
for i=1:(length(A)-1)
    if  strcmp(A(i),A(i+1)) && A(i) ~= 'p'
        k = k+1;    
    else
        t=t+1;
        k = 1;
    end
    
       PossibleNums{t}=A(i);
       RepeatSequence(t)=k;
end

[R,C]=max(RepeatSequence);
DialedNum = PossibleNums{C};
