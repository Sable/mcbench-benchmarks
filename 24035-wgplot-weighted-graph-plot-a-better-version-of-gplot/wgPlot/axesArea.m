function [hAx]=axesArea(varargin)
%function [hAx]=axesArea(hAx,varargin)
%
% Set the margine of the axis by specifying a vector of distance to the figure edges.
%
% Input:
%  [varargin=hAx] = axis handle
%    [varargin=p] = position spec: 1, 2 or 4 element vector that specify the distance 
%                   from the edges of the figure by a percentage number between (0-49). 
%                   If 1 element it is used for all margins. 
%                   If 2 elements, p=[x-margins, y-margins].
%                   If 4 elements, p=[left, lower, right, upper] margins.
% Output:
%  [hAx] = axis handle of the axes.
%
% See also: axis, axes, ishandle, set
%
% By: Michael Wu  --  michael.wu@lithium.com (Mar 2009)
%
%====================


% Check if 1st input is axis handle
%--------------------
if ishghandle(varargin{1},'axes')
	hAx=varargin{1};
	p=varargin{2};
else
	hAx=gca;
	p=varargin{1};
end


% Process input arguments
%--------------------
p(p<0)=0;
p(p>49)=49;
p=p/100;


% Compute position property to be set
%--------------------
switch length(p)
	case 1
		xmin=p;
		ymin=xmin;
		xlen=1-2*p;
		ylen=xlen;
	case 2
		xmin=p(1);
		ymin=p(2);
		xlen=1-2*p(1);
		ylen=1-2*p(2);
	case 4
		xmin=p(1);
		ymin=p(2);
		xlen=1-p(1)-p(3);
		ylen=1-p(2)-p(4);	
	otherwise
		% Default Matlab position setting
		%--------------------
		xmin=0.13;
		ymin=0.11;
		xlen=0.775;
		ylen=0.815;	
end


% Set new position property of the axes
%--------------------
set(hAx,'position',[xmin ymin xlen ylen]);





