function out=errorplot(x,y,dy,plottypes,dx);
% 
%  2 dimensional plot with error bars
%
%	By: P.S.Basran		6/17/03
%
%       Toronto-Sunnybrook Cancer Centre
%       Dept. Medical Physics
%       Parminder.Basran@sw.ca
%
%
%	
%	Function:
%		This function produces a two dimensional plot with error bars.
%		
%	Syntax:
% 		out=errorplot(x,y,dy,plottypes,dx)
%
%	Inputs:
%		    x - is a [1 x n] dimensional vector
%           y - is a [m x n] dimensional matrix for multidimensional plots
%          dy - is a [m x n] dimensional matrix whose dimensions must match those of y
%   plottypes - is a [1 x 4] dimensional vector whose entries specify the plottype in the
%               same fashion as the variable 's' in the function plot(x,y,s).
%               NOTE: current version of this requires the plottype to be specified in 
%               all instances, and to be 4 characters in length.
%          dx - is a real number that specifices the dimensions of the horizontal tics
%               for each error bar. The default value is 0.25 the dimension of x.
%
%	Outputs:
%		   - plot with legend, labeled '1', '2', etc.
%
%   Example:
%
%           %For a single plot:
%
%           x=[-10:1:10];
%           y1=x.^2;
%           dy1=0.3*y1.*rand(size(x)); % 
%           plottype1=[':   '];
%           errorplot(x,y1,dy1,plottype1);
%
%           % For multiple plots:
%
%           y2=0.5*x.^2;
%           dy2=0.2*y2.*rand(size(x)); % 
%           plottype2=['o-- '];
%           y=[y1; y2];
%           dy=[dy1; dy2];
%           errorplot(x,y,dy,[plottype1 plottype2],1);
%

%   Modification Log:
%       June 17 - 2003: alpha version
%       March 11 - 2004: fix for the plottypes ....thanks to Sean Verret
%


error(nargchk(2,5,nargin));

if nargin <5, dx=(x(2)-x(1))/4;
    if nargin < 4, plottypes='';
        if nargin < 3, dy='';
            [a,b]=size(y);
            for i=1:a, plot(x,y(i,:)); end % default to a regular plot for 2 inputs 
        end, end, end

%Provide plot and legend
[a,b]=size(y);
if a>b,
    y=y';
    [a,b]=size(y);
end

tx=[];
for i=1:a,
    plot(x,y(i,:),plottypes(4*(i-1)+1:4*i));;
    tx=[tx; 'plot ' num2str(i)];
    hold on;
end
legend(tx);

%Now the error bars
for i=1:a,
    for j=1:b,
        %horizontal lines
        line([x(j) x(j)], [y(i,j)-dy(i,j) y(i,j)+dy(i,j)]);
        %top vertical line
        line([x(j)-dx x(j)+dx], [y(i,j)+dy(i,j) y(i,j)+dy(i,j)]);
        %bottom vertical line
        line([x(j)-dx x(j)+dx], [y(i,j)-dy(i,j) y(i,j)-dy(i,j)]);
     end
end

hold off