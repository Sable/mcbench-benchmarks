function [t,jd]=make3(varargin)

% [t,jd] = make3(p,v,a,j,Ts)
%
% Calculate timing for symmetrical third order profiles.
%
% inputs:
%      p    = desired path (specify positive)              [m]
%      v    = velocity bound (specify positive)            [m/s]
%      a    = acceleration bound (specify positive)        [m/s2]
%      j    = jerk bound (specify positive)                [m/s3]
%      Ts   = sampling time (optional, if not specified or 0: continuous time)
%
% outputs:
%      t(1) = constant jerk phase duration 
%      t(2) = constant acceleration phase duration (default 0)
%      t(3) = constant velocity phase duration (default 0)
%
%       t1                     t1    
%    j  .-.                    .-.  
%       | |                    | |  
%       | | t2      t3      t2 | |     
%      -'-'----.-.------.-.----' '--
%              | |      | |       
%              | |      | |       
%    -j        '-'      '-'       
%              t1       t1        
%
% In case of discrete time, jerk bound j is reduced to jd

%
% Copyright 2004, Paul Lambrechts, The MathWorks, Inc.
%

if nargin < 4 || nargin > 5
   help make3
   return
else
   p=abs(varargin{1});
   v=abs(varargin{2});
   a=abs(varargin{3});
   j=abs(varargin{4});
   if nargin == 4
       Ts=0;
   else
       Ts=abs(varargin{5});
   end
end

if isempty(p) || isempty(v) || isempty(a) || isempty(j) || isempty(Ts)  
   disp('ERROR: insufficient input for trajectory calculation')
   return
end

tol = eps;   % tolerance required for continuous time calculations
jd = j;      % required for discrete time calculations

% Calculation t1
t1 = (p/(2*j))^(1/3) ; % largest t1 with bound on jerk
if Ts>0  
   t1 = ceil(t1/Ts)*Ts; 
   jd = 1/2*p/(t1^3); 
end
% velocity test
if v < jd*t1^2         % v bound violated ?
   t1 = (v/j)^(1/2) ;  % t1 with bound on velocity not violated
   if Ts>0  
       t1 = ceil(t1/Ts)*Ts; 
       jd = v/(t1^2); 
   end
end
% acceleration test
if a < jd*t1     % a bound violated ?
   t1 = a/j ;    % t1 with bound on acceleration not violated
   if Ts>0  
       t1 = ceil(t1/Ts)*Ts; 
       jd = a/t1; 
   end
end
j = jd;  % as t1 is now fixed, jd is the new bound on jerk

% Calculation t2
t2 = (t1^2/4+p/j/t1)^(1/2) - 3/2*t1 ;   % largest t2 with bound on acceleration
if Ts>0  
   t2 = ceil(t2/Ts)*Ts; 
   jd = p/( 2*t1^3 + 3*t1^2*t2 + t1*t2^2 ); 
end
if abs(t2)<tol, t2=0; end % for continuous time case
% velocity test
if v < (jd*t1^2 + jd*t1*t2)   % v bound violated ?
   t2 = v/(j*t1) - t1 ;       % t2 with bound on velocity not violated
   if Ts>0  
       t2 = ceil(t2/Ts)*Ts; 
       jd = v/( t1^2 + t1*t2 ); 
   end
end
if abs(t2)<tol, t2=0; end % for continuous time case
j = jd;  % as t2 is now fixed, jd is the new bound on jerk

% Calculation t3
t3 = (p - 2*j*t1^3 - 3*j*t1^2*t2 - j*t1*t2^2)/v ; % t3 with bound on velocity
if Ts>0  
   t3 = ceil(t3/Ts)*Ts; 
   jd = p/( 2*t1^3 + 3*t1^2*t2 + t1*t2^2 + t1^2*t3 + t1*t2*t3 ); 
end
if abs(t3)<tol, t3=0; end % for continuous time case

% All time intervals are now calculated
t=[ t1 t2 t3 ] ;

% This error should never occur !!
if min(t)<0
    disp('ERROR: negative values found')
end

% Finished.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%