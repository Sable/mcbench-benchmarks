function out=janaf(prop, spec,T);
% ---------------------------------------------------------------------
% function out=janaf(prop, spec, T)                 |   Version 1.01
% ---------------------------------------------------------------------
% Calculates JANAF curve fit according to JANAF virial equation
% Output is calculated in SI-units
%
% prop = 'c' for standard state specific heat
%      = 'h' for standard state enthalpy
%      = 's' for standard state entropy
% spec = 'CO2', 'H2O', 'CO', 'H2', 'O2', 'N2'
% T    = Temperature, vector allowed
% 
% JANAF.mat required (contains the coefficients)
% ---------------------------------------------------------------------
% Last Change: 2003-07-18           |   (c)2003, Stefan Billig, Delphi

% check for correct syntax
if nargin~=3
    help janaf
    % end function
    return
end

% load coefficient table
load JANAF;
z=1;
% determine molecular weight from table
MWeight=eval(['MolWeight.' spec]);

for i=1:length(T)
    % choose temperature range vector
    if (T(i)>1000 & T(i)<=5000)
        eval(['ai=' spec '(1,:);'])
        out(z)=calc(ai, T(i), prop, MWeight);
        z=z+1;
    elseif (T(i)>=300 & T(i)<=1000)
        eval(['ai=' spec '(2,:);'])
        out(z)=calc(ai, T(i), prop, MWeight);
        z=z+1;
    else 
        sprintf(['Temperature ' num2str(T(i)) 'K not between 300K and 5000K!'])
    end
end
    

%----------------------------------------------------------------------
function out=calc(ai, T, prop, MWeight)

R=8.314;
% calculate standard state value
switch prop
    case 'c'
        out=(ai(1)+ai(2)*T+ai(3)*T.^2+ai(4)*T.^3+ai(5)*T.^4)*R/MWeight;
    case 'h'
        out=(ai(1)+ai(2)/2*T+ai(3)/3*T.^2+ai(4)/4*T.^3+ai(5)/5*T.^4+ai(6)/T).*T*R/MWeight;
    case 's'
        out=(ai(1)*ln(T)+ai(2)*T+ai(3)/2*T.^2+ai(4)/3*T.^3+ai(5)/4*T.^4+ai(7))*R/MWeight;
end