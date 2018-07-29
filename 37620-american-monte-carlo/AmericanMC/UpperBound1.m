% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function [lower, upper] = ...
    UpperBound1(S, g, df, B, beta, lower, Nr, NSim, NSSim, ...
    getpaths, payoff)
% method from Broadie see Chapter 8

v = g(:, end);          % option value at maturity
c = zeros(NSim,Nr-1);   % continuation value

stoppingtime = Nr * ones(NSim,1);

 for i=Nr-1:-1:1
         index = find(g(:,i)>0);         
         s = S(index, i+1);
         v = v * df(i+1);
         
         Acell = B(s);
         A = cell2mat(Acell{:,:});         
         c(index,i) = A*beta(:,i);                % cont value itm paths
        
         earlyexercise = g(index,i) >= c(index,i);% exercise
         stoppingtime(index(earlyexercise)) = i;
         v(index(earlyexercise)) = g(index(earlyexercise),i);
 end

% Computing the martingale pi

L = zeros(NSim,1); 
expectation = zeros(NSim,Nr); 
expectation(:,1) = lower * ones(NSim,1);

pi = zeros(NSim,Nr+1);                  % martingale
pi(:,1) = lower * ones(NSim,1);         % set pi(0)

% perform the subsimulation for each value of the path set
for i=1:1:Nr-1
    for j=1:NSim
        expectation(j,i+1) = subsimulation(S(j,i+1), df, B, NSSim, Nr-i,...
            beta(:,i:end), getpaths, payoff) * prod(df(1:i));
    end
end

for i=1:1:Nr
    i_exercise = stoppingtime == i;     % check if early exercised
    
    if i < Nr
        L(i_exercise) = g(i_exercise, i) * prod(df(1:i));
        L(~i_exercise) = expectation(~i_exercise,i+1); 
    else
        L(i_exercise) = g(i_exercise, i) * prod(df(1:i));
    end
    
    
    pi(:,i+1) = pi(:,i) + L - expectation(:,i);
end


maximum = zeros(NSim,1);

for j=1:1:NSim
    maximum(j) = L(j) + max(g(j,:) - pi(j,2:end)); % compute the max
end
upper = mean(maximum);

end 

function y = subsimulation(S0, df, B, NSim, Nr, beta, gp,payoff)
    S2 = gp(S0,NSim,Nr); S2 = S2(:,2:end);   % paths
    g2 = payoff(S2);                         % payoff
    iVec = 1:NSim;
    
    exercise = Nr * ones(NSim,1);            % exercise per path
    % determine exercise strategy for path set S2
    for i=1:1:Nr-1  
        i_nexercised = exercise == Nr;
        I_nexercise = iVec(i_nexercised);
    
        s = S2(i_nexercised,i);
        Acell = B(s);
        A = cell2mat(Acell{:,:});
        c = A * beta(:,i);
                
        i_exercise = g2(i_nexercised,i) >= c & g2(i_nexercised,i) > 0;
        exercise(I_nexercise(i_exercise)) = i;    
    end
    summe=0;
    for j=1:1:NSim
        summe = summe + g2(j,exercise(j)) * prod(df(1:exercise(j)));
    end
    y = summe / NSim;                         % MC value from subsimulation
end
