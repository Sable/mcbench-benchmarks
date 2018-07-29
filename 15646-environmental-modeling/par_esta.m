function par_esta
% parameter estimation with derivatives          Holzbecher September 2005
% for exponential fit for c0 
global tfit cfit lambda

% specify fitting data
tfit =  [0.25 1 2 4 8]; %[0 5 18 30 50];
cfit = [0.7716 0.5791 0.4002 0.1860 0.1019]; %[2.3 1.18 0.52 0.23 0.13]; 
lambda = .3329;

c0 = fzero(@myfun,1);
normc = norm(cfit - c0*exp(-lambda*tfit));
display (['Best fit for c0 = ' num2str(c0)]);
display (['Norm of residuals =' num2str(normc)]);
tmax = tfit(size(tfit,2));
t = [0:0.01*tmax:tmax];
figure; plot (tfit,cfit,'or',t,c0*exp(-lambda*t),'-');
legend ('given','modelled');
text(0.5*tmax,c0*0.7,['c_0: ' num2str(c0)]); 
text(0.5*tmax,c0*0.6,['norm of residuals: ' num2str(normc)]);
xlabel ('time');
ylabel ('concentration');

function f = myfun(c0); 
global tfit cfit lambda

c = c0*exp(-lambda*tfit); % solve linear decay equation for c with c(0)=c0
cc0 = exp(-lambda*tfit);  % equation for dc/dc0
f = (c-cfit)*cc0';        % specify function f to vanish
