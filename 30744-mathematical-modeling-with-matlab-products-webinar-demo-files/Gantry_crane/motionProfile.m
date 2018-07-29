function p = motionProfile(profileType, t, x, ptotal)
% motionProfile  Compute motion profiles for the crane block
%   PROF = motionProfile(PROFILETYPE, T, X, PTOTAL) returns the profile of
%     the crane block.
%     PROFILETYPE : 'acceleration', 'velocity', 'profile'
%     T           : time vector
%     X           : 3-element vector [tp1, tp2, tf]
%     PTOTAL      : total displacement
%
%   The acceleration profile for this problem is a "bang-coast-bang"
%   profile.
%
%  Example:
%    x = [10 5 20];
%    ptotal = 50;
%    t = 0:.01:30;
% 
%    acc = motionProfile('accel', t, x, ptotal);
%    vel = motionProfile('vel', t, x, ptotal);
%    pos = motionProfile('pos', t, x, ptotal);

% Copyright 2011 The MathWorks, Inc.

error(nargchk(4, 4, nargin, 'struct'));

profileType = validatestring(profileType, ...
   {'acceleration', 'velocity', 'position'}, mfilename, 'PROFILETYPE');

tp1 = x(1); tp2 = x(2); tf = x(3);

% Pulse heights
p1 = 2*ptotal/(tp1*(2*tf-tp1-tp2));
p2 = tp1/tp2*p1;

switch profileType
   case 'acceleration'
      p = zeros(size(t));
      
      % Acceleration phase
      p(t>=0 & t<tp1) = p1;
      
      % Deceleration phase
      p(t>=tf-tp2 & t<tf) = -p2;
      
   case 'velocity'
      p = zeros(size(t));
      
      % Acceleration phase
      idx1 = t>=0 & t<tp1;
      p(idx1) = t(idx1)*p1;
      
      % Coast
      p(t>=tp1 & t<tf-tp2) = tp1*p1;
      
      % Deceleration phase
      idx2 = t>=tf-tp2 & t<tf;
      p(idx2) = tp1*p1 - (t(idx2)-t(find(idx2, 1, 'first')))*p2;
      
   case 'position'
      p = ptotal*ones(size(t));
      
      % Acceleration phase
      idx1 = t>=0 & t<tp1;
      p(idx1) = 0.5*p1*t(idx1).^2;
      
      % Coast phase
      idx2 = t>=tp1 & t<tf-tp2;
      idx2_f = find(idx2, 1, 'first');
      p(idx2) = 0.5*p1*t(idx2_f).^2 + (t(idx2)-t(idx2_f))*tp1*p1;
      
      % Deceleration phase
      idx3 = t>=tf-tp2 & t<tf;
      idx3_f = find(idx3, 1, 'first');
      p(idx3) = 0.5*p1*t(idx2_f).^2 + (t(idx3_f)-t(idx2_f))*tp1*p1 +...
         tp1*p1*(t(idx3)-t(idx3_f)) - 0.5*p2*(t(idx3)-t(idx3_f)).^2;
      
end