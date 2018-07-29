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



function [lower, upper] = UpperBound3(S, g, df, B, f, Nr, NSim, NSSim, ...
    getpaths, payoff)
% method from Broadie for computing upper bounds, see Chapter 8

iVec = 1:NSSim;

v = g(:,end);   % start for backward induction
c = zeros(NSim,Nr-1);   % continuation value

% backward induction and regression from t_{Nr-1} up to t_1
for i = Nr-1:-1:1
        index = find(g(:,i) > 0); % all ITM paths
        s = S(index,i+1);         % values of S at given time point 
        v = v * df(i+1);          % option value at t_i

        Acell = B(s);             % evaluate basis function in cell array B 
        A = cell2mat(Acell{:,:}); % convert to matrix
    
        c(index,i) = A*f(:,i);                  % continuation value

        exercise = g(index,i) >= c(index,i);    % early exercise
        v(index(exercise)) = g(index(exercise),i);
end

lower = mean(v * df(1));    % final option value

% Computing the martingale numerically, martingale = pi

L = zeros(NSim,1); %erster Teil von delta_i vgl. Formel (6.6)
expectation = zeros(NSim,Nr); %zweiter Teil von delta_i vgl. Formel (6.6)
expectation(:,1) = lower * ones(NSim,1);

for i=1:1:Nr-1
    for j=1:NSim
        expectation(j,i+1) = subsimulation(S(j,i+1), df, B, NSSim, Nr-i,...
            f(:,i:end), iVec(1:NSSim), getpaths, payoff) * prod(df(1:i));
    end      
end

pi = zeros(NSim,Nr+1); % stores the values of the constructed martingale

% first time step and last are different
i_exercise = g(:,1) >= c(:,1) & c(:,1) > 0; % exercise in this case
    
L(i_exercise) = g(i_exercise, 1) * prod(df(1:1));
L(~i_exercise) = expectation(~i_exercise,2);
    
pi(:,2) = pi(:,1) + L - expectation(:,1);

for i=2:1:Nr-1
    % exercise in this case if not already exercised
    i_exercise = g(:,i) >= c(:,i) & c(:,i) > 0 & ~i_exercise; 
    
    L(i_exercise) = g(i_exercise, i) * prod(df(1:i));
    L(~i_exercise) = expectation(~i_exercise,i+1);
    
    pi(:,i+1) = pi(:,i) + L - expectation(:,i);
end
% finally exercise if in the money and not already exercised
i_exercise = g(:,Nr) > 0 & ~i_exercise; 

pi(i_exercise,Nr+1) = pi(i_exercise,Nr) + g(i_exercise,Nr)* prod(df(1:Nr));
pi(~i_exercise,Nr+1) = pi(~i_exercise,Nr);


% upper bound using the martingale pi

maximum = zeros(NSim,1);

for j=1:1:NSim
    maximum(j) = max(g(j,:) - pi(j,2:end)); %vgl. Formel (6.5)
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
