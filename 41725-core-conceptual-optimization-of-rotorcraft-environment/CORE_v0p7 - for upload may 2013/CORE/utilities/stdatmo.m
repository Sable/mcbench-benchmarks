function [rho,a,temp,press,kvisc,ZorH]=stdatmo(H_in,Toffset,Units,GeomFlag)
%  STDATMO Find gas properties in earth's atmosphere.
%   [rho,a,T,P,nu,ZorH]=STDATMO(H,dT,Units,GeomFlag)
% 
%   STDATMO by itself gives the atmospheric properties at sea level on a
%   standard day.
%
%   STDATMO(H) returns the properties of the 1976 Standard Atmosphere at
%   geopotential altitude H (meters), where H is a scalar, vector, matrix,
%   or ND array.
%
%   STDATMO(H,dT) returns properties when the temperature is dT degC offset
%   from standand conditions. H and dT must be the same size or else one
%   must be a scalar.
%
%   STDATMO(H,dT,Units) defines units for the input H and all outputs. Note
%   that dT is always in degrees Celcius/Kelvin. Options are SI (default)
%   or US (a.k.a. Imperial, English). For SI, set Units to [] or 'SI'. For
%   US, set Units to 'US'. Input and output units may be different by
%   passing a cell array of the form {Units_in Units_out}, e.g. {'US'
%   'SI'}. Units are as follows:
%       Input:                        SI (default)    US
%           H:     Altitude           m               ft
%           dT:    Temp. offset       degC/degK       degC/degK
%       Output:
%           rho:   Density            kg/m^3          slug/ft^3
%           a:     Speed of sound     m/s             ft/s
%           T:     Temperature        K               R
%           P:     Pressure           Pa              lbf/ft^2
%           nu:    Kinem. viscosity   m^2/s           ft^2/s
%           ZorH:  Height or altitude m               ft
%
%   STDATMO(H,dT,Units,GeomFlag) returns properties at geometric altitude
%   input H instead of the normal geopotential altitude.
%
%   [rho,a,T,P,nu]=STDATMO(H,dT,...) returns atmospheric properties the
%   same size as H and/or dT (P does not vary with temperature offset and
%   is always the size of H)
%
%   [rho,a,T,P,nu,ZorH]=STDATMO(H,...) returns either geometric height, Z,
%   (GeomFlag not set) or geopotential height, H, (GeomFlag set).
% 
%   Example 1: Find atmospheric properties at every 100m of geometric
%   height for an off-standard atmosphere with temperature offset varying
%   +/- 25 degC sinusoidally with a period of 4km.
%       Z = 0:100:86000;
%       [rho,a,T,P,nu,H]=stdatmo(Z,25*sin(pi*Z/2000),'',true);
%       semilogx(rho/stdatmo,H/1000)
%       title('Density variation with sinusoidal off-standard atmosphere')
%       xlabel('\sigma'); ylabel('Altitude (km)')
% 
%   Example 2: Create tables of atmospheric properties up to 30000ft for a
%   cold (-15degC), standard, and hot (+15degC) day with columns
%   [h(ft) Z(ft) rho(slug/ft3) sigma a(ft/s) T(R) P(psf) µ(slug/ft-s) nu(ft2/s)]
%   using 3-dimensional array inputs.
%       [~,h,dT]=meshgrid(0,-5000:1000:30000,-15:15:15);
%       [rho,a,T,P,nu,Z]=stdatmo(h,dT,'US',0);
%       Table = [h Z rho rho/stdatmo(0,0,'US') T P nu.*rho nu];
%       format short e
%       ColdTable       = Table(:,:,1)
%       StandardTable   = Table(:,:,2)
%       HotTable        = Table(:,:,3)
%
%   Example 3: Find the SI dynamic pressure, Mach number, Reynolds number,
%   and stagnation temperature of an aircraft flying at flight level FL500
%   (50000ft) with speed 250m/s and characteristic length of 2m.
%       V = 250; c = 2;
%       [rho,a,T,P,nu]=stdatmo(50000,[],{'us' 'si'});
%       Dyn_Press = 1/2*rho*V^2;
%       M = V/a;
%       Re = V*c/nu;
%       T0 = T*(1+(1.4-1)/2*M^2);
% 
%   This atmospheric model is not recommended for use at altitudes above
%   86km geometric height (84852m/278386ft geopotential) and returns NaN
%   for altitudes above 90km geopotential.
%
%   Author:     Sky Sartorius
%               www.mathworks.com/matlabcentral/fileexchange/authors/101715
% 
%   References: ESDU 77022
%               www.pdas.com/atmos.html

if nargin == 0
    H_in = 0;
end

if nargin < 2 || isempty(Toffset)
    Toffset = 0;
end

if nargin < 3 && all(H_in(:) <= 11000)
    TonTi=1-2.255769564462953e-005*H_in;
    press=101325*TonTi.^(5.255879812716677);
    temp = TonTi*288.15 + Toffset;
    rho = press./temp/287.05287;

    if nargout > 1
        a = sqrt(401.874018 * temp);
        if nargout == 5
            kvisc = (1.458e-6 * temp.^1.5 ./ (temp + 110.4)) ./ rho;
        end
    end
    return
end

% index   Lapse rate   Base Temp     Base Geopo Alt        Base Pressure
%   i     Ki(degC/m)    Ti(degK)        Hi(m)               P (Pa)
D =[1       -.0065      288.15          0                   101325
    2       0           216.65          11000               22632.0400950078
    3       .001        216.65          20000               5474.87742428105
    4       .0028       228.65          32000               868.015776620216
    5       0           270.65          47000               110.90577336731
    6       -.0028      270.65          51000               66.9385281211797
    7       -.002       214.65          71000               3.9563921603966
    8       0           186.94590831019 84852.0458449057    0.373377173762337  ];
    
% Constants
R=287.05287;	%N-m/kg-K; value from ESDU 77022
% R=287.0531;   %N-m/kg-K; value used by matlab aerospace toolbox ATMOSISA
gamma=1.4;
g0=9.80665;     %m/sec^2
RE=6356766;     %Radius of the Earth, m
Bs = 1.458e-6;  %N-s/m2 K1/2
S = 110.4;      %K

K=D(:,2);	%degK/m
T=D(:,3);	%degK
H=D(:,4);	%m
P=D(:,5);	%Pa

temp=zeros(size(H_in));
press=temp;   
hmax = 90000;

if nargin < 3 || isempty(Units)
    Uin = false;
    Uout = Uin;
elseif isnumeric(Units)
    Uin = Units;
    Uout = Uin;
else
    if ischar(Units) %input and output units the same
        Unitsin = Units; Unitsout = Unitsin;
    elseif iscell(Units) && length(Units) == 2
        Unitsin = Units{1}; Unitsout = Units{2};
    elseif iscell(Units) && length(Units) == 1
        Unitsin = Units{1}; Unitsout = Unitsin;
    else
        error('Incorrect Units definition. Units must be ''SI'', ''US'', or 2-element cell array')
    end

    if strcmpi(Unitsin,'si')
        Uin = false;
    elseif strcmpi(Unitsin,'us')
        Uin = true;
    else error('Units must be ''SI'' or ''US''')
    end

    if strcmpi(Unitsout,'si')
        Uout = false;
    elseif strcmpi(Unitsout,'us')
        Uout = true;
    else error('Units must be ''SI'' or ''US''')
    end
end

% Convert from imperial units, if necessary.
if Uin
    H_in = H_in * 0.3048;
end

% Convert from geometric altitude to geopotental altitude, if necessary.
if nargin < 4
    GeomFlag = false;
end
if GeomFlag
	Hgeop=(RE*H_in)./(RE+H_in);
else
    Hgeop=H_in;
end

n1=(Hgeop<=H(2));
n2=(Hgeop<=H(3) & Hgeop>H(2));
n3=(Hgeop<=H(4) & Hgeop>H(3));
n4=(Hgeop<=H(5) & Hgeop>H(4));
n5=(Hgeop<=H(6) & Hgeop>H(5));
n6=(Hgeop<=H(7) & Hgeop>H(6));
n7=(Hgeop<=H(8) & Hgeop>H(7));
n8=(Hgeop<=hmax & Hgeop>H(8));
n9=(Hgeop>hmax);

% Troposphere
if any(n1)
	i=1;
	TonTi=1+K(i)*(Hgeop(n1)-H(i))/T(i);
	temp(n1)=TonTi*T(i);
	PonPi=TonTi.^(-g0/(K(i)*R));
	press(n1)=P(i)*PonPi;
end

% Tropopause
if any(n2)
	i=2;
	temp(n2)=T(i);
	PonPi=exp(-g0*(Hgeop(n2)-H(i))/(T(i)*R));
	press(n2)=P(i)*PonPi;
end

% Stratosphere 1
if any(n3)
	i=3;
	TonTi=1+K(i)*(Hgeop(n3)-H(i))/T(i);
	temp(n3)=TonTi*T(i);
	PonPi=TonTi.^(-g0/(K(i)*R));
	press(n3)=P(i)*PonPi;
end

% Stratosphere 2
if any(n4)
	i=4;
	TonTi=1+K(i)*(Hgeop(n4)-H(i))/T(i);
	temp(n4)=TonTi*T(i);
	PonPi=TonTi.^(-g0/(K(i)*R));
	press(n4)=P(i)*PonPi;
end

% Stratopause
if any(n5)
	i=5;
	temp(n5)=T(i);
	PonPi=exp(-g0*(Hgeop(n5)-H(i))/(T(i)*R));
	press(n5)=P(i)*PonPi;
end

% Mesosphere 1
if any(n6)
	i=6;
	TonTi=1+K(i)*(Hgeop(n6)-H(i))/T(i);
	temp(n6)=TonTi*T(i);
	PonPi=TonTi.^(-g0/(K(i)*R));
	press(n6)=P(i)*PonPi;
end

% Mesosphere 2
if any(n7)
	i=7;
	TonTi=1+K(i)*(Hgeop(n7)-H(i))/T(i);
	temp(n7)=TonTi*T(i);
	PonPi=TonTi.^(-g0/(K(i)*R));
	press(n7)=P(i)*PonPi;
end

% Mesopause
if any(n8)
	i=8;
	temp(n8)=T(i);
	PonPi=exp(-g0*(Hgeop(n8)-H(i))/(T(i)*R));
	press(n8)=P(i)*PonPi;
end

if any(n9)
    disp('Warning: one or more altitudes above upper limit.')
    temp(n9)=NaN;
    press(n9)=NaN;
end

temp = temp + Toffset;

rho = press./temp/R;

if nargout >= 2
    a = sqrt(gamma * R * temp);
    if nargout >= 5
        kvisc = (Bs * temp.^1.5 ./ (temp + S)) ./ rho; %m2/s
        if nargout == 6
            if GeomFlag % Geometric in, ZorH is geopotential altitude (H)
                ZorH = Hgeop;
            else % Geop in, find Z
                ZorH = RE*Hgeop./(RE-Hgeop);
            end
        end
    end
end
    
if Uout %convert to imperial units if output in imperial units
    rho = rho / 515.3788;
    if nargout >= 2
        a = a / 0.3048;
        temp = temp * 1.8;
        press = press / 47.88026;
        if nargout >= 5
            kvisc = kvisc / 0.09290304;
            ZorH = ZorH / 0.3048;
        end
    end
end

% Credit for elements of coding scheme:
% cobweb.ecn.purdue.edu/~andrisan/Courses/AAE490A_S2001/Exp1/atmosphere4.m

% Revision history:
%   V1.0    5 July 2010
%   V1.1    8 July 2010
%       Update to references and improved input handling
%   V2.0    12 July 2010
%       Changed input ImperialFlag to Units. Units must now be a string or
%       cell array {Units_in Units_out}. Version 1 syntax works as before.
%       Two examples added to help
%   V2.1    15 July 2010
%       Changed help formatting
%       Sped up code - no longer caclulates a or nu if outputs not
%       specified. Also used profiler to speed test against ATMOSISA, which
%       is consistently about 5 times slower than STDATMO
%           17 July 2010
%       Cleaned up Example 1 setup using meshgrid
%           26 July 2010
%       Switched to logical indexing, which sped up running Example 1
%       significantly(running [rho,a,T,P,nu,h]=stdatmo(Z,dT,'US',1) 1000
%       times: ~.67s before, ~.51s after)
%   V3.0    7 August 2010
%       Consolodated some lines for succintness
%       Changed Hgeop output to be either geopotential altitude or
%       geometric altitude, depending on which was input. Updated help and
%       examples accordingly.
%   V3.1    27 August 2010
%       Added a very quick, troposhere-only section
%   V3.2    23 December 2010
%       Minor changes, tested on R2010a, and sinusoidal example added