function e = oswaldfactor(AR,sweep,method,CD0,df_over_b,u)
% OSWALDFACTOR Finds Oswald efficiency factor, e, for purposes of
% approximating a parabolic drag polar C_D = C_D0 + C_L^2/(pi*e*AR), where
% C_L is lift coefficient.
%
%   e = OSWALDFACTOR(AR,sweep,method,C_D0,df_b,u)
%
%   AR     - Wing effective aspect ratio (simply aspect ratio for single
%            wing w/o winglets).
%   sweep  - Wing sweep in radians. Default sweep = 0.
%   method - Choose between different methods. Options listed below.
%            Default method = 'Shevell' if C_D0 is provided, otherwise
%            default method = 'Raymer'.
%       'Raymer'      - Raymer's "Aicraft Design: A Conceptual Approach"
%                       equations 12.48/49 in fifth edition.
%       'Shevell'     - Adapted from Shevell's "Fundamentals of Flight."
%       'Pessimistic' - The worst of the two.
%       'Optimistic'  - The best of the two.
%       numeric 0-1   - method×Shevell + (1-method)×Raymer.
%       'Average'     - Same as numeric method = 0.5.
%   C_D0   - Parasite drag coefficient (drag independent of lift).
%   df_b   - Ratio of fuselage diameter (or width) to wing span. Default 
%            df_b = 0.
%   u      - Planform efficiency — usually 0.98 < u < 1. Default u = 1.
%
%   Raymer's equations want sweep at the leading edge but the Shevell
%   method uses quarter chord sweep, so the methods are most comparable for
%   low- or untapered wings and/or high aspect ratio wings where the
%   difference between leading edge and quarter chord sweeps is small.
%
%   The function requires only AR and, for sweep > 0, sweep as inputs for
%   Raymer method.
%
%   Raymer's method is only for "normal" ARs - not for, say, sailplanes.
%
%   Example: Replicate Shevell's Fig. 11.8 on p. 187.
%       u = .99; df_b = 0.114;
%
%       ARx = linspace(0,12,25);
%       [CD0,AR] = meshgrid([.01 .015 .02 .025],ARx);
%       e = OSWALDFACTOR(AR,0,'shevell',CD0,df_b,u);
%       plot(ARx,e); axis([0 12 .6 1]); grid on
%       xlabel('Aspect Ratio'); ylabel('Oswald efficiency factor, e')
%       legend('C_{D,0} = 0.01','0.015','0.02','0.025')
%       text(8.5,.63,'u = 0.99    s = 0.975')
%
%       sweepx = linspace(0,40,41);
%       [AR,sweep] = meshgrid([4;8;12],sweepx*pi/180);
%       e = OSWALDFACTOR(AR,sweep,'shevell',0,df_b,u)./...
%           OSWALDFACTOR(AR,  0  ,'shevell',0,df_b,u);
%       axes('pos',[0.25 0.25 0.3 0.25]);
%       plot(sweepx,e); axis([0 40 .9 1.02]); grid on
%       xlabel('Sweep, \Lambda (deg)'); ylabel('e_\Lambda/e_{\Lambda=0}')
%       legend('AR = 4','8','12','Location','SouthWest')
%
%   e = OSWALDFACTOR(AR,sweep,method,C_D0,df_b,u)

%{
    Copyright 2012-2013 Sky Sartorius
    Author contact: mathworks.com/matlabcentral/fileexchange/authors/101715

References:
    Shevell: "Fundamentals of Flight" 2ed. 1989
             See also http://adg.stanford.edu/aa241/drag/induceddrag.html
             for some info on the Shevell theory and assumptions leading to
             coefficients.
    Raymer:  "Aircraft Design: A Conceptual Approach" 5ed. 2012
             See Raymers leading-edge-suction method (section 12.6.2 in 5th
             ed.) for an alternate method for high-AR cases.
%}

% Set defaults.
if nargin < 6
    u = 1;
end
if nargin < 5 || isempty(df_over_b)
    df_over_b = 0;
end
if nargin >= 4 && isempty(method)
    method = 'shevell';
end
if nargin < 3 || isempty(method)
    method = 'raymer';
end
if nargin < 2 || isempty(sweep)
    sweep = 0;
end


if isnumeric(method) || strcmpi(method,'average')
    if strcmpi(method,'average')
        avgweight = 1/2;
    elseif (all(method(:) >= 0)) && (all(method(:) <= 1))
        avgweight = method;
        method = 'average';
    else
        error('All elements of a numeric METHOD must be between 0 and 1.')
    end
end

if ~strcmpi('shevell',method) %need to calculate raymer at least
    if any(AR(:)>10)
        warning('Raymer method not recommended for high aspect ratios.')
    end
    % with sweep
    e_ray_sweep = 4.61*(1-0.045*AR.^.68).*(cos(sweep)).^0.15-3.1;
    % no sweep
    e_ray_no_sweep = 1.78*(1-0.045*AR.^.68)-0.64;
    
    weight = abs(sweep)/(30*pi/180);
    e_ray = weight.*e_ray_sweep+(1-weight).*e_ray_no_sweep;
    
    hisweepind = sweep > 30*pi/180;
    e_ray(hisweepind) = e_ray_sweep(hisweepind);
    if strcmpi('raymer',method)
        e = e_ray;
        return
    end
end

%calculate shevell
s = 1 - 1.9316 * df_over_b.^2;
k = 0.375 * CD0;
sweep_corr = 1  -  0.02 * AR.^0.7 .* sweep.^2.2;

e_shev = sweep_corr./(pi*AR.*k + 1./(u.*s));

switch lower(method)
    case 'shevell'
        e = e_shev;
    case 'pessimistic'
        e = min(e_shev,e_ray);
    case 'optimistic'
        e = max(e_shev,e_ray);
    case 'average'
        e = avgweight.*e_shev+(1-avgweight).*e_ray;
    otherwise
        error('Bad method string.')
end

end

% Revision history
%{
25 oct 2012: uploaded first version to file exchange
29 oct 2012
  fixed the math in a fundamental way
  made better curve fits
  added example
  new version uploaded
30 oct 2012
  added weighted average method
  changed exponent from 2.3 to 2.2 so as not to be too optimistic
  better input handling
  new version uploaded
20 nov 2012
  added some :s for better n-dim input handling
  uploaded
10 december 2012: changed from if/elseif to switch/case at the end
13 dec 2012
    found Shevell adaptation in Schaufele's "The Elements of Aircraft
    Preliminary Design" that specified that it is for quarter chord sweep
    (Shevell isn't explicit). Documentation changed to reflect this.
    The coefficients have much better agreement with Shevell than with
    Schaufele's adaptation. Quick investigation shows that Schaufele's plot
    is a tiny bit more conservative for low sweep / high AR and for high
    sweep / low AR.
24 dec 2012: changed name to oswaldfactor to further differentiate from
    lifting line e efficiency factor and to get rid of underscore.
2013-08-25 moved default for sweep to the beginning
2013-09-09 documentation and references; defaults handling; uploaded to FEX
%}