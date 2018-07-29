function [p,h,inds] = figreg( f, n, varargin )
%Perform regression on the current axis in a figure.
%f is the figure handle, while n is the order of the
%regression (polynom order). A red line is plotted in the regression area.
%Returns the polynom coefficients in p, and the handle to the line red
%line. If you do not want the red line you can just delete it afterwards:
%f=figure; plot( x,y );
%[p,h] = figreg( f, n ); delete(h);
%[p,h,inds] = figreg( f, n ); %return also the indexes chosen
%[p,h,inds] = figreg( f, n, l ); %input also handle to line to run
%regression on
%Author Ivar Smith

ax = gca(f);
c = get(ax,'children');
if numel(c)==0
    error('Empty figure...');
end

if ~isempty(varargin)
    l = varargin{:};
    c = c(c==l);
end

x = get(c,'XData'); if iscell(x), x = x{1}; end
y = get(c,'YData'); if ~iscell(y), y = {y}; end
t = get(get(ax,'title'),'string');
interpreter = get(get(ax,'title'),'interpreter');

while 1
    title('Please select start of regression');
    [x1,y1] = ginput(1);
    title('Please select end of regression');
    [x2,y2] = ginput(1);
    if x1<min(x), x1 = min(x); end
    if x2>max(x), x2 = max(x); end
    xtmp1 = find(x>=x1); if x1<0 xtmp1=xtmp1(end); else xtmp1=xtmp1(1); end
    xtmp2 = find(x>=x2); if x2<0 xtmp2=xtmp2(end); else xtmp2=xtmp2(1); end
    inds = xtmp1:xtmp2;
    if isempty(inds)
        warndlg('Empty regression region... Try again', '');
        continue;
    end
    xtmp = x(inds); p=cell(size(y));
    hold on; h=[];
    for i=1:numel(y)
        ytmp = y{i}(inds);
        p{i} = polyfit( xtmp, ytmp, n );
        h(end+1)=plot( xtmp, polyval( p{i}, xtmp ), '-r', 'linewidth', 1 );
    end
    hold off;
    answer = questdlg('Is this ok','','Yes', 'No', 'Yes');
    if strcmpi(answer,'yes')
        break;
    else
        delete(h);
    end
end
title(t,'interpreter',interpreter);

if numel(p)==1
    p=p{:};
end

