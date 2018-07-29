function par_estb
% parameter estimation with derivatives                Holzbecher Sept 2005
% for exponential fit with c0 amd lambda as parameters
global tfit cfit c0

% specify fitting data
tfit = [0.25 1 2 4 8]; 
cfit = [0.7716 0.5791 0.4002 0.1860 0.1019];
c0 = 0.816; lambda = 0.333;      % start values

lambda = fzero(@myfun,lambda);
normc = norm(cfit - c0*exp(-lambda*tfit))
display (['Best fit for lambda = ' num2str(lambda)]);
display (['Best fit for c0 = ' num2str(c0)]);
display (['Norm of residuals =' num2str(normc)]);
tmax = tfit(size(tfit,2));
t = [0:0.01*tmax:tmax];
plot (tfit,cfit,'or',t,c0*exp(-lambda*t),'-');
legend ('given','modelled');
text(0.5*tmax,c0*0.8,['\lambda:' num2str(lambda)]); 
text(0.5*tmax,c0*0.7,['c_0:' num2str(c0)]); 
text(0.5*tmax,c0*0.6,['norm of residuals: ' num2str(normc)]);

function f = myfun(lambda); 
global tfit cfit c0 

options = optimset; 
c0 = fzero(@myfun2,c0,options,lambda);
display (['Best fit for c0 = ' num2str(c0)]);

c = c0*exp(-lambda*tfit);    % solve linear decay equation for c with c0
clambda = -c.*tfit;          % equation for dc/dlambda
f = (c-cfit)*clambda';       % specify function f to vanish

function f = myfun2(c0,lambda); 
global tfit cfit

c = c0*exp(-lambda*tfit);    % solve linear decay equation for c with c(0)=1 
cc0 = exp(-lambda*tfit);     % equation for dc/dc0
f = (c-cfit)*cc0';           % specify function f to vanish
