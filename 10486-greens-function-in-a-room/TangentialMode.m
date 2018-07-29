function [modeshape,k_term] = TangentialMode(n1,n2,l1,l2,rA,rB,r0A,r0B,k)
%-----------------------------------------------------
% Compute the Tangential Mode in a room.
% Syntax: [modeshape,k_term] = 
%          TangentialMode(n1,n2,l1,l2,rA,rB,r0A,r0B,k)
%-----------------------------------------------------

parameter; % Define parameters
tau_m = (3*V)/(5*c*S*bta); % time constant of mth mode
An = sqrt(4); %normalized constant

% Initialisation of variables
modeshape = [];
k_m       = [];
k_term    = [];

% Calculate tangential modes shapes and wavenumber of modes
for n = 1:length(n2)
    modeshape(n,:) = An.*cos(n1.*pi*rA/l1).*cos(n*pi*rB/l2).*...
                     An.*cos(n1.*pi*r0A/l1).*cos(n*pi*r0B/l2);
    k_m(n,:) = sqrt((n1.*pi/l1).^2 + (n*pi/l2).^2);
end;

% Denominator term for Green function
k_term = k^2 - k_m.^2 - i*k/(tau_m*c);
