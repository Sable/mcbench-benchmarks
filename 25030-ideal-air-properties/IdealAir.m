function IdealAir(xi,prop1,prop2,unit)
%	======================================================
%
% This program interpolates air properties following the Ideal Gas Law from
% the gas table A22 and A22e in the textbook Fundamentals of Engineering
% Thermodynamics by Moran, Shapiro (6th edition)
%
% Input parameters explained:
%   xi: The known parameter, related to property prop1.  Can be a single
%       integer or a 1-dimensional matrix
%   prop1: The known property, related to xi
%   prop2: The unknown quantity searched for, related to output desired
%   unit: unit system used, either 'si' for SI units or 'eng' for english
%         units.  This is OPTIONAL!  Leave blank for SI units.
%
% Properties valid for prop1 and prop2
% 	prop* 	| units (si)  | units (eng)     | Description
%	------------------------------------------------
%	T		| K           | R               | Temperature
%	h		| kJ/kg       | Btu/lbm         | Enthalpy
%	u		| kJ/kg       | Btu/lbm         | Internal Energy
%	pr		| -           | -               | Relative Pressure
%	vr		| -           | -               | Relative Volume
%	so		| kJ/(kg*K)   | Btu/(lbm*R)     | Entropy
%
% Examples of the program in use:
%   Input:  IdealAir(2.5,'so','h')
%   Output: h = 664.0107
%
%	Input:  IdealAir([632,1100,1987],'T','so','eng')
%   Output: so = 0.63853     0.77422     0.93023
%
% Written by Jared Miller for Professor Kevin Cole
% Last modified: August 14, 2009
% -Added "load *.mat" function in place of excel reading
% -Made units optional, default to si
%
%	======================================================

%Checks to see the units asked for, then opens the file with appropriate
%units.  If the units are undefined, the program defaults to SI units.
unittest=exist('unit','var');
if unittest==0
    load a22si.mat x
else
if strcmp(unit,'si')==1
    load a22si.mat x
elseif strcmp(unit,'eng')==1
    load a22eng.mat x
else
    error('Units not specified correctly.  Valid entries: si,eng (lower case) or leave blank for default si')
end
end
temp=x;

%Check to see which properties are being asked for and then picks the right
%range for x and y.
if strcmp(prop1,'T')==1
    x=temp(:,1);
elseif strcmp(prop1,'h')==1
    x=temp(:,2);
elseif strcmp(prop1,'pr')==1
    x=temp(:,3);
elseif strcmp(prop1,'u')==1
    x=temp(:,4);
elseif strcmp(prop1,'vr')==1
    x=temp(:,5);
elseif strcmp(prop1,'so')==1
    x=temp(:,6);   
else
    error('Prop1 not specified correctly.  Valid entries: T,h,u,pr,vr,so (case sensitive)')
end
if strcmp(prop2,'T')==1
    y=temp(:,1);
elseif strcmp(prop2,'h')==1
    y=temp(:,2);
elseif strcmp(prop2,'pr')==1
    y=temp(:,3);
elseif strcmp(prop2,'u')==1
    y=temp(:,4);
elseif strcmp(prop2,'vr')==1
    y=temp(:,5);
elseif strcmp(prop2,'so')==1
    y=temp(:,6);   
else
    error('Prop2 not specified correctly.  Valid entries: T,h,u,pr,vr,so (case sensitive)')    
end
    
%checks to see that xi lies within the valid range of x
xmax=max(x);
xmin=min(x);
ximax=max(xi);
ximin=min(xi);
if ximax>xmax
    str = num2str(xmax);
    str2 = num2str(ximax);
    error([prop1,' value (',str2,') is too large.  Maximum ',prop1,' value is ',str])       
elseif ximin<xmin
    str = num2str(xmin);   
    str2 = num2str(ximin);
    error([prop1,' value (',str2,') is too small.  Minimum ',prop1,' value is ',str])   
end    

%Interpolates using built-in MATALB interpolate function, interp1
IdealAir=interp1(x,y,xi);

%displays on screen (optional step)
    disp([prop2,' = ',num2str(IdealAir)]);
