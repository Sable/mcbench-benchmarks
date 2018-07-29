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
    UpperBound2(S, g, df, B, Nb, Nr, NSim, NSSim, getpaths, payoff)
% method from Glasserman see Chapter 8

v = g(:, end);              % option value at maturity
beta = zeros(Nb, Nr-1);     % Regressionskoeffizienten
c = zeros(NSim,Nr-1);       % continuation value

iVec = 1:NSSim;

for i=Nr-1:-1:1
        index = find(g(:,i)>0);
        
        s = S(index,i+1);
        v = v * df(i+1);
        
        Acell = B(s);
        A = cell2mat(Acell{:,:});
        
        beta(:,i) = inv(A'*A)*A'*v(index);
        c(index,i) = A*beta(:,i);           % continuation value itm paths
        
        earlyexercise = g(index,i) >= c(index,i); %vorzeitig ausüben
        v(index(earlyexercise)) = g(index(earlyexercise),i);
end
lower = mean(v * df(1)); % lower bound using LongStaff Schwarz

% Computing the martingale numerically, martingale = pi

L = zeros(NSim,1); %erster Teil von delta_i vgl. Formel (6.6)
expectation = zeros(NSim,Nr); %zweiter Teil von delta_i vgl. Formel (6.6)
expectation(:,1) = lower * ones(NSim,1);

for i=1:1:Nr-1
    for j=1:1:NSim
        expectation(j,i+1) = subsimulation(S(j,i+1), df, B, NSSim, Nr-i,...
            beta(:,i:end), iVec(1:NSSim), getpaths, payoff) * prod(df(1:i));
    end      
end

pi = zeros(NSim,Nr+1); % stores the values of the constructed martingale

for i=1:1:Nr-1
    % exercise in this case if not already exercised
    i_exercise = g(:,i) >= c(:,i) & c(:,i) > 0;
    i_nexercise = ~i_exercise; 
    L(i_exercise) = g(i_exercise, i) * prod(df(1:i));
    L(i_nexercise) = expectation(i_nexercise,i+1);
    
    pi(:,i+1) = pi(:,i) + L - expectation(:,i);
end
pi(:,Nr+1) = pi(:,Nr) + g(:,Nr)* prod(df(1:Nr)) - expectation(:,Nr);


% upper bound using the martingale pi

maximum = zeros(NSim,1);

for j=1:1:NSim
    maximum(j) = max(g(j,:) - pi(j,2:end)); % compute max
end
upper = mean(maximum);

end 

function y = subsimulation(S0, df, B, NSim, Nr, beta, iVec, gp,payoff)

S2 = gp(S0,NSim,Nr); S2 = S2(:,2:end);   % paths
g2 = payoff(S2);                         % payoff
 
exercise = Nr * ones(NSim,1);            % exercise per path
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