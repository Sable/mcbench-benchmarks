function [t,dd]=make4(varargin)

% [t,dd] = make4(p,v,a,j,d,Ts,r,s)
%
% Calculate timing for symmetrical 4th order profiles. 
%
% inputs:
%      p    = desired path (specify positive)              [m]
%      v    = velocity bound (specify positive)            [m/s]
%      a    = acceleration bound (specify positive)        [m/s2]
%      j    = jerk bound (specify positive)                [m/s3]
%      d    = derivative of jerk bound (specify positive)  [m/s4]
%      Ts   = sampling time            [s]        (optional, if not specified or 0: continuous time)
%      r    = position resolution      [m]        (optional, if not specified: 10*eps) 
%      s    = number of decimals for digitized 
%             derivative of jerk bound            (optional, if not specified: 15)
%
% outputs:
%      t(1) = constant djerk phase duration
%      t(2) = constant jerk phase duration 
%      t(3) = constant acceleration phase duration 
%      t(4) = constant velocity phase duration 
%      
%       t1               t1               t1     t1  
%       .-.              .-.              .-.    .-.
%       | |              | |              | |    | |
%       | |t2    t3    t2| |   t4       t2| | t3 | |t2   
%       '-'--.-.----.-.--' '---------.-.--'-'----'-'--.-.--
%            | |    | |              | |              | |
%            | |    | |              | |              | |
%            '-'    '-'              '-'              '-'
%            t1     t1               t1               t1
%
% In case of discrete time, derivative of jerk bound d is reduced to dd and
% quantized to ddq using position resolution r and number of significant decimals s
% Two position correction terms are calculated to 'repair' the position error 
% resulting from using ddq instead of dd:
%   cor1  gives the number of position increments that can equally be divided 
%         over the entire trajectory duration
%   cor2  gives the remaining number of position increments
% The result is given as:
%                          dd = [ ddq  cor1  cor2  dd ]
%

%
% Copyright 2004, Paul Lambrechts, The MathWorks, Inc.
%

% Checking validity of inputs
if nargin < 5 || nargin > 8
   help make4
   return
else
   p=abs(varargin{1});
   v=abs(varargin{2});
   a=abs(varargin{3});
   j=abs(varargin{4});
   d=abs(varargin{5});
   if nargin == 5
      Ts=0; r=eps; s=15;
   elseif nargin == 6
      Ts=abs(varargin{6});
      r=eps; s=15;
  elseif nargin == 7
      Ts=abs(varargin{6});
      r=abs(varargin{7});
      s=15;
  elseif nargin == 8
      Ts=abs(varargin{6});
      r=abs(varargin{7});
      s=abs(varargin{8});
   end
end

if isempty(p) || isempty(v) || isempty(a) || isempty(j) || isempty(d) || ...
   isempty(Ts) || isempty(r) || isempty(s) 
   disp('ERROR: insufficient input for trajectory calculation')
   return
end

tol = eps;   % tolerance required for continuous time calculations
dd = d;      % required for discrete time calculations

% Calculation constant djerk phase duration: t1
t1  = (1/8*p/d)^(1/4) ;  % largest t1 with bound on derivative of jerk
if Ts>0  
   t1 = ceil(t1/Ts)*Ts;
   dd  = 1/8*p/(t1^4);
end
% velocity test
if v < 2*dd*t1^3           % v bound violated ?
   t1 = (1/2*v/d)^(1/3) ;  % t1 with bound on velocity not violated
   if Ts>0  
      t1 = ceil(t1/Ts)*Ts;
      dd  = 1/2*v/(t1^3);
   end
end
% acceleration test
if a < dd*t1^2         % a bound violated ?
   t1 = (a/d)^(1/2) ;  % t1 with bound on acceleration not violated
   if Ts>0  
      t1 = ceil(t1/Ts)*Ts;
      dd  = a/(t1^2);
   end
end
% jerk test
if j < dd*t1    % j bound violated ?
   t1 = j/d ;    % t1 with bound on jerk not violated
   if Ts>0  
      t1 = ceil(t1/Ts)*Ts;
      dd  = j/t1;
   end
end
d = dd;  % as t1 is now fixed, dd is the new bound on derivative of jerk

% Calculation constant jerk phase duration: t2
P = -1/9  * t1^2;                 % calculations to determine   
Q = -1/27 * t1^3  -  p/(4*d*t1);  % positive real solution of 
D = P^3 + Q^2;                    % third order polynomial...
R = ( -Q + sqrt(D) )^(1/3);       %
t2 = R - P/R - 5/3*t1 ;           % largest t2 with bound on jerk
if Ts>0  
   t2 = ceil(t2/Ts)*Ts;
   dd  = p/( 8*t1^4 + 16*t1^3*t2 + 10*t1^2*t2^2 + 2*t1*t2^3 );
end
if abs(t2)<tol, t2=0; end % for continuous time case
% velocity test
if v < (2*dd*t1^3 + 3*dd*t1^2*t2 + dd*t1*t2^2)   % v bound violated ?
   t2 = ( t1^2/4 + v/d/t1 )^(1/2) - 3/2*t1 ;     % t2 with bound on velocity not violated
   if Ts>0  
      t2 = ceil(t2/Ts)*Ts;
      dd = v/( 2*t1^3 + 3*t1^2*t2 + t1*t2^2 );
   end
end
if abs(t2)<tol, t2=0; end % for continuous time case
% acceleration test
if a < (dd*t1^2 + dd*t1*t2)  % a bound violated ?
   t2 = a/(d*t1) - t1 ;      % t2 with bound on acceleration not violated
   if Ts>0  
      t2 = ceil(t2/Ts)*Ts;
      dd  = a/( t1^2 + t1*t2 );
   end
end
if abs(t2)<tol, t2=0; end % for continuous time case
d = dd;  % as t2 is now fixed, dd is the new bound on derivative of jerk

% Calculation constant acceleration phase duration: t3
c1 = t1^2+t1*t2 ;                                       %
c2 = 6*t1^3 + 9*t1^2*t2 + 3*t1*t2^2 ;                   %
c3 = 8*t1^4 + 16*t1^3*t2 + 10*t1^2*t2^2 + 2*t1*t2^3 ;   %
t3 = (-c2 + sqrt(c2^2-4*c1*(c3-p/d)))/(2*c1) ;          % largest t3 with bound on acceleration
if Ts>0  
   t3 = ceil(t3/Ts)*Ts;
   dd = p/( c1*t3^2 + c2*t3 + c3 );
end
if abs(t3)<tol, t3=0; end % for continuous time case
% velocity test
if v < dd*(2*t1^3 + 3*t1^2*t2 + t1*t2^2 + t1^2*t3 + t1*t2*t3)  % v bound violated ?
   t3 = -(2*t1^3 + 3*t1^2*t2 + t1*t2^2 - v/d)/(t1^2 + t1*t2);  % t3, bound on velocity not violated
   if Ts>0  
      t3 = ceil(t3/Ts)*Ts;
      dd = v/( 2*t1^3 + 3*t1^2*t2 + t1*t2^2 + t1^2*t3 + t1*t2*t3 );
   end
end
if abs(t3)<tol, t3=0; end % for continuous time case
d = dd;  % as t3 is now fixed, dd is the new bound on derivative of jerk

% Calculation constant velocity phase duration: t4 
t4 = ( p - d*(c1*t3^2 + c2*t3 + c3) )/v ;  % t4 with bound on velocity
if Ts>0  
   t4 = ceil(t4/Ts)*Ts;
   dd = p/( c1*t3^2 + c2*t3 + c3 + t4*(2*t1^3 + 3*t1^2*t2 + t1*t2^2 + t1^2*t3 + t1*t2*t3) ) ;
end
if abs(t4)<tol, t4=0; end % for continuous time case

% All time intervals are now calculated
t=[t1 t2 t3 t4] ;

% This error should never occur !!
if min(t)<0
    disp('ERROR: negative values found')
end

% Quantization of dd and calculation of required position correction (decimal scaling)
if Ts>0
   x=ceil(log10(dd));          % determine exponent of dd
   ddq=dd/10^x;                % scale to 0-1
   ddq=round(ddq*10^s)/10^s;   % round to s  decimals
   ddq=ddq*10^x;
   % actual displacement obtained with quantized dd
   pp = ddq*( c1*t3^2 + c2*t3 + c3 + t4*(2*t1^3 + 3*t1^2*t2 + t1*t2^2 + t1^2*t3 + t1*t2*t3) ) ;
   dif=p-pp;          % position error due to quantization of dd
   cnt=round(dif/r);  % divided by resolution gives 'number of increments' 
                      % of required position correction
   % smooth correction obtained by dividing over entire trajectory duration
   tt = 8*t(1)+4*t(2)+2*t(3)+t(4);
   ti = tt/Ts;        % should be integer number of samples
   cor1=sign(cnt)*floor(abs(cnt/ti))*ti;   % we need cor1/ti increments correction at each 
                                           % ... sample during trajectory
   cor2=cnt-cor1;                          % remaining correction: 1 increment per sample 
                                           % ... during first part of trajectory
   dd=[ddq cor1 cor2 dd];
else
   dd=[dd 0 0 dd]; % continuous time result in same format
end

% Finished.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
