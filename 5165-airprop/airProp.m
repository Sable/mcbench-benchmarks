function varargout=airProp(T, prop)
%---------------------------------------------
% Interpolates thermodynamic air properties
% Temp. range: 250 - 1200 K
% According to W. C. Reynolds, cp. Heywood,
% Internal Combustion Engine Fundamentals, 
% p. 127 and p. 912.
%
% Values are in SI-units:
%
% 	col-#	prop. 	units
%	------------------------
%	1		T		K
%	2		h		kJ/kg
%	3		u		kJ/kg
%	4		Psi		kJ/(kgK)
%	5		Fi		kJ/(kgK)
%	6		pr		-
%	7		vr		-
%	8		cp		kJ/(kgK)
%	9		cv		kJ/(kgK)
%
% Example 1:	out=airProp(304, 'Fi')
% Example 2:
% 		[h,u]=airProp([333 999],{'h' 'u'})
%---------------------------------------------
% (c)2004 by Stefan Billig
%---------------------------------------------
% Last Change:	19-May-2004
%---------------------------------------------

% check # of input arguments
if ~isequal(nargin,2)
	error('airProp requires 2 input arguments!')
	return
% check temperature request
elseif find(T<250) | find(T>1200) | ~isnumeric(T)
	error('Valid temperature range: 250 >= T[K] >= 1200')
	return
end
% get table
load propTabAir
% if multi property request
if iscell(prop)
	% scan along cells
	for idx=1:length(prop)
		% identify property column
		col=find(strcmp(propInfo,prop(idx)));
		if isempty(col)
			disp(['Property "' char(prop(idx)) '" not recognized!'])
		else
			% create output
			varargout{idx}=interp1(airTab(:,1),airTab(:,col),T);
		end
	end
% single property request
else
	% identify property column
	col=find(strcmp(propInfo,prop));
	if isempty(col)
		disp(['Property "' prop '" not recognized!'])
	else
		% create output
		varargout{1}=interp1(airTab(:,1),airTab(:,col),T);
	end
end
		