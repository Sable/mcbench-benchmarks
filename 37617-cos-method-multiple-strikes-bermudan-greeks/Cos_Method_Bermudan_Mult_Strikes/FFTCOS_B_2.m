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



function price = FFTCOS_B_2(n, Nex, L, c, cp, type, S0, t, r, q, ...
    strike, varargin)

dt = t / Nex;                    % time interval
Ngrid = 2 ^ n;                   % Grid points
Nstrike = size(strike,1);        % number of strikes

x = double(log(S0 ./ strike));       % center

a = double(c(1) + x - L * sqrt(c(2) + sqrt(c(3))));   % lower trunc
b = double(c(1) + x + L * sqrt(c(2) + sqrt(c(3))));   % upper trunc

Grid_i = repmat((0:Ngrid-1)',1,Nstrike);    % Grid index

% Set up function handles
if cp == 1
    vk = @(x) calcv(Grid_i, x, b, a, b, cp, strike);
    cv = @(x,y) cvalue(a, x, a, b, Ngrid, y, type, dt, r, q, varargin{:});
    
else
    vk = @(x) calcv(Grid_i, a, x, a, b, cp, strike);
    cv = @(x,y) cvalue(x, b, a, b, Ngrid, y, type, dt, r, q, varargin{:});
end
initialGuess = .5*(b-a);               % guess for x^*(t_Nex-1)
%initialGuess = 0;
V = vk(0);                      % coeff V in t_Nex-1

xstark = zeros(Nstrike,Nex-1);
for m = Nex-1:-1:1              % backward induction
    % could be fzero but Newton with some number of iteration is fine!
    xstark(:,m) = xstar(initialGuess,cp, a, b, 50, Grid_i, type, ...
            V, dt, r, q, strike, varargin{:}); % early exercise point
    C = cv(xstark(:,m),V);        % Cont value at t_m
    V = vk(xstark(:,m)) + C;    % Coeff V in t_m
    initialGuess = xstark(:,m);
end


cfval = exp(feval(@CF, type,pi*Grid_i*diag(1./(b-a)), dt,r,q,varargin{:}));

pF = cfval .* exp( 1i * pi * Grid_i * diag((x - a) ./ (b - a)) );

pF(1,:) = 0.5*pF(1,:);

price = exp(-r * dt) * sum(real(pF) .* V) ;  % Option value at t_0

end