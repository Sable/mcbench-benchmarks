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



% Script chap::2::script
% Density bates Model
%
%   uses the characteristic function of the bates model
%
t = 10;                             % maturity
a = 600;                            % spot value
N = 512;                            % number of grid points  
x = ( (0:N-1) - N/2 ) / a;          % range

figname = 'Risk Neutral Density - Bates';

vInst = 0.02;                  % instantanuous variance of base parameter set  
vLong = 0.02;                  % long term variance of base parameter set
kappa = 0.1;                   % mean reversion speed of variance of base parameter set
omega = 0.2;                   % volatility of variance of base parameter set
rho = -0.5;                       % correlation of base parameter set
muj = 0.1;
sigj = 0.2;
lambda = 0.2;

% cf (characteristic function) for the bates model
f = @(x) cf_bates(x,vInst,vLong,kappa,omega,rho,muj,sigj,lambda,t,0);

legendname = 'Base parameter set';
y = fftdensity(f,a,N);         % density calculated from cf for base parameter set
%% Changing vInst
muj_low = 0;                    % changing parameter (low value)
muj_high = .2;                   % changing parameter (high value)

f_low = @(x) cf_bates(x,vInst,vLong,kappa,omega,rho,muj_low,sigj,lambda,t,0);
f_high = @(x)  cf_bates(x,vInst,vLong,kappa,omega,rho,muj_high,sigj,lambda,t,0);

y_low = fftdensity(f_low,a,N);
y_high = fftdensity(f_high,a,N);

legendname_low = 'Changing \mu_j low value';
legendname_high = 'Changing \mu_j high value';

% output density as figure
createfigure_density(x,y,y_low,y_high,...
    figname, legendname,legendname_low,legendname_high);
%% Changing vLong
sigj_low = .01;
sigj_high = .3;

f_low =  @(x) cf_bates(x,vInst,vLong,kappa,omega,rho,muj,sigj_low,lambda,t,0);
f_high =  @(x) cf_bates(x,vInst,vLong,kappa,omega,rho,muj,sigj_high,lambda,t,0);

y_low = fftdensity(f_low,a,N);
y_high = fftdensity(f_high,a,N);

legendname_low = 'Changing \sigma_j low value';
legendname_high = 'Changing \sigma_j high value';

createfigure_density(x,y,y_low,y_high,...
    figname, legendname,legendname_low,legendname_high);

%% Changing kappa
lambda_low = 0;
lambda_high = .5;

f_low = @(x)  cf_bates(x,vInst,vLong,kappa,omega,rho,muj,sigj,lambda_low,t,0);
f_high = @(x)  cf_bates(x,vInst,vLong,kappa,omega,rho,muj,sigj,lambda_high,t,0);

y_low = fftdensity(f_low,a,N);
y_high = fftdensity(f_high,a,N);

legendname_low = 'Changing \lambda low value';
legendname_high = 'Changing \lambda high value';

createfigure_density(x,y,y_low,y_high,...
    figname, legendname,legendname_low,legendname_high);

