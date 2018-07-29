function par_est
% parameter estimation with derivatives              Holzbecher September 2005
% for exponential fit of exponent lambda for c(0)=c0
global tfit cfit c0 

% specify fitting data
tfit =  [0.25 1 2 4 8]; 
cfit = [0.7716 0.5791 0.4002 0.1860 0.1019]; 
c0 = .8;

lambda = fzero(@myfun,0.11); 
normc = norm(cfit - c0*exp(-lambda*tfit));
display (['Best fit for lambda = ' num2str(lambda)]);
display (['Norm of residuals =' num2str(normc)]);
tmax = tfit(size(tfit,2));
t = [0:0.01*tmax:tmax];
figure; plot (tfit,cfit,'or',t,c0*exp(-lambda*t),'-');
legend ('given','modelled');
text(0.5*tmax,c0*0.7,['\lambda: ' num2str(lambda)]); 
text(0.5*tmax,c0*0.6,['norm of residuals: ' num2str(normc)]);
xlabel ('time'); ylabel ('concentration')

function f = myfun(lambda); 
global tfit cfit c0 

t = tfit;
c = c0*exp(-lambda*t);    % solve linear decay equation for c with c(0)=c0 
clambda = -c.*t;          % equation for dc/dlambda
f = (cfit-c)*clambda';    % specify function f to vanish
