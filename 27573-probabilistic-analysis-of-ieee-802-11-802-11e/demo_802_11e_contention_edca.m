% This file demonstrates the usage of MATLAB files to compute the
% probabilities and implements the results established in the paper:
% Rajmic, Molnar: Optimized Algorithm for Probabilistic Evaluation of
% Enhanced Distributed Coordination Access According to IEEE 802.11e,
% In Proceedings of Telecommunications and Signal Processing TSP'2010,
% August 2010

% (c) 2010-2013 Pavel Rajmic, Karol Molnar, Brno University of Technology


load scenarios

%% First scenario
% using scenario as defined by matrix M1

clc
disp('First scenario:') % Table III in the paper
disp('~~~~~~~~~~~~~~~')
matrix = M1
disp('(each row corresponds to [AIFS CW])')
disp(' ')

K = size(matrix,1); %number of stations
for k = 1 : K
    %reorder the stations
    matrix = shift_nth_station_to_first(matrix,k);
    %compute the probabilities
    [p_win, p_matrix] = edca_probability_win(matrix,'whole');
    %display the results
    disp(['Probability that the station No. ' num2str(k) ' wins:   ' num2str(p_win)])
    disp('...and it has been computed utilizing the following (nontruncated) matrix:')
    p_matrix
end
disp(['Finally, the probability of collision is:'])
p_coll = edca_probability_collision(matrix)



%% Pause
disp(['~Press a key to present the second scenario in a similar way...'])
pause




%% Second scenario
% using scenario as defined by matrix M2

clc
disp('Second scenario:') % Table IV in the paper
disp('~~~~~~~~~~~~~~~')
matrix = M2
disp('(each row corresponds to [AIFS CW])')
disp(' ')

K = size(matrix,1); %number of stations
for k = 1 : K
    %reorder the stations
    matrix = shift_nth_station_to_first(matrix,k);
    %compute the probabilities
    [p_win, p_matrix] = edca_probability_win(matrix,'whole');
    %display the results
    disp(['Probability that the station No. ' num2str(k) ' wins:   ' num2str(p_win)])
    disp('...and it has been computed utilizing the following (nontruncated) matrix:')
    p_matrix
end
disp(['Finally, the probability of collision is:'])
p_coll = edca_probability_collision(matrix)