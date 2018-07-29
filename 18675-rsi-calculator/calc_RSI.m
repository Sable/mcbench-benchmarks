function RSI = calc_RSI(data, N)
% CALC_RSI      Calculate RSI indicator given stock price vector
%   RSI = calc_RSI(data, N) calculates the Relative Strength Index (RSI)
%   for the stock price vector, data, over a period of N trading days.
%   Typically the vector 'data' is a list of sequential closing prices for
%   a stock.
%
%   RSI = calc_RSI(data) uses the default period of 14 trading days in
%   calculating the RSI.
%
%   EXAMPLES
%       RSI = calc_RSI(stock,20);
%           Returns the RSI for the data in the vector 'stock' over a
%           period of 20 days.
%
%       RSI = calc_RSI(stock);
%           Returns the RSI for the data in the vector 'stock' using the
%           default period of 14.
%
%   DATA FORMAT
%       data - The vector 'data' must be a numerical vector containing
%           stock prices over consecutive days.  The first and oldest stock
%           price must be located in the first sample (data(1)), while the
%           last and newest stock price is at the end of the array
%           (data(end)).
%
%       N - N is a numerical number specifying the number of samples to use
%           for each period.  The default value is 14.
%
%       RSI - RSI is a vector returned by the program that contains the RSI
%           values calculated by the function.  The first RSI value is
%           calculated using the first N samples.  Therefore, the returned
%           RSI vector is not the same length as the data vector, but will
%           instead have length(data)-N samples.  The last sample in the
%           RSI vector (RSI(end)) corresponds to the RSI value for the most
%           recent date.

% Created by Josiah Renfree
% February 8, 2008

% If no data is passed to the function, give error
if nargin == 0
    error('Please provide a vector of stock prices')    % error prompt
end

% If only one variable is passed, set default period to 14
if nargin == 1
    N = 14;                         % set default period
end

RSI = zeros(1,length(data) - N);    % intialize RSI vector 
Adva = zeros(1,N);                  % initialize positive gain vector
Decl = zeros(1,N);                  % intiialize negative gain vector

% Use the first N samples to calculate the intitial RSI value
for i = 1:N
    chg = data(i+1) - data(i);      % find difference between days

    if chg >= 0                     % if positive change, it advanced
        Adva(i) = chg;              % save to variable
    else                            % if negative change, it declined
        Decl(i) = abs(chg);         % save to variable
    end     
end

AvgGain = mean(Adva);               % take mean of all price increases
AvgLoss = mean(Decl);               % take mean of all price decreases

if AvgLoss == 0                     % if average loss is 0, RSI is 100
    RSI(1) = 100;                   % set RSI to 100
else
    RS = AvgGain / AvgLoss;         % calculate RS value
    RSI(1) = 100 - (100/(1+RS));    % calculate intitial RSI value
end
clear Adva Decl                     % clear variables

% Now cycle through the rest of the data using the initial RSI value to
% calculate the remaining RSI values.
for i = 1+N:length(data)-1
    chg = data(i+1) - data(i);      % calculate change between days
    
    if chg >= 0                     % if positive change, it advanced
        Adva = chg;                 % assign change to advance variable
        Decl = 0;                   % set declined variable to 0
    else                            % if negative change, it declined
        Decl = abs(chg);            % assign change to declined variable
        Adva = 0;                   % set advanced variable to 0
    end

    AvgGain = ((AvgGain*(N-1))+Adva)/N;   % calculate next average gain
    AvgLoss = ((AvgLoss*(N-1))+Decl)/N;   % calculate next average loss
    
    if AvgLoss == 0                 % if average loss is 0, RSI = 100
        RSI(i-N) = 100;             % set RSI to 100
    else
        RS = AvgGain / AvgLoss;     % calculate RS
        RSI(i+1-N) = 100 - (100/(1+RS));    % calculate latest RSI
    end
end