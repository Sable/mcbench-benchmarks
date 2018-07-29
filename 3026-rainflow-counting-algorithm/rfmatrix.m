function [m,mx,my]=rfmatrix(rf,x,y,flagx,flagy)
% rfmatrix - rain flow matrix estimation
%
% function [m,mx,my] = rfmatrix(rf,x,y,flagx,flagy)
%
% Syntax: rfmatrix(rf)
%         rfmatrix(rf,x,y)
%         rfmatrix(rf,x,y,flagx,flagy)
%         [m,mx,my] = rfmatrix(...)
%
% Input: rf          - rainflow data - output from rainflow function,
%        x,y         - numbers of bins in x and y direction,
%        flagx,flagy - strings,
%                      'ampl' for amplitude,
%                      'mean' for mean value,
%                      'freq' for frequency and 'period' for
%                      time period of extracted cycles.
%
% Output: m     - rainflow matrix,
%         mx,my - the bin locations respectively to x and y.

% By Adam Nies³ony, 16-Aug-2003
% Revised, 10-Nov-2009
% Visit the MATLAB Central File Exchange for latest version.

error(nargchk(1,5,nargin))
if nargin<5,
    flagy='mean';
    if nargin<4,
        flagx='ampl';
        if nargin<3,
            y=10;
            if nargin<2,
                x=10;
            end
        end
    end
end

% rainflow data
if flagx(1)=='m',
    xdata=rf(2,:);
elseif flagx(1)=='f',
    xdata=rf(5,:).^-1;
elseif flagx(1)=='p',
    xdata=rf(5,:);
else
    xdata=rf(1,:);
end

if flagy(1)=='m',
    ydata=rf(2,:);
elseif flagy(1)=='f',
    ydata=rf(5,:).^-1;
elseif flagy(1)=='p',
    ydata=rf(5,:);
else
    ydata=rf(1,:);
end
cdata=rf(3,:);

x=x(:)';
y=y(:)';

if length(x) == 1
    minx = min(xdata);
    maxx = max(xdata);
    binwidth = (maxx - minx) ./ x;
    xx = minx + binwidth*(0:x);
    xx(length(xx)) = maxx;
    x = xx(1:length(xx)-1) + binwidth/2;
else
    xx = x;
    minx = min(xdata);
    maxx = max(xdata);
    binwidth = [diff(xx) 0];
    xx = [xx(1)-binwidth(1)/2 xx+binwidth/2];
end

if length(y) == 1
    miny = min(ydata);
    maxy = max(ydata);
    binwidth = (maxy - miny) ./ y;
    yy = miny + binwidth*(0:y);
    yy(length(yy)) = maxy;
    y = yy(1:length(yy)-1) + binwidth/2;
else
    yy = y;
    miny = min(ydata);
    maxy = max(ydata);
    binwidth = [diff(yy) 0];
    yy = [yy(1)-binwidth(1)/2 yy+binwidth/2];
end
% x, y - center of the intervals in xx and yy, respectively

srf=zeros(length(y),length(x));
rf=[xdata; ydata; cdata];

rfk=find(ydata>=yy(1) & ydata<=yy(2));
if ~isempty(rfk),
    srf(1,:)=rfhist(rf(:,rfk),x,'ampl');
end

for k=2:length(y),
    rfk=find(ydata>yy(k) & ydata<=yy(k+1));
    if ~isempty(rfk),
        srf(k,:)=rfhist(rf(:,rfk),x,'ampl');
    end
end

% plot if no output exist
if nargout==0,
    h=bar3(y,srf,1);
    for i=1:length(h)
        c=repmat(srf(:,i)',4*6,1);
        c=reshape(c,4,6*length(y))';
        c(c==0)=NaN;
        set(h(i),'CData',c)
        c=get(h(i),'XData');
        set(h(i),'XData',(max(x)-min(x))/(length(x)-1)*(c-1)+min(x))
    end
    set(gca,'XTickMode','auto')
    grid on
    xlabel(['X - ' flagx])
    ylabel(['Y - ' flagy])
    zlabel('number of cycles')
    title('rainflow matrix')
    axis tight
elseif nargout==1
    m=srf;
elseif nargout==2
    m=srf;
    mx=x;
elseif nargout==3
    m=srf;
    mx=x;
    my=y;
end