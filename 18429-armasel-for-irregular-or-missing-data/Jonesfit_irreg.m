function lhtot = jonesfit_irreg(rcs,mdsnn,p);
%
% function lhtot = jonesfit_irreg(rcs,mdsnn,p);
% mdsnn cell variable of dimension{2,K}, containing K sequences of ti and xi 
% ti input missing data time instants
% xi input signal
% rcs = tan(.5*pi*rc), length p + q
% p AR order
%
% Berekent de likelihood van een (missing data) tijdsreeks voor een gegeven
% set parameters. Algoritme komt uit paper R.H. Jones: "Maximum Likelihood
% Fitting of ARMA Models to Time Series With Missing Observations",
% Technometrics vol 22, no 3, aug 1980.
%
% Robert Bos - 12 March 2003.
% Piet Broersen - 30 June 2004, extension to irregular. 
%
% rcs = tan(.5*pi*rc)
% In this way, the reflection coefficient [-1,+1] is mapped to
% [-Inf,+Inf], allowing the use of unconstrained optimization.
%

rcar = 2/pi*atan(rcs(1:p));
if any(~isreal(rcar)),lh = +Inf; return; end 
if any(isnan(rcar)),lh = +Inf; return; end 
a = rc2arset([1 rcar]);
a(1)=[];
rcma = 2/pi*atan(rcs(p+1:end));
if any(~isreal(rcma)),lh = +Inf; return; end 
if any(isnan(rcma)),lh = +Inf; return; end 
b = rc2arset([1 rcma]);
b(1)=[];

ar_par = -a;
ma_par = b;
ar_order = length(ar_par);
ma_order = length(ma_par);

[dum K]=size(mdsnn);
lhtot=0;

% m vaststellen (2.3)
m = max(ar_order, ma_order + 1);

% parameters aanvullen met nullen (later gemakkelijk)
if (ar_order < m)
    for i = ar_order+1:m
        ar_par(i) = 0;
    end
end
if (ma_order < m)
    for i = ma_order+1:m
        ma_par(i) = 0;
    end
end

% Bereken g's (2.13)
g = zeros(m,1);
g(1) = 1;
for i = 2:m;
    g(i)  = ma_par(i-1);
    for j = 1:(i-1)
        g(i) = g(i) + ar_par(j) .* g(i-j);
    end
end

% State matrix F aanmaken (2.15):
F = zeros(m,m);
for i = 1:(m-1)
    F(i,i+1) = 1;
end
F(m,:) = fliplr(ar_par);

% G matrix maken (2.15):
G = g;

% H matrix voor waarnemingen:
H = zeros(1,m);
H(1,1) =1;

% Geen ruis op waarnemingen;
R = 0;

% ====================================================
% ----------------- Opstart matrix -------------------
% ====================================================

[C, gain] = arma2cor([1 -ar_par], [1 ma_par]);
C = C .* gain;

% bereken Opstartmatrix voor Kalmanfilter via 4.12

P0 = zeros(m,m);
P0(1,:) = C(1:m);
P0(:,1) = C(1:m)';
for i = 1:(m-1);
    for j = i:(m-1);
        P0(i+1,j+1) = C(1+j-i);
        for k = 0:(i-1)
            P0(i+1,j+1) = P0(i+1,j+1) - g(1+k).*g(1+k+j-i);
        end
        P0(j+1,i+1) = P0(i+1,j+1);
    end
end

% INTERMEZZO: Schaling van P.

% Dit is de covariantie van de toestand als sigma gelijk is aan 1. Door
% deze keuze, valt sigma weg in vergl 3.2. Schaling maakt niet uit voor
% updaten P (schalingsfout blijft gelijk) of de voorspellingen (blijven
% exact). Schaling beinvloed wel V (zie 3.10). Schaling van V is echter
% niet interessant voor het berekenen van de likelyhood, omdat 3.15 niet
% veranderd als je ipv V bijvoorbeeld p*V invult.

for k1=1:K,
    
    ti=mdsnn{1,k1};
    xi=mdsnn{2,k1};
    
    n = length(ti);
  
    
    % Opstartwaarde state vector is set nullen:
    
    Z = zeros(m,1);
    % ---------------------- Filter -----------------------
    t = ti(1);
    k = 1;
    Delta = zeros(m,1);
    voorspelling = 0;
    P=P0;
    
    som_lh_1 = 0;
    som_lh_2 = 0;
    
    while (t<(ti(end)+1))
        % Waarneming?
        if (t == ti(k))
            V = (P(1,1) + R); 
            % Schaling van V is totaal onbelangrijk. Reden is dat bij het
            % berekenen van de likelihood de schaling geen invloed heeft.
            
            y = (xi(k) - Z(1));
            
            som_lh_1 = som_lh_1 + y.*y ./ V;
            som_lh_2 = som_lh_2 + log(V);
            
            Delta = P*H'./(P(1,1) + R);
            Z = Z + Delta*y;
            P = P - Delta*H*P;
            k = k + 1;
        end
        % State voorspellen:
        Z = F*Z;
        P = F*P*F' + G*G';
        t = t + 1;
    end
    
    % ===================================================
    % ------------- Likelihood berekenen ----------------
    % ===================================================
    % Likelihood volgens 3.15
    
    lh = som_lh_2;
    
    lh = lh + n.*log(som_lh_1);
    
    % Exact likelihood (met constantes):
    lh = lh + n - n*log(n);
    
    lhtot=lhtot+lh;
    
end


if isnan(lhtot), lhtot = +Inf; end
