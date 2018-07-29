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



function price = FFTCOS_DownAndOut(n, Nex,H,Rb, L, c, cp, type, S0, t, r, q, ...
                                    strike, varargin)

% Function FFTCOS_DownAndOut calculates the price of a discretely
% monitored Down-and-Out Call or Put option by use of the Fourier-Cosine
% Series Expansion introduced by Oosterlee & Fang
%------------------------------------------------------------------------

% Nex := number of examination points
% H := Barrier
% Rb := Rebate
                                
dt = t / Nex;                    % time interval
Ngrid = 2 ^ n;                   % Grid points
Nstrike = size(strike,1);        % number of strikes

x = double(log(S0 ./ strike));       % center
h = double(log(H ./ strike));

a = double(c(1) + x - L * sqrt(c(2) + sqrt(c(3))));   % lower trunc
b = double(c(1) + x + L * sqrt(c(2) + sqrt(c(3))));   % upper trunc

Grid_i = repmat((0:Ngrid-1)',1,Nstrike);    % Grid index

% Set up function handles
if cp == 1
    vk = @(x) calcv(Grid_i, x, b, a, b, cp, strike);
    if h >= 0
        V = vk(h);
    else
        V = vk(0);
    end
else
    vk = @(x) calcv(Grid_i, x, 0, a, b, cp, strike);
    if h >= 0
        V = vk(a);
    else
        V = vk(h);
    end
end

cv = @(y) cvalue(h, b, a, b, Ngrid, y, type, dt, r, q, varargin{:});

aux = pi * Grid_i * diag(1./(b-a));
G = (sin(aux * diag(h-a))./aux);
G = exp(-r * dt) * 2 * Rb * [((h-a)./(b-a))';G(2:end,:)] * diag(1./(b-a));

V = V + G;
for m = Nex-1:-1:1              % backward induction
    V = cv(V) + G;
end

cfval = exp(feval(@CF, type,aux, dt,r,q,varargin{:}));

pF = cfval .* exp( 1i * aux * diag(x - a) );
pF(1,:) = 0.5*pF(1,:);
price = exp(-r * dt) * sum(real(pF) .* V) ;  % Option value at t_0

end