function [freq_coll, freq_win] = edca_simulation(matrix, count)

% In a situation with K stations with arbitrary parameters AIFS and CW,
% the function simulates the contentions and outputs the empirical:
%   - frequency of collision
%   - frequency of winning the contention by particular stations.
%
% matrix.............input matrix determining the contention:
%        matrix =   [N10 N1
%                    N20 N2
%                    ...
%                    NK0 NK];
%        The first column being the penalty (AIFS), the second column being 
%        the range of randomnes (CW)
% count..............how many simulation rounds to be run
%                    (optional), deafult is 10e5
%
% freq_coll.......empirical frequencies of the collision
% freq_win........empirical frequencies of the winning

% (c) 2010-2013 Pavel Rajmic, Brno University of Technology, Czech Republic


%% Check, Initialization
if nargin < 2
    count = 10e5;           %number of simulations
end

K = size(matrix,1);
C = zeros(count,K);     %memory allocation for all trials
coll = 0;
win = zeros(1,K);


%% Generating random numbers
for cnt = 1:K
    penalty = matrix(cnt,1);
    range = matrix(cnt,2);
    C(:,cnt) = randint(1,range,count);  %columns...trials for particular stations
    C(:,cnt) = C(:,cnt) + penalty;      %adding AIFS
end
clear penalty


%% Collision and winning counts
for cnt = 1:count
    [tmp, idx] = sort(C(cnt,:));    %taking rows one after another and sorting
    if ( tmp(1) == tmp(2) )  %are the first two numbers in the sequence the same?
        coll = coll + 1; %collision occurs
    else %a station won
        win(idx(1)) = win(idx(1)) + 1;
    end
end

freq_coll = coll / count;
freq_win = win / count;
