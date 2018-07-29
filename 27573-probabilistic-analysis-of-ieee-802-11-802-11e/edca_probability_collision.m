function [p_coll] = edca_probability_collision(matrix)

% Returns the probability of collision for a general number of stations with general parameters
%
% matrix.............input matrix containing all the required parameters:
%        matrix =   [N10 N1
%                    N20 N2
%                    ...
%                    NK0 NK];
%        for K stations. The first column specifies the corresponding 
%        penalties (i.e. AIFS) and the second the range of random numbers
%        (i.e. the contention window CW).
%
% p_coll............probability that a collision occurs
%
% Example of use:
%   M = [ 3 10; 5 8; 0 11; 1 2; 1 7; 0 6; 5 2];
%   [p_coll] = edca_probability_collision(M)


%% Initialization
K = size(matrix,1); %number of stations
total = 0;

%% Collision
% Calculates the complementary probability (such a way is not very efficient),
% i.e. "1-(probability that any of the stations wins)".
% It means that the winning probability is calculated K-times,
% once for each of the K stations.

for cnt = 0:(K-1) %loop over the stations
    % The probability that wins the first, second,..., K-th station:
    p_win = edca_probability_win(shift_nth_station_to_first(matrix,cnt+1));
    % Their sum
    total = total + p_win;
end

% Complementary probability
p_coll = 1 - total;