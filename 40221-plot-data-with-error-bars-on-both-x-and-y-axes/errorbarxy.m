function [varargout]=errorbarxy(varargin)
%   ERRORBARXY is a function to generate errorbars on both x and y axes 
%   with specified errors modified from codes written by Nils Sjöberg 
%   (http://www.mathworks.com/matlabcentral/fileexchange/5444-xyerrorbar)
%  
%   errorbarxy(x, y, lerrx, uerrx, lerry, uerry) plots the data with errorbars on both 
%   x and y axes with error bars [x-lerrx, x+uerrx] and [y-lerry, y+uerry]. If there is
%   no error on one axis, set corresponding lower and upper bounds to [].
%
%   errorbarxy(x, y, errx, erry) plots the data with errorbars on both x and
%   y axes with error bars [x-errx, x+errx] and [y-erry, y+erry]. If there 
%   is no error on one axis, set corresponding errors to [].
%   
%   errorbarxy(..., COLOR) plots data as well as errorbars in specified
%   colors. COLOR is a cell array of 3 element, {cData, cEBx, cEBy}, where
%   cData specifies the color of main plot, cEBx specifies the color of
%   errorbars along x axis and cEBy specifies the color of errorbars along
%   y axis. 
%   
%   errorbarxy(AX,...) plots into AX instead of GCA.
%   
%   H = errorbar(...) returns a vector of errorbarseries handles in H,
%   within which the first element is the handle to the main data plot and
%   the remaining elements are handles to the rest errorbars.
%
%   For example
%       x = 1:10;
%       xe = 0.5*ones(size(x));
%       y = sin(x);
%       ye = std(y)*ones(size(x));
%       H=errorbarxy(x,y,xe,ye,{'k', 'b', 'r'});
%    draws symmetric error bars on both x and y axes.
%
%   NOTE: errorbars are excluded from legend display. If you need to
%   include errorbars in legend display, do the followings:
%       H=errorbarxy(...);
%       arrayfun(@(d) set(get(get(d,'Annotation'),'LegendInformation'),...
%       'IconDisplayStyle','on'), H(2:end)); % include errorbars
%       hEB=hggroup;
%       set(H(2:end),'Parent',hEB);
%       set(get(get(hEB,'Annotation'),'LegendInformation'),...
%       'IconDisplayStyle','on'); % include errorbars in legend as a group.
%       legend('Main plot', 'Error bars');
%
%   Developed under Matlab version 7.10.0.499 (R2010a)
%   Created by Qi An
%   anqi2000@gmail.com

%   QA 2/7/2013 initial skeleton
%   QA 2/12/2013    Added support to plot on specified axes; Added support
%                   to specify color of plots and errorbars; Output a
%                   vector of errbar series handles; Fixed a couple of 
%                   minor bugs. 
%   QA 2/13/2013    Excluded errorbars from legend display.
%   QA 8/19/2013    Fixed a bug in errorbar cap display.
%   QA 9/24/2013    Fixed a bug in figure handle output.

%% handle inputs
if ishandle(varargin{1}) % first argument is a handle
    if get(varargin{1}, 'type', 'axes') % the handle is for an axes
        axes(varargin{1}); % set the handle to be current
    
        varargin=varargin(2:end);
    end
end
if length(varargin)<4
    error('Insufficient number of inputs');
    return;
end

%% assign values
x=varargin{1};
y=varargin{2};
if length(x)~=length(y)
    error('x and y must have the same number of elements!')
    return
end
color={'b', 'r', 'r'};
if length(varargin)==4 || length(varargin)==5 
    errx=varargin{3};
    erry=varargin{4};
    if ~isempty(errx)
        lx=x-errx;
        ux=x+errx;
    else
        lx=[];
        ux=[];
    end
    if ~isempty(erry)
        ly=y-erry;
        uy=y+erry;
    else
        ly=[];
        uy=[];
    end
    
    if length(varargin)==5
        color=varargin{5};
    end
elseif length(varargin)==6 || length(varargin)==7 
    lx=x-varargin{3};
    ux=x+varargin{4};
    ly=y-varargin{5};
    uy=y+varargin{6};
    if ~isempty(lx)
        errx=(ux-lx)/2;
    else
        errx=[];
    end
    if ~isempty(ly)
        erry=(uy-ly)/2;
    else
        erry=[];
    end
    
    if length(varargin)==7
        color=varargin{7};
    end
else
    error('Wrong number of inputs!');
end

%% plot data and errorbars
h=plot(x,y, 'color', color{1}); % main plot
[l1, l2, l3, l4, l5, l6, allh]=deal([]);
for k=1:length(x)
    if ~isempty(lx) & ~isempty(ly) % both errors are specified
        l1=line([lx(k) ux(k)],[y(k) y(k)]);
        hold on;
        l2=line([lx(k) lx(k)],[y(k)-0.1*erry(k) y(k)+0.1*erry(k)]);
        l3=line([ux(k) ux(k)],[y(k)-0.1*erry(k) y(k)+0.1*erry(k)]);
        l4=line([x(k) x(k)],[ly(k) uy(k)]);
        l5=line([x(k)-0.1*errx(k) x(k)+0.1*errx(k)],[ly(k) ly(k)]);
        l6=line([x(k)-0.1*errx(k) x(k)+0.1*errx(k)],[uy(k) uy(k)]);
    elseif isempty(lx) & ~isempty(ly) % x errors are not specified
        l4=line([x(k) x(k)],[ly(k) uy(k)]);
        hold on;
        errx=nanmean(abs(diff(x)));
        l5=line([x(k)-0.1*errx x(k)+0.1*errx],[ly(k) ly(k)]);
        l6=line([x(k)-0.1*errx x(k)+0.1*errx],[uy(k) uy(k)]);
    elseif ~isempty(lx) & isempty(ly) % y errors are not specified
        l1=line([lx(k) ux(k)],[y(k) y(k)]);
        hold on;
        erry=nanmean(abs(diff(y)));
        l2=line([lx(k) lx(k)],[y(k)-0.1*erry y(k)+0.1*erry]);
        l3=line([ux(k) ux(k)],[y(k)-0.1*erry y(k)+0.1*erry]);
    else % both errors are not specified
    end
    h1=[l1, l2, l3]; % all handles
    set(h1, 'color', color{2});
    h1=[l4, l5, l6]; % all handles
    set(h1, 'color', color{3});   
    allh=[allh, l1, l2, l3, l4, l5, l6]; % a list of all handles
end
arrayfun(@(d) set(get(get(d,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off'), allh); % exclude errorbars from legend
allh=[h, allh];
hold off

%% handle outputs
if nargout>0
    varargout{1}=allh;
end




















