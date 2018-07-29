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



function [price_pi, se, conflevel_low, conflevel_high] = ...
    PIter_E(S, g, K, r, T, sigma, Nr, NSim, NSSim, type, getpaths, payoff)
% policy iteration using European options

% S: Path set
% K: Strike for analytic pricing
% r: riskless rate for analytic pricing
% T: Laufzeit der Option in Jahren
% sigma: volatility for analytic pricing 
% NSim: number of simulations
% NSSim: number of simulations for sub-simulation
% type: 0 -> put, 1 -> call

dt = T/Nr;              % equidistant spacing
tau = Nr*ones(NSim,1);  % exercise rule for each path
iVec = (1:NSim)';       % index vector
for i = 1:Nr-1               
    i_nexercise = tau == Nr;        % only ex if not already done
    % paths (realisation) where the stopping rule needs improvement
    I_nexercise = iVec(i_nexercise);    
    
    price = BlackScholesPrice(S(i_nexercise,i+1), K, r, (1:Nr-i)'*dt,...
        sigma, type);                      % analytic price
    exbound = max(price,[],2);             % ex decision  
    isubsim = g(i_nexercise,i) >= exbound; % index set indicating subsim
    
    if sum(I_nexercise(isubsim)) ~= 0       % if necessary      
        Indicator = subsimulation(S(I_nexercise(isubsim),i+1), K, r, sigma, ...
            dt, NSSim, Nr-i, type,getpaths, payoff); % subsim
        
        Ind = iVec(I_nexercise(isubsim)); % index: payoff >= current rule 
        % exercised befor this time? Use Indicator
        ind2 = g(I_nexercise(isubsim),i) >= Indicator; % ind: at ind2 and q
        Ind2 = iVec(ind2);                              % ind set for ind2
        if sum(ind2) ~= 0
            tau(Ind(Ind2)) = i; % final exercise
        end
    end 
end

f = zeros(NSim,1); % sum payoffs for exercise times
for j = 1:NSim
    f(j) = g(j,tau(j));
end
price_pi = mean(f .* exp(-r*dt*tau));

sv = sqrt(1/(NSim-1)*sum((f*100 - price_pi * ones(NSim,1)).^2));
se = sv/sqrt(NSim);
conflevel_low = price_pi - 1.96 * sv/sqrt(NSim);
conflevel_high = price_pi + 1.96 * sv/sqrt(NSim);

end


function [price_local] = subsimulation(S, K, r, sigma, dt, NSim, Nr, type, getpaths, payoff) 
    lenS = length(S);           % length of the path set S
    iVec = (1:NSim)';           % index set
    S2 = getpaths(S,NSim,Nr);   % new path set
    g2 = payoff(S2(:,2:end,:)); % evaluate option on path set S2
    
    price_local = zeros(lenS, 1);
    
    for k = 1:lenS 
        payoff = zeros(NSim, Nr);
        for i=1:1:Nr-1 
            for z=i:1:Nr-1
                i_nexercise = payoff(:,i) == 0; % check if exercised
                I_nexercise = iVec(i_nexercise); 
                
                price = BlackScholesPrice(S2(I_nexercise,z,k),K,r, ... 
                    (1:Nr-z)'*dt,sigma,type);       % analytic price
                exbound=max(price,[],2);            % bound for exercise
                
                exercise = g2(i_nexercise,z,k) >= exbound; % exercise
                payoff(I_nexercise(exercise),i) = ...
                    g2(I_nexercise(exercise),z,k) * exp(-r*dt*z);

            end

            finalexercise = payoff(:,i) == 0;   % finally not exercised
            payoff(finalexercise,i) = g2(finalexercise,Nr,k) ...
                * exp(-r*dt*Nr);                % final exercise

        end
        payoff(:,Nr) = g2(:,Nr,k) * exp(-r*dt*Nr);
        price_local(k) = max(mean(payoff));
    end

end
