function [ zfilt ] = gaussfilt( t,z,sigma )
%Apply a Gaussian filter to a time series
%   Inputs: t = independent variable, z = data at points t, and 
%       sigma = standard deviation of Gaussian filter to be applied.
%   Outputs: zfilt = filtered data.
%
%   written by James Conder. Aug 22, 2013

n = length(z);  % number of data
zfilt = 0*z;    % initalize output vector

%%% get distances between points for proper weighting
w = 0*t;
w(2:end-1) = 0.5*(t(3:end)-t(1:end-2));
w(1) = t(2)-t(1);
w(end) = t(end)-t(end-1);

%%% check if sigma smaller than data spacing
iw = find(w > 2*sigma, 1);
if ~isempty(iw)
    disp('WARNING: sigma smaller than half node spacing')
    disp('May lead to unstable result')
    iw = w > 2.5*sigma;
    w(iw) = 2.5*sigma;
    % this correction leaves some residual for spacing between 2-3sigma.
    % otherwise ok.
    % In general, using a Gaussian filter with sigma less than spacing is
    % a bad idea anyway...
end

%%% loop over points
a = 1/(sqrt(2*pi)*sigma);
sigma2 = sigma*sigma;
for i = 1:n
    filter = a*exp(-0.5*((t - t(i)).^2)/(sigma2));
    zfilt(i) = sum(w.*z.*filter);
end

%%% clean-up edges - mirror data for correction
ss = 2.4*sigma;   % distance from edge that needs correcting

% left edge
tedge = min(t);
iedge = find(t < tedge + ss);
nedge = length(iedge);
for i = 1:nedge;
    dist = t(iedge(i)) - tedge;
    include = find( t > t(iedge(i)) + dist);
    filter = a*exp(-0.5*((t(include) - t(iedge(i))).^2)/(sigma2));
    zfilt(iedge(i)) = zfilt(iedge(i)) + sum(w(include).*filter.*z(include));
end

% right edge
tedge = max(t);
iedge = find(t > tedge - ss);
nedge = length(iedge);
for i = 1:nedge;
    dist = tedge - t(iedge(i));
    include = find( t < t(iedge(i)) - dist);
    filter = a*exp(-0.5*((t(include) - t(iedge(i))).^2)/(sigma2));
    zfilt(iedge(i)) = zfilt(iedge(i)) + sum(w(include).*filter.*z(include));
end


end

