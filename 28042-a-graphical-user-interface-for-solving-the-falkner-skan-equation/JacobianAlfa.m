% IVP with respect to Alfa
function dy = JacobianAlfa (t, y)
    global SOL;
    global ETA_INF;
    global BETA0;
    global BETA;
    global EX;
    method = 'spline';
    % y(1) = df\dalfa
    % y(2) = du\dalfa
    % y(3) = dv\dalfa
    f = interp1(EX, SOL(:,1), t, method); % Interpolate the data set for f
    u = interp1(EX, SOL(:,2), t, method); % Interpolate the data set for u
    v = interp1(EX, SOL(:,3), t, method); % Interpolate the data set for v
    dy = [ETA_INF*y(2) ETA_INF*y(3), -ETA_INF*(BETA0*(y(1)*v+f*y(3))-2*BETA*u*y(2))]';