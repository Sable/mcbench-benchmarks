function [vLfactor] = vLdistribution(r,psi,AC,tState,lambdainflow)


mux = tState.V./AC.Rotor.TS;

% my formulation:
Kx = 1-exp(-12.95.*mux).*cos(-15.55.*mux);
Ky = 0;

% %from johnson:
% ratio = lamdainflow/mux;

% % from Coleman, Feingold, and Stempin:
% Kx = sqrt(1+ratio.^2)-abs(ratio);
% Ky = 0;

% %from Drees:
% Kx = 4/3*((1-1.8*mux^2)*sqrt(1+ratio^2)-ratio);
% Ky = -2*mux;

% %from Payne
% Kx = ((4/3)/ratio)/(1.2+1/ratio);
% Ky = 0;

vLfactor = 1+Kx.*r.*cos(psi)+Ky.*r.*sin(psi);

% curve fitting from Prouty:
% V = convvel([0 20 40 60 80]','kts','m/s');
% TS = convvel(650,'ft/s','m/s');