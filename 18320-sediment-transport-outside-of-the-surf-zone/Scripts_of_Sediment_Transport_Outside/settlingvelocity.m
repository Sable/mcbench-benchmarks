function [wf] = settlingvelocity(rhom,diam,rho,viscocine)
% ___________________________________________________________________
% This routine finds the value of sediment fall velocity.
%
% 1. Inputs:
% rhom = mass density fo sediment grains (kg/m3)
% diam = sediment grain diameter (m).
% rho = mass density of seawater (kg/m3).
% viscocine = kinematic viscosity (m2/s).
%
% 2. Outputs:
% wf = settling or fall velocity     (m/s)
% 
% 3. Example: 
%  [wf] = settlingvelocity(2650,0.2E-3,1025,1E-6)
% 
% wf = 
%   0.0238750897450597
%
% Referents:
%          Ahrens, J.P. (2000). "The fall-velocity equation". J. Waterw., Port, Coastal, 
%                 Ocean Eng., 126(2), 99-102.
%          Jiménez, J.A., Madsen, O.S. (2003). "A simple formula to estimate settling
%                 velocity of natural sediments". J. Waterw., Port, Coastal, 
%                 Ocean Eng., 129(2), 70-78.
%          Madsen, Ole S., Wood, William. (2002).  Sediment Transport Outside the 
%                 Surf Zone. In: Vincent, L., and Demirbilek, Z. (editors), 
%                 Coastal Engineering Manual, Part III, Combined wave and current 
%                 bottom boundary layer flow, Chapter III-6, 
%                 Engineer Manual 1110-2-1100, U.S. Army Corps of Engineers,
%                 Washington, DC.
%          Soulsby, R. L. (1997). Dynamics of marine sands. Thomas Telford. London.
%          Van Rijn, L.C. (1993). Principles of sediment transport in rivers, estuaries and
%                 coastal seas. Aqua Publications. Amsterdam.
%
% Gabriel Ruiz Mtz.
% 2007
%_____________________________________________________________________

dtr = ( ( rhom - rho ) / rho );
S =  ( ( diam / ( 4 * viscocine) ) * sqrt( ( (rhom / rho) - 1 ) * 9.81 * diam  ) );     % (dimensionless)

if S >= 300
            wf = 1.82 * sqrt( ( (rhom / rho) - 1 ) * 9.81 * diam );
elseif S  <= 0.8
            wf = ( 2 / 9 ) *sqrt( ( (rhom / rho) - 1 ) * 9.81 * diam ); 
else
            Dasterisk = ( ( 9.81 * ( (rhom / rho) -1 ) )/ viscocine ^2 ) ^ ( 1 / 3 ) *diam;
            Dcubic = Dasterisk ^3;
             Arquimids = ( dtr * 9.81 * diam ^ 3 ) / viscocine ^2;
             Cl = 0.055 * tanh( ( 12 * Arquimids ^-0.59 ) * exp( -0.0004 * Arquimids ) );
             Ct = 1.06 * tanh( ( 0.016 * Arquimids ^ 0.5 ) * exp( -120 / Arquimids ) );
             wf = ( ( Cl * dtr * 9.81 * diam ^2 ) / viscocine ) + ( Ct * sqrt( dtr * 9.81 * diam ) );

end

