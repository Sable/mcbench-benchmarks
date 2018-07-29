function [modeshape,k_term] = AxialMode(n1,l1,rA,r0A,k)
%-------------------------------------------------------
% Compute the Axial Mode in a room.
% Syntax: [modeshape,k_term] = AxialMode(n1,l1,rA,r0A,k)
%-------------------------------------------------------

parameter; % Define parameters
tau_m = (3*V)/(4*c*S*bta); % time constant of mth mode 
An = sqrt(2); %normalized constant

% Initialisation of variables
modeshape = [];
k_m       = [];
k_term    = [];

% Calculate axial mode shape and wavenumber of modes
modeshape = An.*cos(n1.*pi*rA/l1).*...
            An.*cos(n1.*pi*r0A/l1);
k_m = (n1.*pi/l1);

% Denominator term for Green function
k_term = k^2 - k_m.^2 - i*k/(tau_m*c);
