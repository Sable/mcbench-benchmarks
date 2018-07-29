%detection_demo

% S. de Waele, March 2003.

clear
close all

n_rep = 1000;

n_spec = 500;

%Process
a1 = rc2arset([1 -.04 .05]);
b1 = 1;
n_obs = 1e3;

disp('Detection using selected AR models.')
disp('White noise test:')
disp('H0: y ~ white noise with variance varh;')
disp('H1: y ~ another process.')


%Detection threshold for false alarm rate of 1 and 10 percent
%taken from simulations described in section 4.5 of the Ph.D. thesis.
eta_ARsel = 2.4; Pfa = .1;
%eta_ARsel = 10.2; Pfa = .01;

Lmax = 20;
ar0 = 1; %H0: white noise
gamma_mod = 1; %Correction for # estimated parameters

%Detection simulations
hndl = waitbar(0,'% of repetions done');
lr_mod = zeros(1,n_rep);
psel = zeros(1,n_rep);
for t = 1:n_rep
    y = gendata(a1,b1,n_obs);
    ar1 = sig2ar(y,0:Lmax);
    psel(t) = length(ar1)-1;
    varh = mean(y.^2);
    lr_mod(t) = likelihoodR_mod(y,ar0,ar1,varh,gamma_mod);
    waitbar(t/n_rep,hndl)
end
close(hndl)
detect = lr_mod > eta_ARsel;

%Analysis of results
Pd = sum(detect)/n_rep;
i_detect = find(detect);
psel_m = mean(psel);
psel_md= mean(psel(i_detect));
disp(['Detection results for a false alarm rate of ' num2str(Pfa) '.'])
disp(['Process: ' modeltype(a1,b1)])
disp(['Detection probability: ' num2str(Pd)])
disp(['Mean selected AR order: ' num2str(psel_m)])
disp(['Mean selected AR order given that H0 has been rejected: ' num2str(psel_md)])
