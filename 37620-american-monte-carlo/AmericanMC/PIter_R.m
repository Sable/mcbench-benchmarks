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



function [price_pi, se, conflevel_low, conflevel_high] ...
    = PIter_R(S, g, r, T, Nr, B, Nb, NSim, NSSim, getpaths, payoff)
% Policy Iteration using regression

% S: Path set
% K: Strike for analytic pricing
% r: riskless rate for analytic pricing
% T: Laufzeit der Option in Jahren
% sigma: volatility for analytic pricing 
% NSim: number of simulations
% NSSim: number of simulations for sub-simulation
% type: 0 -> put, 1 -> call

dt = T/Nr;              % equidistant spacing

v = g(:, end);          % option value at maturity
beta = zeros(Nb, Nr-1); % coefficients for regression
c = zeros(NSim,Nr-1);   % continuation value

for i=Nr-1:-1:1
        index = find(g(:,i)>0);
        
        s = S(index,i+1);
        v = v * exp(-r*dt*i);
        
        Acell = B(s);
        A = cell2mat(Acell{:,:});
        
        beta(:,i) = inv(A'*A)*A'*v(index);  % calc coeffs
        c(index,i) = A*beta(:,i);           % continuation value itm paths
        
        earlyexercise = g(index,i) >= c(index,i);           % exercise
        v(index(earlyexercise)) = g(index(earlyexercise),i);% opt value
end

tau = Nr*ones(NSim,1);      % exercise rule for each path
iVec = (1:NSim)';           % index vector

for i = 1:Nr-1               
    i_nexercise = tau == Nr; % only exercise if not already done
    % paths (realisation) where the stopping rule needs improvement
    I_nexercise = iVec(i_nexercise);    
    
    s = S(I_nexercise,i+1);
    Acell = B(s);
    A = cell2mat(Acell{:,:});
    price = A * beta(:,i);
    exbound = max(price,[],2);              % ex decision  
    isubsim = g(i_nexercise,i) >= exbound;  % ind set indicating subsim
    
    if sum(I_nexercise(isubsim)) ~= 0       % subsim necssary     
        Indicator = subsimulation(S(I_nexercise(isubsim),i+1), r, beta, B, ...
            dt, NSSim, Nr-i,getpaths, payoff);  % subsim
        
        Ind = iVec(I_nexercise(isubsim));       % payoff >= current rule 
        % exercised befor this time? Use Indicator
        ind2 = g(I_nexercise(isubsim),i) >= Indicator; % ind: at ind2 and q
        Ind2 = iVec(ind2);                      % index set ind2
        if sum(ind2) ~= 0
            tau(Ind(Ind2)) = i;                 % final exercise
        end
    end 
end

f = zeros(NSim,1);          
for j = 1:NSim
    f(j) = g(j,tau(j));                         % sum payoffs 
end

price_pi = mean(f .* exp(-r*dt*tau));

% standard error and confidence level
sv = sqrt(1/(NSim-1)*sum((f*100 - price_pi * ones(NSim,1)).^2));
se = sv/sqrt(NSim);
conflevel_low = price_pi - 1.96 * sv/sqrt(NSim);
conflevel_high = price_pi + 1.96 * sv/sqrt(NSim);

end

function [price_local] = subsimulation(S, r, beta, B, dt, NSim, Nr, getpaths, payoff) 

    lenS = length(S); % Länge von S
    iVec = (1:NSim)'; % Hilfsvektor zur Indexbestimmung
    S2 = getpaths(S,NSim,Nr);
    
    S2 = S2(:,2:end,:); %Aktienwerte der Subsimulation ohne den Startwert S
    g2 = payoff(S2);
    
    price_local = zeros(lenS, 1);
    for k = 1:lenS %Schleife über versch. Startwerte
        payoff = zeros(NSim, Nr);
        for i=1:1:Nr-1 %Schleife über die Restlaufzeit der Option
            for z=i:1:Nr-1 %Schleife für tau(i)
                %nur ausüben wenn zuvor noch nicht ausgeübt wurde
                i_nexercise = payoff(:,i) == 0; 
                %Index für Zufallspfade deren Stoppzeitp. nicht gefunden ist
                I_nexercise = iVec(i_nexercise); 
                  
                s = S2(i_nexercise,i);
                Acell = B(s);
                A = cell2mat(Acell{:,:});              
                price = max(A * beta(:,i),0);
                
                exbound=max(price,[],2);            % europ. exbound
                
                exercise = g2(i_nexercise,z,k) >= exbound; % exercise
                payoff(I_nexercise(exercise),i) = ...
                    g2(I_nexercise(exercise),z,k) * exp(-r*dt*z);

            end

            finalexercise = payoff(:,i) == 0; % finally not exercised
            % final exercise
            payoff(finalexercise,i) = g2(finalexercise,Nr,k) * exp(-r*dt*Nr); 

        end

        payoff(:,Nr) = g2(:,Nr,k) * exp(-r*dt*Nr);
        price_local(k) = max(mean(payoff));

    end

end



