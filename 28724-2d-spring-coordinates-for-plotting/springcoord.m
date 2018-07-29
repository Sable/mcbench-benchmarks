function [ xvec, yvec ] = springcoord( pt1, pt2, varargin)
% SPRINGCOORD   Returns the coordinates for a spring starting at pt1 and
%   ends at pt2. Maximum length 'rmax', number of coils 'n', and offset of
%   the spring from the two ends 'd' are used to size the spring display
%   automatically.
%
%  Usage:
%  MUST first initialize the spring
%     [ xvec, yvec ] = springcoord( [ x1 y1 ] , [ x2 y2 ], n, rmax, d)
%  Stretch and compress the spring with new coordinates
%     [ xvec, yvec ] = springcoord( [ x1new y1new ] , [ x2new y2new ])
%
%  Diagram:
%      |<-- d -->|<----- n*h ------>|<-- d -->|
%      ___________/\  /\  /\  /\  /\___________
%   (x1,y1)         \/  \/  \/  \/          (x2,y2)
%
%   *h is the 2D longitudinal length of a single coil at the current
%    configration.
%
%  Tips: This function sizes the spring such that the spring becomes a
%       a single line at the maximum stretch length. You can make rmax
%       slightly larger than the actual maximum length to retain the shape.
%       To plot the spring, simply use plot(xvec,yvec).
%
%  Version 0.1a
%  Created by Dan Peng, 9/6/2010

% Initialize variables
persistent c d n
% Debug note: persistant variables are cleared whenever the .m file
%             is edited.

if nargin > 2
  n = varargin{1}; rmax = varargin{2};  d = varargin{3};
  smax = rmax - 2*d;       % Maximum length of the spring portion
  hmax = smax/n;           % Maximum 2D longitudinal length
  c = hmax/4;              % 2D length of the quarter coil.
else
  if isempty(c)
    disp('Please first initialized the spring');
    xvec = NaN; yvec = NaN;
    return
  end
end

s = norm(pt2-pt1) - 2*d; % Current length of the spring portion
h = s/n;                 % Current 2D longitudional length of single coil

% Calculate the spring coordinates along an unrotated x axis

pp = 0:(2*n-1);                       % Switches yoffset between +/-1
ypts = [ 0 0 (-ones(1,2*n)).^pp 0 0];
yscaler = sqrt(c^2-(h/4)^2);          % "Pitch" height
ypts = yscaler*ypts;                

xpts = linspace(0,s,length(ypts)-2);
xpts = [ 0 d+xpts 2*d+xpts(end) ];    % Accounting for offsets

% Rotation matrix: R = [ e1 ; e2 ]
%                    = [ cos(th) -sin(th);
%                        sin(th)  cos(th ]
%
% Example on obtaining unit vector e1:
%   r = (pt2 - pt1)
%     = [ x2 ; y2 ] - [ x1 ; y1 ]
%     = [ x ; y ]
% 
%   Then [ x ; y ]/norm(r) is effectively
%   [ adj/hyp ; opp/hyp ] or [ cos(th) ; sin(th) ]

e1 = (pt2 - pt1)'/norm(pt2-pt1); % Rotated unit vector e1
e2 = [ -e1(2); e1(1) ];          % Rotated unit vector e2

% Multiply the unrotated points by the rotation matrix.
xvec = pt1(1) + e1(1)*xpts + e2(1)*ypts;
yvec = pt1(2) + e1(2)*xpts + e2(2)*ypts;


end