function [lineHandle, lineData] = implot2(varargin)
% IMPLOT2: Plots implicit functions.
%
%  [H,DATA] = IMPLOT2(F,RANGE,N) plots an implicit function of exactly 2
%    variables (e.g 'x' and 'y', but any variables will work). 
%    * F is a MATLAB inline function defined in form F(x,y)=0
%    * RANGE = [xmin xmax ymin ymax] is the range over which F is plotted
%    * N is no. of grid-points, per variable, in the discretisation used
%      to calculate the plot ==> total no. grid-points ~ N^2
%    * H is a handle to the plotted lineseries object; lineData is a
%      two-row matrix containing the plotted x and y data. Each contiguous
%      line segment is demarcated by a pair of NaN values.
%
%  IMPLOT2(F), IMPLOT2(F,RANGE) plots as above, but using the default
%    values {RANGE}=[-2*pi,2*pi,-2*pi,2*pi] and {N}=100 (as applicable)
%   
%  IMPLOT2(...,S,'PropertyName1',PropertyValue1,...) plots as above, but
%    with parameter/value pairs specifying additional line properties, as
%    per syntax in PLOT.m. Type DOC LINESERIESPROPERTIES for more info.
%    S is an optional 1,2 or 3-element character string specifying line 
%    color, marker and/or style, also as per PLOT.m syntax.
%
%  Example -- plot [2*sin(y)=x],  [x^2+y^2=4], [sin(x)*cos(y)=pi/30]:  
%     
%       f=inline('2*sin(y)-x','x','y'); g=inline('x^2+y^2-4','x','y');
%       h=inline('sin(x)*cos(y)-pi/30','x','y'); 
%       rangexy = [-2 2 -2 2]; hold on;
%       implot2(f,'LineWidth',2,'Color',[0 0 1]); 
%       implot2(g,rangexy,200,'g-','LineWidth',2);      
%       [h,data] = implot2(h,'r:');  axis equal;
%
%   ---      AUTHOR:     Vinesh Rajpaul (UCT)
%   ---      VERSION:    16 May 2009
%
%   See also INLINE, PLOT, CONTOUR, CONTOURC

%% Specify default parameters
ngrid=100;                              % default: 100*100 gridpoints
rangexy=[-2*pi,2*pi,-2*pi,2*pi];        % default [x,y] range
lineSpec ='k-';                         % default linestyle
 
%% Check number of input arguments; extract contourgroup properties

for i=1:nargin
   if ischar(varargin{i})
       propertyIndex = i;               % index of first line property
       break
   end
end

if exist('propertyIndex','var')
    properties = varargin(propertyIndex:nargin);
    if mod(length(properties),2)~=0
       lineSpec = properties{1};   % treat character string S separately
       properties(1)=[];
    end
    nargs = propertyIndex-1;
else nargs = nargin;
end

if nargs < 1 || nargs >3
    error('MATLAB:implot:InvalidInput', ...
          '1 to 3 plotting arguments required. Type HELP IMPLOT2.')
end

switch nargs
    case 1;      % only an inline function specified
        fun = varargin{1};
    case 2;      % as for nargin==1, with range also specified
        [fun,rangexy] = deal(varargin{1:nargs});
    otherwise    % as for nargin==2, with gridpoints also specified
        [fun,rangexy,ngrid]=deal(varargin{1:nargs});
end
 
%% Set up mesh grid; do plotting

xGrid=linspace(rangexy(1),rangexy(2),ngrid);
yGrid=linspace(rangexy(3),rangexy(4),ngrid);
[x,y]=meshgrid(xGrid,yGrid);
 
fvector=vectorize(fun);         % vectorize the inline function
fvalues=feval(fvector,x,y);
cMatrix = contourc(xGrid,yGrid,fvalues,[0,0]);

variables = symvar(fun);        % extract variables from inline function    

lineData = separateLines(cMatrix);  % separate contiguous lines
lineHandle = plot(lineData(1,:),lineData(2,:),lineSpec);
xlabel(variables(1)); ylabel(variables(2)); box on;

if exist('properties','var')    % apply all specified line properties
    nProps = length(properties);
    set(lineHandle,properties(1:2:nProps),properties(2:2:nProps));
end

end

%% Demarcate contiguous line segments by NaN tokens
% (Mainly to facilitate plotting of noncontiguous segments via PLOT.m)
   
function lineData = separateLines(cMatrix)
    lineData = cMatrix;
    index = 1;                   % index of line segment demarcation
    while index<length(lineData)
       numPoints = round(lineData(2,index));    % no. datapoints in line
       lineData(:,index)= NaN;   % demarcate each contiguous line by NaN
       index = index + numPoints +1;            % advance to next token
    end
end
