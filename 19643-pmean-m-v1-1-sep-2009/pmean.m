function varargout = pmean(varargin)
%PMEAN   MEAN and STD of polar/cylindrical/spherical/cartesian coordinates.
%
%   SYNTAX:
%                 [mA,eA] = pmean(A);             % mean angle
%           [mA,mB,eA,eB] = pmean(A,B);           % mean polar
%     [mA,mB,mC,eA,eB,eC] = pmean(A,B,C);         % mean cylindrical
%     [mA,mB,mC,eA,eB,eC] = pmean(A,B,C,DIM);
%     [mA,mB,mC,eA,eB,eC] = pmean(...,'NAME');
%
%   INPUT:
%     A    - First  coordinate. See table below for details.
%     B    - Second coordinate.
%     C    - Third  coordinate.
%     DIM  - Specifies the dimension trough which the function work.
%            DEFAULT: first non-singleton (almost always column-wise)
%     NAME - Coordinate system name. One of 'polar', 'spherical' or
%            'cartesian'. Only the first letter is used.
%            DEFAULT: 'p'
%
%   OUTPUT:
%     mA  - Mean of A.
%     mB  - Mean of B.
%     mC  - Mean of C.
%     eA  - Standard deviation of A.
%     eB  - Standard deviation of B.
%     eC  - Standard deviation of C.
%     
%   DESCRIPTION:
%     Calculates de mean and standard deviations of polar, cylindrical,
%     spherical or cartesian coordinates, ignoring NaNs. All coordinates
%     are tranformed to cartesian and then estimated its error propagation
%     by 
%        f(X,Y)_error = sqrt{ [abs(df/dX)*dY]^2 + [abs(df/dY)*dY]^2 }
%     where
%                X,Y  - Cartesian coordinates
%              f(X,Y) - Cartesian to coordinate funcion. For example, the
%                       polar angle is given by: 
%                               THETA(X,Y) = atan(Y/X)
%               dX,dY - Standard deviations of X and Y respectively.
%     Then, it is assumed independent errors between coordinates and
%     treated as random variables.
%
%     The coordinate systems are as follows:
%         -----------------------------------------------------------
%           SYSTEMS          COORDINATES                DEFAULTS
%         -----------------------------------------------------------
%           'polar'         (A,B,C) == (THETA,RHO,Z)    (THETA,1,0)
%           'spherical'     (A,B,C) == (THETA,PHI,R)    (THETA,0,1)
%           'cartesian'     (A,B,C) == (X,Y,Z)          (X    ,0,0)
%         -----------------------------------------------------------
%     See CART2POL, CART2SPH and Aditional Notes on this file for more
%     details.
%
%   NOTE:
%     * Optional inputs use its DEFAULT value when not given or [].
%     * Optional outputs may or not be called.
%     * pmean(X,'c') is the same as mean(X), but pmean(THETA) IS NOT, because
%       THETA are angles.
%     * THETA and PHI inputs must be in "radians".
%     * Mean THETA output angle ranges from (0 2*pi].
%     * Mean PHI, and all error angles ranges from (-pi/2 pi/2].
%
%   EXAMPLE:
%     N  = 1000;
%     D = 135 + 20*randn(N,1); % directions in °
%     R  = 10 +  3*randn(N,1); % magnitudes in m
%     [mD,mR,eD,eR] = pmean(D*pi/180,R); 
%     mD = mD*180/pi; eD = eD*180/pi;
%     polar(D*pi/180,R,'.y')
%     hold on
%     polar(mD*pi/180,mR,'ro')
%     polar((mD+eD*[      1:-0.01:-1       -1:0.01:1  1])*pi/180,...
%            mR+eR*[repmat(-1,1,201) repmat(1,1,201) -1],'b')
%     hold off
%     % APROX. RESULTS:  134.26+-19.17°  and   9.53+-3.19 m
%
%   See also MEAN, CART2POL, POL2CART, CART2SPH and SPH2CART.
%
%
%
%   ---
%   MFILE:   pmean.m
%   VERSION: 1.1 (Sep 21, 2009) (<a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/authors/11258')">download</a>) 
%   MATLAB:  7.7.0.471 (R2008b)
%   AUTHOR:  Carlos Adrian Vargas Aguilera (MEXICO)
%   CONTACT: nubeobscura@hotmail.com

%   ADDITIONAL NOTES:
%     * The components of the coordinates systems are:
%         For polar or cylindrical: Direction, Radius, Height
%                      [mD,eD] = pmean(D);
%                [mD,mR,eD,eR] = pmean(D,R);
%          [mD,mR,mH,eD,eR,eH] = pmean(D,R,H);
%         For spherical coordinates: Azimuth, Elevation, Radius
%                      [mA,eA] = pmean(A);
%                [mA,mE,eA,eE] = pmean(A,E,'s');
%          [mA,mE,mR,eA,eE,eR] = pmean(A,E,R,'s');
%         For cartesian coordinates:
%                      [mX,eX] = pmean(X,'c');
%                [mX,mY,eX,eY] = pmean(X,Y,'c');
%          [mX,mY,mZ,eX,eY,eZ] = pmean(X,Y,Z,'c');

%   REVISIONS:
%   1.0      Released. (Apr 19, 2008)
%   1.0.1    Fixed ortography errors. (Apr 21, 2008)
%   1.1      Fixed important bug with angle STD. Changed help and comments.
%            (Sep 21, 2009)

%   DISCLAIMER:
%   pmean.m is provided "as is" without warranty of any kind, under the
%   revised BSD license.

%   Copyright (c) 2008,2009 Carlos Adrian Vargas Aguilera

% Check inputs
if nargin<1 || nargin>4
 error('CVARGAS:pmean:incorrectNumberOfInputs',...
  'Number of inputs must be at least 1 and maximum 4.')
end

% a) pmean(THETA), pmean(THETA,'p'), pmean(THETA,'s')
if nargin==1 || ...
  (nargin==2 && (ischar(varargin{2}) && ~strcmp(varargin{2},'c')))
 % Mean, std polar/cylindrical/spherical first coordinate.
 
 % Coordinates.
 THETA = varargin{1};
 THETA(~isfinite(THETA)) = [];
 
 % To cartesian.
 X = cos(THETA);
 Y = sin(THETA);
 
 % MEAN:
 mX = mean(X);
 mY = mean(Y);
 mTHETA = mod(atan2(mY,mX),2*pi);
 varargout{1} = mTHETA;
 
 % STD:
 if nargout==2
  eX = std(X);
  eY = std(Y);                            % | Fixed bug, Sep 2009
  mR = abs(mX+1i*mY);                     % v
  eTHETA = abs(mod(abs(mY.*eX+1i*mX.*eY)./mR.^2+pi/2,pi)-pi/2);
  varargout{2} = eTHETA;
 end

% b) pmean(THETA,R), pmean(THETA,R,'p')
elseif  (nargin==2 && ~ischar(varargin{2})) || ...
        (nargin==3 && (ischar(varargin{2}) && strcmp(varargin{3},'p')))
 % Mean, std of polar/cylindrical first and second coordinate
 
 % Coordinates.
 THETA = varargin{1};
 R     = varargin{2};
 if numel(THETA)~=numel(R)
  error('CVARGAS:pmean:incorrectInputsSize',...
   'Size of THETA and R must be equal.')
 end
 ibad = ~isfinite(THETA);
 ibad(~ibad) = ~isfinite(R(~ibad));
 THETA(ibad) = [];
 R    (ibad) = [];
 
 % To cartesian.
 X = R.*cos(THETA);
 Y = R.*sin(THETA);
 
 % MEAN:
 mX = mean(X);
 mY = mean(Y);
 mTHETA = mod(atan2(mY,mX),2*pi);
 varargout{1} = mTHETA;
 if nargout>1
  mR  = abs(mX+1i*mY);
  varargout{2} = mR;
  if nargout>2
   % STD:
   eX = std(X);                          % | Fixed bug, Sep 2009
   eY = std(Y);                          % v
   eTHETA = abs(mod(abs(mY.*eX+1i*mX.*eY)./mR.^2+pi/2,pi)-pi/2);
   varargout{3} = eTHETA;
   if nargout==4
    eR = abs(mX.*eX+1i*mY.*eY)./mR; 
    varargout{4} = eR;
   end
  end
  
 end


% c) pmean(THETA,R,Z), pmean(THETA,R,Z,'p')
elseif (nargin==3 && ~ischar(varargin{3})) || ...
       (nargin==4 &&  strcmp(varargin{4},'p'))
 % Mean, std of polar/cylindrical all three coordinates
 
 % Coordinates.
 THETA = varargin{1};
 R     = varargin{2};
 Z     = varargin{3};
 if numel(THETA)~=numel(R) && numel(THETA)~=numel(Z)
  error('CVARGAS:pmean:incorrectInputsSize',...
   'Size of THETA, R and Z must be equal.')
 end
 ibad = ~isfinite(THETA);
 ibad(~ibad) = ~isfinite(R(~ibad));
 ibad(~ibad) = ~isfinite(Z(~ibad));
 THETA(ibad) = [];
 R    (ibad) = [];
 Z    (ibad) = [];
   
 % To cartesian.  
 X = R.*cos(THETA);
 Y = R.*sin(THETA);
 
 % MEAN:
 mX = mean(X);
 mY = mean(Y);
 mTHETA = mod(atan2(mY,mX),2*pi);
 varargout{1} = mTHETA;
 if nargout>1
  mR = abs(mX+1i*mY);
  varargout{2} = mR; 
  if nargout>2
   mZ = mean(Z);
   varargout{3} = mZ;
   if nargout>3
    % STD:
    eX = std(X);                            % | Fixed bug, Se 2009
    eY = std(Y);                            % v
    eTHETA = abs(mod(abs(mY.*eX+1i*mX.*eY)./mR.^2+pi/2,pi)-pi/2);
    varargout{4} = eTHETA;
    if nargout>4
     eR = abs(mX.*eX+1i*mY.*eY)./mR; 
     varargout{5} = eR;
     if nargout>5 
      eZ = std(Z);
      varargout{6} = eZ;
     end
    end
   end
  end
 end

% d) pmean(THETA,PHI,'s')
elseif nargin==3 && strcmp(varargin{3},'s')
 % Mean, std of spherical first ans second coordinate
 
 % Coordinates.
 THETA = varargin{1};
 PHI   = varargin{2};
 if numel(THETA)~=numel(PHI)
  error('CVARGAS:pmean:incorrectInputsSize',...
   'Size of THETA and PHI must be equal.')
 end
 ibad = ~isfinite(THETA);
 ibad(~ibad) = ~isfinite(PHI(~ibad));
 THETA(ibad) = [];
 PHI  (ibad) = [];
 
 % To cartesian.
 r = cos(PHI);
 X = r.*cos(THETA);
 Y = r.*sin(THETA);
 
 % MEAN:
 mX = mean(X);
 mY = mean(Y);
 mTHETA = mod(atan2(mY,mX),2*pi);
 varargout{1} = mTHETA;
 if nargout>1
  Z  = sin(PHI);
  mr = abs(mX+1i*mY);
  mZ = mean(Z);
  mPHI = mod(atan2(mZ,mr)+pi/2,pi)-pi/2;
  varargout{2} = mPHI; 
  if nargout>2
   % STD:
   eX = std(X);                            % | Fixed bug, Sep 2009
   eY = std(Y);                            % v
   eTHETA = abs(mod(abs(mY.*eX+1i*mX.*eY)./mr.^2+pi/2,pi)-pi/2);
   varargout{3} = eTHETA;
   if nargout>3
    eZ = std(Z);
    er = abs(mX.*eX+1i*mY.*eY)/mr;        % | Fixed bug, Sep 2009
    mR = abs(mr+1i*mZ);                   % v
    ePHI = abs(mod(abs(mZ.*er+1i*mr.*eZ)./mR.^2+pi/2,pi)-pi/2);
    varargout{4} = ePHI;
   end
  end
 end
 
% e) pmean(THETA,PHI,R,'s')
elseif nargin==4 && strcmp(varargin{4},'s')
 % Mean, std of spherical all three coordinates
 
 % Coordinates.
 THETA = varargin{1};
 PHI   = varargin{2};
 R     = varargin{3};
 if numel(THETA)~=numel(PHI) && numel(THETA)~=numel(R)
  error('CVARGAS:pmean:incorrectInputsSize',...
   'Size of THETA, PHI and R must be equal.')
 end
 ibad = ~isfinite(THETA);
 ibad(~ibad) = ~isfinite(PHI(~ibad));
 ibad(~ibad) = ~isfinite(R  (~ibad));
 THETA(ibad) = [];
 PHI  (ibad) = [];
 R    (ibad) = [];
 
 % To cartesian.
 r = R.*cos(PHI);
 X = r.*cos(THETA);
 Y = r.*sin(THETA);
 
 % MEAN:
 mX = mean(X);
 mY = mean(Y);
 mTHETA = mod(atan2(mY,mX),2*pi);
 varargout{1} = mTHETA;
 if nargout>1
  Z  = R.*sin(PHI);
  mr = abs(mX+1i*mY);
  mZ = mean(Z);
  mPHI = mod(atan2(mZ,mr)+pi/2,pi)-pi/2;
  varargout{2} = mPHI; 
  if nargout>2
   mR  = abs(mr+1i*mZ);
   varargout{3} = mR;
   if nargout>3
    % STD:
    eX = std(X);                            % | Fixed bug, Sep 2009
    eY = std(Y);                            % v
    eTHETA = abs(mod(abs(mY.*eX+1i*mX.*eY)./mr.^2+pi/2,pi)-pi/2);
    varargout{4} = eTHETA;
    if nargout>4
     er = abs(mX.*eX+1i*mY.*eY)./mr;       % | Fixed bug, Sep 2009
     eZ = std(Z);                          % v
     ePHI = abs(mod(abs(mZ.*er+1i*mr.*eZ)./mR.^2+pi/2,pi)-pi/2);
     varargout{5} = ePHI;
     if nargout>5
      eR = abs(mr.*er+1i*mZ.*eZ)./mR; 
      varargout{6} = eR;
     end
    end
   end
  end
 end

% f) pmean(X,'c')
elseif nargin==2 && strcmp(varargin{2},'c')
 % Mean, std of cartesian first coordinate
 
 % Coordinates.
 X = varargin{1};
 X(~isfinite(X)) = [];
 
 % MEAN:
 mX = mean(X);
 varargout{1} = mX;
 if nargout>1
  % STD:
  eX = std(X);
  varargout{2} = eX;
 end

% g) pmean(X,Y,'c')
elseif nargin==3 && strcmp(varargin{3},'c')
 % Mean, std of cartesian first and second coordinates
 
 % Coordinates.
 X = varargin{1};
 Y = varargin{2};
 if numel(X)~=numel(Y)
  error('CVARGAS:pmean:incorrectInputsSize',...
   'Size of X and Y must be equal.')
 end
 ibad = ~isfinite(X);
 ibad(~ibad) = ~isfinite(Y(~ibad));
 X(ibad) = [];
 Y(ibad) = [];
 
 % MEAN:
 mX = mean(X);
 varargout{1} = mX;
 if nargout>1
  mY = mean(Y);
  varargout{2} = mY;
  if nargout>2
   % STD:
   eX = std(X);
   varargout{3} = eX;
   if nargout>3
    eY = std(Y);
    varargout{4} = eY;
   end
  end
 end
 
% h) pmean(X,Y,Z,'c')
elseif nargin==4 && strcmp(varargin{4},'c')
 % Mean, std of cartesian all three coordinates
 
 % Coordinates.
 X = varargin{1};
 Y = varargin{2};
 Z = varargin{3};
 if numel(X)~=numel(Y) && numel(X)~=numel(Z)
  error('CVARGAS:pmean:incorrectInputsSize',...
   'Size of X, Y and Z must be equal.')
 end
 ibad = ~isfinite(X);
 ibad(~ibad) = ~isfinite(Y(~ibad));
 ibad(~ibad) = ~isfinite(Z(~ibad));
 X(ibad) = [];
 Y(ibad) = [];
 Z(ibad) = [];
 
 % MEAN:
 mX = mean(X);
 varargout{1} = mX;
 if nargout>1
  mY = mean(Y);
  varargout{2} = mY;
  if nargout>2
   mZ = mean(Z);
   varargout{3} = mZ;
   if nargout>3
    % STD:
    eX = std(X);
    varargout{4} = eX;
    if nargout>4
     eY = std(Y);
     varargout{5} = eY;
     if nargout>5
      eZ = std(Z);
      varargout{6} = eZ;
     end
    end
   end
  end
 end
 
else
 
 error('CVARGAS:pmean:unrecognizedInputs',...
  'Unrecognized input(s).')
 
end


% [EOF]   pmean.m