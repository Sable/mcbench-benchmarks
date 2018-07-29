function [p_win, matrix_p_win] = edca_probability_win(matrix,full)

% Returns the probability that the first station wins the contention
% in the setting of general number of stations with general parameters
%
% matrix............input matrix containing all the required parameters:
%        matrix =   [N10 N1
%                    N20 N2
%                    ...
%                    NK0 NK];
%        for K stations. The first column specifies the corresponding 
%        penalties (AIFS) and the second the range of random numbers,
%        i.e. the contention windows (CW).
%
% full..............Optional parameter. If specified, the final 'matrix_p_win' 
%                   matrix is not truncated (that is, remains redundant). It has no impact 
%                   on the result of calculation, only on the way it is achieved.
%
% p_win.............the probability that the first station wins
% matrix_p_win......the intermediate matrix used to compute 'p_win'
%
%
% Example of use:
%   M = [ 3 10; 5 8; 0 11; 1 2; 1 7; 0 6; 5 2];
%   Mshift = shift_nth_station_to_first(M,7);
%   [p_win, matrix_p_win] = edca_probability_win(Mshift,'whole')


%% Check, Initialization
K = size(matrix,1); %number of stations
% parameters of the stations - vectors
N0 = matrix(:,1); %AIFSs
N  = matrix(:,2); %CW_{min} (range of random numbers, i.e. the contention windows)

% Shortening of the mandatory waiting time for each station (not necessarily
% required, has no impact on the final results).
N0 = N0 - min(N0);

% first station
N10 = N0(1);
N1  = N(1);
% full length, i.e. IFS + contention window
total = N0+N;

if nargin == 1 %i.e. argument 'full' is not present
    % Detection of the number of significant columns (can also be zero)
    a = min(total(2:end));
    if total(1) <= a
        no_cols = N1; %all columns will be taken into account
    else
        b = N10+1; c = a - b;
        no_cols = max([0 c]);
    end
else
    no_cols = N1; %all columns will be taken into account
end

%% Calculation
if no_cols > 0 %if at least one column is valid
    
    matrix_p_win = zeros(K-1,no_cols); %memory allocation for the "matrix of winning"
    
    %Filling in the first column
    for k = 2:K
        %the number of slots of the k-th station, with position
        %higher than (N10+1) and lower than total(k) simultaneously:
        number = N(k) - max(0,N10-N0(k)+1);
        %Saving the result in the matrix
        matrix_p_win(k-1,1) = number;
    end
    
    if no_cols > 1
        %an indicator signalizing if the series has to be decremented or it
        %has to keep the original value
        ict = N0(2:K)-N0(1)-1;
        %         ict = max(0,ict); % if the value is negative it is changed to zero
        for cnt = 2:no_cols
            matrix_p_win(:,cnt) = matrix_p_win(:,cnt-1) - 1*(ict<=0);
            ict = ict-1;
        end
        % to avoid the occurrence of negative numbers in the matrix (it
        % happens only in the situation when some of the columns are insignificant)
        matrix_p_win = max(0,matrix_p_win);
    end
    
    p_win = sum(prod(matrix_p_win)); %the result calculated as the sum of the products
    %divided by the total number of slots of each concurrent
    %station (it can also be calculated within the cycle, but these are then
    %unnecessarily repeated calculations)
    p_win = p_win / prod(N(1:K));
    
else
    p_win = 0; %the station can not win
    matrix_p_win = [];
end
