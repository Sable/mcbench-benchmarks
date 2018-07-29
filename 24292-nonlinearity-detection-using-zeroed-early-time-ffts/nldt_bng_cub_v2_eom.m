function [xdot] = nldetect_anex1_v1_eom(t,x); % ,junk
% Note:  Include ',junk' before eom if this is to be called as an m-file,
%   i.e. [T,Y] = ode45('nldetec_anex1_v1_eom',...)
% Exlude ',junk' if this is to be called as:
%   sol = ode45(@nldetect_anex1_v1_eom, ...)

% State Space representation:
% x = [q; qdot], xdot = [qdot; qdoubledot]
global eom % more efficient to treat as global than to pass in every time.

% Define nonlinear force:
if strcmp(eom.NLType,'bang');
    % Bang (Contact Nonlinearity)
    % Assumes that stiffness of contacted parts is k4mult times higher.
    % Damping is also assumed higher by a factor of c4mult
    del4 = (x(eom.at_ns(1))-x(eom.at_ns(2)));
    if del4 < eom.delcont % No Contact Occurs
        Fnl = eom.kat*del4 ...
            + eom.cfactk*eom.kat*(x(eom.at_ns(1)+eom.Ntot)-x(eom.at_ns(2)+eom.Ntot)); % Add damping terms
    else                % Contact Occurs
        Fnl = eom.kat*eom.k4mult*del4 ...
            + eom.c4mult*eom.cfactk*eom.kat*(x(eom.at_ns(1)+eom.Ntot)-x(eom.at_ns(2)+eom.Ntot)); % Add damping terms
    end
elseif strcmp(eom.NLType,'cubic');
    % Cubic Spring
    del4 = (x(eom.at_ns(1))-x(eom.at_ns(2)));
    Fnl = eom.kat*del4*(1 + eom.katnl*del4^2) ...
        + eom.cfactk*eom.kat*(x(eom.at_ns(1)+eom.Ntot)-x(eom.at_ns(2)+eom.Ntot)); % Add damping terms
else
    error('NLType not recognized');
end

% Define input force - normalized to have unit area (energy) * Afnl
% This is applied to mass 5 below
if t <= eom.tfp
    fext = eom.Afnl*(2*eom.tfp/pi)*sin((pi/eom.tfp)*t);
else
    fext = 0;
end

% Equations of Motion
xdot(eom.dnodes,1) = x(eom.vnodes);
xdot(eom.vnodes,1) = (-eom.Ctot*x(eom.vnodes) - eom.Ktot*x(eom.dnodes) + fext*eom.fext_vec + ...
    Fnl*eom.fnl_vec)./diag(eom.Mtot);