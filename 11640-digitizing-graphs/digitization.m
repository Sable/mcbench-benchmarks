function [data,calib] = digitization(calibin) 
% FUNCTION FOR DIGITIZING GRAPHS.
% Axes reference information may be predefined in the structure 
% calibin, or it may be created, in which case the user is 
% inquired about the following input: 
%
% Two points on the x-axis and two points on the y-axis have 
% to be chosen, preferably at some distance so as to define 
% the axis accurately.
%
% Axes do not need to cross at a particular point and both 
% linear and logarithmic axes are accepted.
%
% Harald E. Krogstad, NTNU, 2006
%-------------------------------------------------------------------
if nargin == 0
    %
    % Dialog for defining the x-axis
    x0  =  input('Enter x coordinate for x0: ');
    disp('Point to x0!')
    x0p = (ginput(1))';
    %
    x1 =  input('Enter x coordinate for x1: ');
    disp('Point to x1!')
    x1p = (ginput(1))';
    linlogx = input('Linear/logarithmic x-axis? (0=lin.,1=log.):');
    %
    % Dialog for defining the y-axis
    y0  =  input('Enter y coordinate for y0: ');
    disp('Point to y0!')
    y0p = (ginput(1))';
    %
    y1 =  input('Enter y coordinate for y1: ');
    disp('Point to y1!')
    y1p = (ginput(1))';
    linlogy = input('Linear/logarithmic y-axis? (0=lin.,1=log.):');
    %
    % Collect axis reference structure
    calib.x0   = x0;     calib.x1 = x1;     
    calib.y0   = y0;     calib.y1 = y1 ;  
    calib.x0p  = x0p;   calib.x1p = x1p; 
    calib.y0p  = y0p;   calib.y1p = y1p;    
    calib.linlogx = linlogx ;
    calib.linlogy = linlogy ;    
else   
    %
    % Unpack existing axis reference structure 
    calib = calibin;
    x0  = calib.x0;    x1 = calib.x1;     
    y0  = calib.y0;    y1 = calib.y1;
    x0p = calib.x0p;  x1p = calib.x1p; 
    y0p = calib.y0p;  y1p = calib.y1p;
    linlogx = calib.linlogx; 
    linlogy = calib.linlogy;
end
%
% Get data-points
disp('Pick data points, - end with Enter: ')
Xp = ginput;
%
% Find picture coordinates
Ndata = size(Xp(:,1));
Mm = [ (x1p - x0p)   (y1p - y0p) ]^(-1);
Xpmx0 = Xp' - x0p*ones(1,Ndata); 
Xpmy0 = Xp' - y0p*ones(1,Ndata);
T = Xpmx0'*Mm(1,:)' ;
S = Xpmy0'*Mm(2,:)' ;
%
% Transform to graph (actual) coordinates
if linlogx == 1
   % Log x-axis
   xdata = exp( log(x0) +  (log(x1) - log(x0))*T ) ;
else
   % Linear x-axis
   xdata = x0 +  (x1 - x0)*T;
end
%
if linlogy == 1
   % Log y-axis
   ydata = exp( log(y0) +  (log(y1) - log(y0))*S ) ;
else
   % Linear y-axis
   ydata = y0 +  (y1 - y0)*S;
end
data = [xdata ydata];

 

    