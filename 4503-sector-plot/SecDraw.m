function [xx, yy] = secdraw(start_angle, sector_angle, radius)

%  usage: [xx, yy]  = secdraw(start_angle, sector_angle, radius, clk_wise)
%
%  Input:
%            start_angle  - starting angle in degrees, [0 is default]
%                           NOTE: this can be positive or negative
%            sector_angle - central angle of sector in degrees
%                           NOTE: if negative, plotting will be clockwise
%                                 direction.                                 
%            radius       - radius of sector (default 1)
%
% Output:                           
%            returns the corner points (xx, yy) of a patch for a sector,
%            which can plotted using the patch(...) function
%            NOTE:
%              1. if less than 2 or NO output variables are given, 
%                 secdraw(...) draws the sector on the current (or a new)
%                 figure
%              2. if one argument is given, 
%                 the argument is taken as the central angle 
%
% Example 1 > [xx, yy]  = secdraw(45, 90, 10);
%             patch( xx, yy, 'b', 'EdgeColor', 'b', 'EraseMode', 'none') ;
%             set( gca, 'DataAspectRatio', [1 1 1] );
%             - this will draw a sector from 45 to 90 degrees with radius=1
%
% Example 2 > secdraw( 60 )
%             - this will draw a sector from 0 to 60 degrees counter
%               clockwise
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% author: Laine Berhane Kahsay
%         
% date  : 19-Feb-2004
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 1 | isempty( nargin ) 
    %disp '';
    disp '-- error in usage --------------------------------';
    disp '      Not enough input arguments.'; 
    help secdraw;
    return;
elseif nargin == 1    
    sector_angle   = start_angle;
    start_angle = 0;
    radius      = 1;
else nargin == 2
    radius  = 1;
end

theta0 = pi*0/180;              % offset angle in radians
theta1 = pi*start_angle/180;    % starting angle in radians
theta  = pi*sector_angle/180;   % central angle in radians

angle_ratio = theta/(2*pi);     % ratio of the sector to the complete circle
rho = abs(radius);              % abs(...) can be removed
MaxPts = 100;                   % maximum number of points in a whole circle.
                                % if set to small # (e.g 10) the resolution
                                % of the curve will be poor. 
                                % generally values greater than 50
                                % will give (very) good resolution

n = abs( ceil( MaxPts*angle_ratio ) );
r = [ 0; rho*ones(n+1,1); 0 ];
theta = theta0 + theta1 + [ 0; angle_ratio*(0:n)'/n; 0 ]*2*pi;

% output
[xx,yy] = pol2cart(theta,r);

% plot if not enough output variable are given
if nargout < 2,
    hh=patch(xx, yy, 'b','EdgeColor','b','EraseMode','none');
end
