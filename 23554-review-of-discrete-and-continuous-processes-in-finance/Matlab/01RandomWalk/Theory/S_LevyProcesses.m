% this file generates paths from four types of Levy processes:
% Merton's jump-diffusion, normal-inverse-gamma, variance-gamma, Kou's jump-diffusion

% see A. Meucci (2009) 
% "Review of Discrete and Continuous Processes in Finance - Theory and Applications"
% available at ssrn.com

% Code by A. Meucci, April 2009
% Most recent version available at www.symmys.com > Teaching > MATLAB


close all; clc; clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs
ChooseProcess=2; % 1=Merton, 2=normal-inverse-Gaussian, 3=variance-gamma, 4=double-exponential
ts=[1/252 : 1/252 : 1]; % grid of time values at which the process is evaluated ("0" will be added, too)
J=3; % number of simulations

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate processes

if ChooseProcess==1 %Merton
    mu=.00;     % deterministic drift
    sig=.20; % Gaussian component
    
    
    l=3.45; % Poisson process arrival rate
    a=0; % drift of log-jump
    D=.2; % st.dev of log-jump
 
    X=JumpDiffusionMerton(mu,sig,l,a,D,ts,J);    
    
    figure
    plot([0 ts],X');
    title('Merton jump-diffusion')
end

if ChooseProcess==2 % normal-inverse-Gaussian
    % (Schoutens notation)
    al=2.1;
    be=0;
    de=1;
    % convert parameters to Cont-Tankov notation
    [th,k,s]=Schout2ConTank(al,be,de);

    X=NIG(th,k,s,ts,J);

    figure
    plot([0 ts],X');
    title('normal-inverse-Gaussian')
end

if ChooseProcess==3 % variance-gamma
    mu=.1;     % deterministic drift in subordinated Brownian motion
    kappa=1;   %
    sig=.2;    % s.dev in subordinated Brownian motion

    X=VG(mu,sig,kappa,ts,J);

    figure
    plot([0 ts],X');
    title('variance gamma')
end

if ChooseProcess==4 % Kou
    mu=.0; % deterministic drift
    l=4.25; % Poisson process arrival rate
    p=.5; % prob. of up-jump
    e1=.2; % parameter of up-jump
    e2=.3; % parameter of down-jump
    sig=.2; % Gaussian component

    X=JumpDiffusionKou(mu,sig,l,p,e1,e2,ts,J);

    figure
    plot([0 ts],X');
    title('double exponential')

end