function [g, h] = loadigrfcoefs(time)

% LOADIGRFCOEFS Load coefficients used in IGRF model.
% 
% Usage: [G, H] = LOADIGRFCOEFS(TIME) or GH = LOADIGRFCOEFS(TIME)
% 
% Loads the coefficients used in the IGRF model at time TIME in MATLAB
% serial date number format and performs the necessary interpolation. If
% two output arguments are requested, this returns the properly
% interpolated matrices G and H from igrfcoefs.mat. If just one output is
% requested, the proper coefficient vector GH from igrfcoefs.mat is
% returned.
% 
% If this function cannot find a file called igrfcoefs.mat in the MATLAB
% path, it will try to create it by calling GETIGRFCOEFS.
% 
% Inputs:
%   -TIME: Time to load coefficients either in MATLAB serial date number
%   format or a string that can be converted into MATLAB serial date number
%   format using DATENUM with no format specified (see documentation of
%   DATENUM for more information).
% 
% Outputs:
%   -G: g coefficients matrix (win n going down the rows, m along the
%   columns) interpolated as necessary for the input TIME.
%   -H: h coefficients matrix (win n going down the rows, m along the
%   columns) interpolated as necessary for the input TIME.
%   -GH: g and h coefficient vector formatted as:
%   [g(n=1,m=0) g(n=1,m=1) h(n=1,m=1) g(n=2,m=0) g(n=2,m=1) h(n=2,m=1) ...]
% 
% See also: IGRF, GETIGRFCOEFS.

% Load coefs and years variables.
if ~exist('igrfcoefs.mat', 'file')
    getigrfcoefs;
end
load igrfcoefs.mat;

% Convert time to a datenumber if it is a string.
if ischar(time)
    time = datenum(time);
end
% Make sure time has only one element.
if numel(time) > 1
    error('loadigrfcoefs:timeInputInvalid', ['The input TIME can only ' ...
        'have one element']);
end

% Convert time to fractional years.
timevec = datevec(time);
time = timevec(1) + (time - datenum([timevec(1) 1 1]))./(365 + double(...
    (~mod(timevec(1),4) & mod(timevec(1),100)) | (~mod(timevec(1),400))));

% Check validity on time.
if time < years(1) || time > years(end)
    error('igrf:timeOutOfRange', ['This IGRF is only valid between ' ...
        num2str(years(1)) ' and ' num2str(years(end))]);
end

% Get the nearest epoch that the current time is between.
lastepoch = find(time - mod(time, 5) == years);
if lastepoch == length(years)
    lastepoch = lastepoch - 1;
end
nextepoch = lastepoch + 1;

% Output either g and h matrices or gh vector depending on the number of
% outputs requested.
if nargout > 1
    
    % Get the coefficients based on the epoch.
    lastg = coefs(lastepoch).g; lasth = coefs(lastepoch).h;
    nextg = coefs(nextepoch).g; nexth = coefs(nextepoch).h;
    
    % If one of the coefficient matrices is smaller than the other, enlarge
    % the smaller one with 0's.
    if size(lastg, 1) > size(nextg, 1)
        smalln = size(nextg, 1);
        nextg = zeros(size(lastg));
        nextg(1:smalln, (0:smalln)+1) = coefs(nextepoch).g;
        nexth = zeros(size(lasth));
        nexth(1:smalln, (0:smalln)+1) = coefs(nextepoch).h;
    elseif size(lastg, 1) < size(nextg, 1)
        smalln = size(lastg, 1);
        lastg = zeros(size(nextg));
        lastg(1:smalln, (0:smalln)+1) = coefs(lastepoch).g;
        lasth = zeros(size(nexth));
        lasth(1:smalln, (0:smalln)+1) = coefs(lastepoch).h;
    end

    % Calculate g and h using a linear interpolation between the last and next
    % epoch.
    if coefs(nextepoch).slope
        gslope = nextg;
        hslope = nexth;
    else
        gslope = (nextg - lastg)/5;
        hslope = (nexth - lasth)/5;
    end
    g = lastg + gslope*(time - years(lastepoch));
    h = lasth + hslope*(time - years(lastepoch));
    
else
    
    % Get the coefficients based on the epoch.
    lastgh = coefs(lastepoch).gh;
    nextgh = coefs(nextepoch).gh;
    
    % If one of the coefficient vectors is smaller than the other, enlarge
    % the smaller one with 0's.
    if length(lastgh) > length(nextgh)
        smalln = length(nextgh);
        nextgh = zeros(size(lastgh));
        nextgh(1:smalln) = coefs(nextepoch).gh;
    elseif length(lastgh) < length(nextgh)
        smalln = length(lastgh);
        lastgh = zeros(size(nextgh));
        lastgh(1:smalln) = coefs(lastepoch).gh;
    end
    
    % Calculate gh using a linear interpolation between the last and next
    % epoch.
    if coefs(nextepoch).slope
        ghslope = nextgh;
    else
        ghslope = (nextgh - lastgh)/5;
    end
    g = lastgh + ghslope*(time - years(lastepoch));
    
end