function V = spheresegmentvolume(t,n,radius)
% spheresegmentvolume: n-d volume of a sphere cap or within any band defined by parallel planes
% usage: V = spheresegmentvolume(t,n,radius)
%
% Integrates a (hyper)sphere cap, or any segment of a sphere defined by
% a pair of parallel planar slices through the sphere.
% 
% arguments: (input)
%  t - sphere cap limit(s). t must be a vector of length 2
%      Each element of t must normally lie in the closed
%      interval  [-radius,radius].
% 
%      t is a vector that defines the spacing of the parallel
%      slicing planes along any of the axes. Of course, since
%      a sphere is fully rotationally symmetric, the actual
%      planes can lie along any axis. This allows us to define
%      the planes by a simple vector of length 2, denoting their
%      relative displacement from each other.
%
%      A sphere cap would be defined by the vector [t1,radius].
%      
%      If t is empty, or not provided, then the complete sphere
%      volume is computed.
%
%      if t(1) > t(2), then the computed volume will be negative.
%
%      Default value: t = [-radius,radius]. This will compute
%      the complete enclosed volume in the sphere.
% 
%  n - (OPTIONAL) - (scalar, positive numeric integer) dimension
%      of the n-sphere.
%
%      n must be an integer, greater than zero.
%
%      Note: When n is very large (on the order of 344) an underflow
%      will result, causing the computed volume to be returned
%      as zero.
%
%      Default value: n = 3
%
%  radius - (OPTIONAL) - (scalar numeric) radius of the hyper-sphere
%
%      radius must be non-negative
% 
%      Default value: radius = 1
%
%
% Arguments: (output)
%  V - n-dimensional volume of the indicated sphere cap or band.
%
%      The computed volume is exact, to within the floating
%      point accuracy available in double precision.
%
%
% Example:
% %  Compute the volume of a unit, complete sphere
% %  In 2-d, the "volume" is pi.
%
%  V = spheresegmentvolume([],2)
% % V =
% %       3.1416
%
%  V - pi
% % ans =
% %       0
%
% % In 3-d, compute the volume of an exact unit hemisphere,
% % the volume is pi*2/3, approximately 2.0944
%
%  V = spheresegmentvolume([0,1],3)
% % V =
% %       2.0944
%
%  V - 2*pi/3
% % ans =
% %      -4.4409e-16
%   
% % In 4-d, compute the volume of a band around a hyper-sphere
% % of radius 2, with the band running from -1 to +1.
%
%  V = spheresegmentvolume([-1,1],4,2)
% % V =
% %      58.967
%
% % In 50 dimensions, compute the volume inside a unit hemi-sphere cap
%  
%  V = spheresegmentvolume([0,1],50)
% % V =
% %       8.6511e-14
%
% See also: 
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 2.0
% Release date: 2/05/08

% apply defaults as indicated
if (nargin<3) || isempty(radius)
  radius = 1;
elseif length(radius)>1
  error('radius must be a scalar if provided')
elseif radius < 0
  error('radius must be non-negative')
elseif radius == 0
  % a zero radius implies a zero volume always.
  V = 0;
  return
end

if (nargin<2) || isempty(n)
  n = 3;
elseif (length(n)>1) || (n<1) || (n~=floor(n))
  error('n must be a positive scalar integer if provided')
end

% if t is empty, then the complete sphere volume will be computed
if (nargin<1) || isempty(t)
  t = [];
end
t = t(:);
if (length(t)>2) || (length(t) == 1)
  error('t must be a vector of length 2 if provided')
end

% we are done if t is empty
if isempty(t)
  % a complete sphere
  V = (radius^n)*2*(pi^(n/2))/n/gamma(n/2);
  
elseif n==1
  V = diff(t);
else
  % its only a segment from a sphere
  
  % compute the complete sphere volume in one lower dimension
  nm1 = n-1;
%  V = 2*(pi^(nm1/2))/nm1/gamma(nm1/2);
  V = (pi^(nm1/2))/gamma(nm1/2 + 1);
  
  % non-dimensionalize the problem
  t = t/radius;
  
  % ensure that both endpoints are in the nondimensional
  % interval [-1,1]
  t = min(1,max(-1,t));
  
  % this problem reduces to an integral of sin(acos(t))^(n-1), done by
  % integration by parts. Transformation of variables, by s = acos(t)
  % turns that into an integral of -sin(s)^n
  
  % transform the limits
  s = acos(t);
  V = V*(radius^n)*-sineintegral(n,s);
  
end

function si = sineintegral(n,s)
% integral of sin(s)^n, with limits of integration [s(1),s(2)].
% done recursively.

if n == 1
  % special case when n == 1 to end the recurrence.
  si = diff(-cos(s));
elseif n==2
  % special case when n == 2
  si = diff(s/2 - sin(2*s)/4);
else
  % n must be greater than 2
  si = diff(-cos(s).*sin(s).^(n-1)/n) + ((n-1)/n)*sineintegral(n-2,s);
end


