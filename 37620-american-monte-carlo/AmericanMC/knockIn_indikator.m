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



function [optionspreis] = knockIn_indikator(S0, K, r, T, sigma, n, M, Barriere, type)
%Bachelorarbeit: Möglichkeit 3
%versuch die regression auf alle zufallspfade zu beziehen mit einer
%indikatorfunktion für das überschreiten der barriere als basisfunktion

% S0: spot value
% K: strike
% r: risk free rate
% T: maturity
% sigma: volatility
% n: number exercise opportunities
% M: number of simulations
% Barriere: barrier level
% type: 0 for a put, 1 for a call

S0 = S0 / 100;
K = K / 100;
Barriere = Barriere / 100;
dt = T/n; %Intervalllänge

% S is the random path
R = exp((r - sigma^2 / 2) * dt + sigma * sqrt(dt) * randn(M,n));
S = cumprod([S0 * ones(M,1), R], 2);

% minimum/maximum für Payoff, g: Payoff, v: Optionswert
if type==0
    minimum = zeros(M,n+1);
    for i=1:n+1
        minimum(:,i) = min(S(:,1:i), [], 2);
    end
    ind = minimum <= Barriere;
    g = max(K - S, 0) .* ind;
    v = max(K - S(:, end), 0) .* ind(:,end);
else
    maximum = zeros(M,n+1);
    for i=1:n+1
        maximum(:,i) = max(S(:,1:i), [], 2);
    end
    ind = maximum >= Barriere;
    g = max(S - K, 0) .* ind;
    v = max(S(:, end) - K, 0) .* ind(:,end);
end

%Regression für die Zeitpunkte n-1 bis 1
for i = n-1:-1:1
        
        index = 1:M;
        s = S(index,i+1); %Aktienkurse für die Regression
        v = v * exp(-r*dt); %Optionswert zum Zeitpunkt i

        %Basisfunktionen für A: 1, S, S^2 
        A = ones(length(s),5);
        A(:,2) = s;
        A(:,3) = s.^2;
        A(:,4) = ind(index,i+1);
        A(:,5) = ind(index,i+1).*s;
        A(:,6) = ind(index,i+1).*s.^2;
        
        f = inv(A'*A)*A'*v(index);
        c = A*f; %Wert der Fortführung (für index-Werte)
        
        %vorzeitig ausüben
        indexAusueben = g(index,i+1) >= c; 
        v(index(indexAusueben)) = g(index(indexAusueben),i+1);
end

optionspreis = mean(v * exp(-r*dt))*100;

%Standardfehler und Konfidenzintervall berechnen
sv = sqrt(1/(M-1)*sum((v*100 - optionspreis * ones(M,1)).^2));
standardfehler = sv/sqrt(M);
konfidenzUnten = optionspreis - 1.96 * sv/sqrt(M);
konfidenzOben = optionspreis + 1.96 * sv/sqrt(M);

end
