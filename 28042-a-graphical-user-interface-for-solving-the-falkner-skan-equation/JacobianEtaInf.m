% IVP with respect to EtaInf%
function dy = JacobianEtaInf (t, y)
    global SOL;
    global ETA_INF;
    global BETA0;
    global BETA;
    global EX;
    % y(1) = df\d(eta_inf)
    % y(2) = du\d(eta_inf)
    % y(3) = dv\d(eta_inf)
    method = 'spline';
    f = interp1(EX, SOL(:,1), t, method); % Interpolate the data set for f
    u = interp1(EX, SOL(:,2), t, method); % Interpolate the data set for u
    v = interp1(EX, SOL(:,3), t, method); % Interpolate the data set for v
    dy = [u+ETA_INF*y(2) v+ETA_INF*y(3), -(BETA0*f*v+BETA*(1-u^2))-ETA_INF*(BETA0*(y(1)*v+f*y(3))-2*BETA*u*y(2))]';