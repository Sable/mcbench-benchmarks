function [thfreq,thfreqHz,pcr] = theory(bc,E1,I1,m1,L1)


% Thoretical Natural Frequencies and Euler Buckling load for columns with various
% Boundary Conditions
%
% E = elastic modulus
% I = moment of inertia of cross-section
% m = mass density of the beam
% L = total length of the beam
% bc = boundary condition/type
E = E1 ;
I = I1 ;
m = m1 ;
L = L1 ;

if bc == 'c-c'
    kn = [22.4; 61.7; 121; 200; 299];
    pcr = (4*pi^2*E*I)/L^2 ;
    
elseif bc == 'c-s'
    kn = [15.4; 50.0; 104; 178; 272];
    pcr = (20.19*E*I)/L^2 ;
    
elseif bc == 'c-f'
    kn = [3.52; 22.0; 61.7; 121; 200] ;
    pcr = (pi^2*E*I)/(4*L^2) ;
    
elseif bc == 's-s'
    kn = [9.87; 39.5; 88.8; 158; 247]; 
    pcr = (pi^2*E*I)/L^2 ;
end
            
 thfreq = kn/L^2*sqrt((E*I)/m);
 thfreqHz = kn/(2*pi*L^2)*sqrt((E*I)/m);