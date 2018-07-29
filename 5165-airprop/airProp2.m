function varargout=airProp2(T, prop)
%----------------------------------------------
% Interpolates thermodynamic air properties
% Temp. range:  100-2500 K
% According to Eckert & Drake, Analysis of Heat
% and Mass Transfer, p. 780 
%
% Values are in SI-units:
%
% 	col-#	prop. 	units
%   ------------------------
%	1		T		K
%	2		rho		kg/m^3
%	3		cp		J/(kg K)
%	4		my		kg/ms
%	5		ny		m^2/s
%	6		k		W/(m K)
%	7		alpha	m^2/s
%	8		Pr		-
%
% Example 1:	out=airProp2(296, 'ny')
% Example 2:	
%	[cp, ny]=airProp2([333 444],{'cp' 'ny'})
%----------------------------------------------
% (c)2004 by Stefan Billig
%----------------------------------------------
% Last Change:	04-Jun-2004
%----------------------------------------------

% check # of input arguments
if ~isequal(nargin,2)
	error('airProp2 requires 2 input arguments!')
	return
	% check temperature request
elseif find(T<100)  | ~isnumeric(T)
	error('Valid temperature range: 100 <= T[K] <= 2500')
	return
end
% get table
load propTabAir2
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