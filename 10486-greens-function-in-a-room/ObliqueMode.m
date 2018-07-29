function [modeshape,k_term] = ObliqueMode(n1,n2,n3,l1,l2,l3,rA,rB,rC,r0A,r0B,r0C,k)
%--------------------------------------------------------------
% Compute the Oblique Mode in a room.
% Syntax: [modeshape,k_term] =
%          ObliqueMode(n1,n2,n3,l1,l2,l3,rA,rB,rC,r0A,r0B,r0C,k)
%---------------------------------------------------------------

parameter; % Define parameters
tau_m = V/(2*c*S*bta); % time constant of mth mode
An = sqrt(8); %normalized constant

% Initialisation of variables
modeshape = [];
k_m       = [];
k_term    = [];

% Calculate oblique modes and corresponding wavenumber of modes
for n = 1:length(n3)
    modeshape(n,:) = An.*cos(n1.*pi*rA/l1).*cos(n2.*pi*rB/l2).*cos(n*pi*rC/l3).*...
                     An.*cos(n1.*pi*r0A/l1).*cos(n2.*pi*r0B/l2).*cos(n*pi*r0C/l3);
    k_m(n,:) = sqrt((n1.*pi/l1).^2 + (n2.*pi/l2).^2 + (n*pi/l3).^2);
end;

% Denominator term for Green function
k_term = k^2 - k_m.^2 - i*k/(tau_m*c);
