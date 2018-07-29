function [SEMA,  ECC, INC, PHA, w, TWOCIR]=ap2ep(Au, PHIu, Av, PHIv, plot_demo)
%
% Convert tidal amplitude and phase lag (ap-) parameters into tidal ellipse
% (ep-) parameters. Please refer to ep2app for its inverse function.
% 
% Usage:
%
% [SEMA,  ECC, INC, PHA, w]=ap2ep(Au, PHIu, Av, PHIv, plot_demo)
%
% where:
%
%     Au, PHIu, Av, PHIv are the amplitudes and phase lags (in degrees) of 
%     u- and v- tidal current components. They can be vectors or 
%     matrices or multidimensional arrays.
%            
%     plot_demo is an optional argument, when it is supplied as an array 
%     of indices, say [i j k l], the program will plot an  ellipse 
%     corresponding to Au(i,j, k, l), PHIu(i,j,k,l), Av(i,j,k,l), and 
%     PHIv(i,j,k,l); 
%     
%     Any number of dimensions are allowed as long as your computer 
%     resource can handle.     
%     
%     SEMA: Semi-major axes, or the maximum speed;
%     ECC:  Eccentricity, the ratio of semi-minor axis over 
%           the semi-major axis; its negative value indicates that the ellipse
%           is traversed in clockwise direction.           
%     INC:  Inclination, the angles (in degrees) between the semi-major 
%           axes and u-axis.                        
%     PHA:  Phase angles, the time (in angles and in degrees) when the 
%           tidal currents reach their maximum speeds,  (i.e. 
%           PHA=omega*tmax).
%          
%           These four ep-parameters will have the same dimensionality 
%           (i.e., vectors, or matrices) as the input ap-parameters. 
%
%     w:    Optional. If it is requested, it will be output as matrices
%           whose rows allow for plotting ellipses and whose columns are  
%           for different ellipses corresponding columnwise to SEMA. For
%           example, plot(real(w(1,:)), imag(w(1,:))) will let you see 
%           the first ellipse. You may need to use squeeze function when
%           w is a more than two dimensional array. See example.m. 
%
% Document:   tidal_ellipse.ps
%   
% Revisions: May  2002, by Zhigang Xu,  --- adopting Foreman's northern 
% semi major axis convention.
% 
% For a given ellipse, its semi-major axis is undetermined by 180. If we borrow
% Foreman's terminology to call a semi major axis whose direction lies in a range of 
% [0, 180) as the northern semi-major axis and otherwise as a southern semi major 
% axis, one has freedom to pick up either northern or southern one as the semi major 
% axis without affecting anything else. Foreman (1977) resolves the ambiguity by 
% always taking the northern one as the semi-major axis. This revision is made to 
% adopt Foreman's convention. Note the definition of the phase, PHA, is still 
% defined as the angle between the initial current vector, but when converted into 
% the maximum current time, it may not give the time when the maximum current first 
% happens; it may give the second time that the current reaches the maximum 
% (obviously, the 1st and 2nd maximum current times are half tidal period apart)
% depending on where the initial current vector happen to be and its rotating sense.
%
% Version 2, May 2002

if nargin < 5
     plot_demo=0;  % by default, no plot for the ellipse
end


% Assume the input phase lags are in degrees and convert them in radians.
   PHIu = PHIu/180*pi;
   PHIv = PHIv/180*pi;

% Make complex amplitudes for u and v
   i = sqrt(-1);
   u = Au.*exp(-i*PHIu);
   v = Av.*exp(-i*PHIv);

% Calculate complex radius of anticlockwise and clockwise circles:
   wp = (u+i*v)/2;      % for anticlockwise circles
   wm = conj(u-i*v)/2;  % for clockwise circles
% and their amplitudes and angles
   Wp = abs(wp);
   Wm = abs(wm);
   THETAp = angle(wp);
   THETAm = angle(wm);
   
% calculate ep-parameters (ellipse parameters)
    SEMA = Wp+Wm;              % Semi  Major Axis, or maximum speed
    SEMI = Wp-Wm;              % Semin Minor Axis, or minimum speed
     ECC = SEMI./SEMA;          % Eccentricity

    PHA = (THETAm-THETAp)/2;   % Phase angle, the time (in angle) when 
                               % the velocity reaches the maximum
    INC = (THETAm+THETAp)/2;   % Inclination, the angle between the 
                               % semi major axis and x-axis (or u-axis).

    % convert to degrees for output
    PHA = PHA/pi*180;         
    INC = INC/pi*180;         
    THETAp = THETAp/pi*180;
    THETAm = THETAm/pi*180;
    
  %map the resultant angles to the range of [0, 360].
   PHA=mod(PHA+360, 360);
   INC=mod(INC+360, 360);

  % Mar. 2, 2002 Revision by Zhigang Xu    (REVISION_1)
  % Change the southern major axes to northern major axes to conform the tidal 
  % analysis convention  (cf. Foreman, 1977, p. 13, Manual For Tidal Currents 
  % Analysis Prediction, available in www.ios.bc.ca/ios/osap/people/foreman.htm) 
    k = fix(INC/180);
    INC = INC-k*180;
    PHA = PHA+k*180;
    PHA = mod(PHA, 360);
    
 % plot at the request
 if nargout >= 5
     ndot=36;
     dot=2*pi/ndot;
     ot=[0:dot:2*pi-dot];
     w=wp(:)*exp(i*ot)+wm(:)*exp(-i*ot);
     w=reshape(w, [size(Au) ndot]);
  end

 if any(plot_demo)
    plot_ell(SEMA, ECC, INC, PHA, plot_demo);
 end

 if nargout == 6
      TWOCIR=struct('Wp', Wp, 'THETAp', THETAp, 'wp', ... 
            wp, 'Wm', Wm, 'THETAm', THETAm, 'wm', wm, 'ot', ot, 'dot', dot);
 end
  

%Authorship Copyright:
%
%    The author retains the copyright of this program, while  you are welcome 
% to use and distribute it as long as you credit the author properly and respect
% the program name itself. Particularly, you are expected to retain the original 
% author's name in this original version or any of its modified version that 
% you might make. You are also expected not to essentially change the name of 
% the programs except for adding possible extension for your own version you 
% might create, e.g. ap2ep_xx is acceptable.  Any suggestions are welcome and 
% enjoy my program(s)!
%
%
%Author Info:
%_______________________________________________________________________
%  Zhigang Xu, Ph.D.                            
%  (pronounced as Tsi Gahng Hsu)
%  Research Scientist
%  Coastal Circulation                   
%  Bedford Institute of Oceanography     
%  1 Challenge Dr.
%  P.O. Box 1006                    Phone  (902) 426-2307 (o)       
%  Dartmouth, Nova Scotia           Fax    (902) 426-7827            
%  CANADA B2Y 4A2                   email xuz@dfo-mpo.gc.ca    
%_______________________________________________________________________
%
% Release Date: Nov. 2000, Revised on May. 2002 to adopt Foreman's northern semi 
% major axis convention.


