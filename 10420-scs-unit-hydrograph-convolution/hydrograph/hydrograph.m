function [tq,q,tu,u,t,p,Q,code]=hydrograph(uhname,rdname,method,...
                                           K,D,R,Iar,A,CN,Tc,units)
% SCS Unit Hydrograph Convolution (R11)
%
% [tq,q,tu,u,t,p,Q,code]=hydrograph(uhname,rdname,method,...
%                                   K,D,R,Iar,A,CN,Tc,units)
%
% Input
%   uhname  dimensionless unit hydrograph filename
%   rdname  dimensionless rainfall distribution filename
%   method  interpolation method
%   K       peak factor
%   D       storm duration (hr)
%   R       rainfall depth (mm | in)
%   Iar     initial abstraction ratio
%   A       basin area (km^2 | ac)
%   CN      curve number
%   Tc      time of concentration (min)
%   units   units code
%             0 = imperial
%             1 = metric
%          
% Output   
%   tq      runoff hydrograph time (hr)
%   q       runoff hydrograph flow rate (cms | cfs)
%   tu      unit hydrograph time (hr)
%   u       unit hydrograph flow rate (cms | cfs)
%   t       rainfall-runoff time (hr)
%   p       cumulative rainfall (mm | in)
%   Q       cumulative runoff (mm | in)
%   code    return code
%             0 = fail
%             1 = pass
%
% Example:
%
%  uhname='library\gamma.duh'; rdname='library\scsii-024.drd'; K=484;
%  method='linear'; D=24; R=200; Iar=0.2; A=3; CN=75; Tc=90; units=1;
%  [tq,q,tu,u,t,p,Q,code]=hydrograph(uhname,rdname,method,...
%                                    K,D,R,Iar,A,CN,Tc,units)
%
% See also help\hydographui.html.

% Version 2.03 Copyright(c)2008
% Tom Davis (tdavis@metzgerwillard.com)
%
% Last revision: 03/16/2008

if units
  R=R/25.4;                             % rainfall depth (in)
  cm2cf=35.3146667214886;               % cubic meters to cubic feet
  %    =1e6/(12^3*2.54^3);
  sk2ac=247.105381467165;               % square kilometers to acres
  %    =1e10/(43560*12^2*2.54^2);
  A=A*sk2ac;                            % basin area (ac)
end
A =A/640;                               % basin area (mi^2)
Tc=Tc/60;                               % time of concentration (hr)
d =Tc/7.5;                              % rain burst duration (hr)
Tp=5*d;                                 % time to peak (hr)
method1=lower(method);
method2=method1;
uhname=lower(uhname);
code=1;

if ~isempty(findstr('triangle',uhname))
  uhname='triangle';
elseif ~isempty(findstr('gamma',uhname))
  uhname='gamma';
end

switch uhname                           % dimensionless unit hydrograph
  case 'triangle'
    Tb=3872/(3*K);                      % time base
    % =2(5280^2/60^2/12)/K
    uh=[0,0;1,1;Tb,0];                  % triangular distribution
    method1='linear';
  case 'gamma'
    f =K*3/1936;
    % =K/(5280^2/60^2/12)
    a0=0.045+0.5*f+5.6*f^2+0.3*f^3;     % cubic estimate
    options=optimset('display','off','tolx',eps);
    g =inline('gamma(a)*exp(a)/a^a-1/f','a','f');
    a =fzero(g,a0,options,f);
    tu=(0:0.2:round(2500/K))';
    u =(tu.*exp(1-tu)).^a;              % gamma distribution
    u(end)=0;                           % force zero ordinate
  otherwise
    uh=load(uhname);                    % tabular distribution
    [m,n]=size(uh);
    [umax,ndx]=max(uh(:,2));            %#ok umax not used
    umin=min(min(uh));
    if m<3 | n~=2 | umin<0 | uh(1,:)~=[0 0] | uh(ndx,:)~=[1 1] %#ok (R11)
      msgbox('Unit Hydrograph is improperly formed.',...
        'File Error','error','modal');
      tq=[];q=[];tu=[];u=[];t=[];p=[];Q=[];code=0;
      return
    end
end

if ~strcmp(uhname,'gamma')
  uh=[uh;uh(end,1)+0.2,0];              % force zero ordinate
  Tu=uh(:,1);
  U =uh(:,2);
  % resample unit hydrograph
  tu=(0:0.2:Tu(end))';
  u =interp1(Tu,U,tu,method1);
end

tu=Tp*tu;                               % unit hydrograph time (hr)
u =K*A*u/Tp;                            % unit hydrograph flow rate (cfs)
u(u<0)=0;

rd=load(rdname);                        % dimensionless rainfall distribution
[m,n]=size(rd);
rmax=max(max(rd));
rmin=min(min(rd));
if m<2 | n~=2 | rmin<0 | rmax>1 | rd(1,:)~=[0 0] | rd(end,:)~=[1 1] %#ok (R11)
  msgbox('Rainfall Distribution is improperly formed.',...
    'File Error','error','modal');
  tq=[];q=[];tu=[];u=[];t=[];p=[];Q=[];code=0;
  return
end

T =D*rd(:,1);
P =R*rd(:,2);
% resample rainfall distribution
t =(0:d:T(end))';                       % rainfall time (hr)
p =interp1(T,P,t,method2);              % rainfall depth (in)

Q =zeros(size(t));
s =1000/CN-10;                          % retention (in)
i =find(p>Iar*s);
Q(i)=(p(i)-Iar*s).^2./(p(i)+(1-Iar)*s); % runoff depth (in)
dQ=[diff(Q);0];                         % incremental runoff depth (in)
q =conv(dQ,u);                          % runoff flow rate (cfs)
q(q<0)=0;
tq=(0:d:t(end)+tu(end))';               % runoff time (hr)

if units
  u=u/cm2cf; q=q/cm2cf;                 % cms
  p=p*25.4; Q=Q*25.4;                   % mm
end
