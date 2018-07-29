function k=hullfit(x,y,p,fh)

%HULLFIT    Fit a polygon hull to a given data set so no data point is on
%           the outside of the hull. Enhancement of CONVHULL.
%
%   K = HULLFIT(X,Y,P)
%
% Inputs:   X,Y vectors of the same size containing the coordinates of the
%               data set points
%           P   fraction of longest hull line length to split hull lines
%               to. Default is 0.5.
% Output:   K   vector of indizes into X and Y containing the hull polygon
%               points in clockwise order.
%
% HULLFIT enhances the functionality of CONVHULL. While CONVHULL gives you
% a hull polygon of minimal outline length, HULLFIT tries to minimize the 
% polygon area by allowing only line lengths of (p * longest line).
% this might provide the possibility to skip unwanted interpolation effects
% and only use the inner area.
%
% Example:
% This example is a measurement set from a street curve
%
% load street;
% xi=linspace(min(x),max(x),100);
% yi=linspace(min(y),max(y),100);
% zi=griddata(x,y,z,xi,yi');
% pcolor(xi,yi,zi),shading interp,hold on
% plot(x,y,'k+');
% % pcolor shows unwanted interpolation effects, because it only uses
% % convhull. Show convhull:
% k=convhull(x,y);
% disp('CONVHULL only. Press return to continue.');
% pause
% plot(x(k),y(k),'k-');
% % Now use hullfit
% k=hullfit(x,y,0.1);
% plot(x(k),y(k),'r-')
% disp('Now HULLFIT also. Let's see what this can do for our plot:')
% [xx,yy]=meshgrid(xi,yi);
% in=inpolygon(xx,yy,x(k),y(k));
% zi(~in)=NaN;
% figure
% pcolor(xi,yi,zi),shading interp
%
% Also try k=hullfit(x,y,0.02); and see what happens to the left out areas
% of the data set.
%
%   programmed by Peter Wasmeier, Technical University of Munich
%   p.wasmeier@bv.tum.de
%   11-11-04



if nargin<3,p=.5;end
if nargin<2,error('hullfit needs at least two input arguments!'),end
if ~any(size(x)==1),error('hullfit needs x and y inputs be vectors of the same size!'),end
if ~all(size(x)==size(y)),error('hullfit needs x and y inputs be vectors of the same size!'),end

% Create starting convex hull
k=convhull(x,y);
% Calculate the angles from starting point to the second and to the last one
w1=pi-atan2(y(k(2))-y(k(1)),x(k(2))-x(k(1)));
w2=pi-atan2(y(k(end-1))-y(k(1)),x(k(end-1))-x(k(1)));
% From triangulation it is clear, that only if w1>w2 we have
% counterclockwise orientation of the k-index. In this case, change it to
% clockwise indexing.
if w1>w2,k=flipud(k);end

% Calculate maximum distance between two index points from hull
l=exdist(x(k),y(k));
% Calculate the maximum allowed length from user input p.
ll=p*l;

% Start a infinite loop to work on all hull lines which are too long
while 1
    % Calculate the actual longest line length l, its starting index m in the hull
    % vector k and the shortest hull line length mi
    [l,m,mi]=exdist(x(k),y(k));
    if l<=ll,break,end  % if no line is long enough to split
    % Initialize a counter for the added hull points in the following step
    ku=0;
    % Loop to add hull points, starting from the point with index m.
    while 1
        % If hull line length is short enough, no more points need to be
        % added.
        if sqrt((x(k(m))-x(k(m+1)))^2+(y(k(m))-y(k(m+1)))^2)<ll,break,end
        % Calculate the next point which fits on the hull.
        kn=npcw(x,y,k,m,m+1);
        % Add the point between the starting point with index m and the
        % follow-on.
        k=[k(1:m);kn;k(m+1:end)];
        % If no new point was successfully added, leave loop
        if isempty(kn),break,end
        % Otherwise increase counter of added points by one.
        ku=ku+1;
    end
    % If no point could be added in the last run, work is finished. Leave
    % master loop.
    if ~ku,break,end
    % From definition of adding new points in function npcw, we might have
    % added more points than necessary. Try, if we can leave some of them
    % away.
    % Create a starting index of hull points in k, which might possibly be
    % left out. The ending index of that group of points is of course
    % m+1+ku.
    % Start a loop to leave points out
    for i=m+1:m+1+ku
        % Look, if there is a point more far to the left hand side of the
        % bearing from hull point i to hull point m+1+ku. If this is not
        % the case, all points in between can be left out.
        [kn,lp]=npcw(x,y,k,i,m+1+ku);
        % If no point on the left is found, lp is equal to 0
        if ~lp
            % Delete all following hull points until m+1+ku and leave loop.
            k(i+1:m+ku)=[];
            break
        end
    end
end

% Helper functions

function [lmax,mi,lmin]=exdist(x,y)

s=sqrt(diff(x).^2+diff(y).^2);
mi=find(s==max(s));
lmax=s(mi);
lmin=min(s);


function [kn,lp]=npcw(x,y,k,ks,ke)
% Calculate the next fitting point for the hull and return its index kn.
% Calculation prinziple is simple:
% Because we know, that hull definition is clockwise, the next candidate
% for a hull point is those having the smallest positive angle with the
% hull line to intersect.
% second condition: the distance to a candidate must be smaller than the
% length of the line to intersect.
% Using this algorithm, either a point close to the starting point or clse
% to the ending point of the hull line is found.
kn=[];
% calculate all angles to the points
w=pi-atan2(y-y(k(ks)),x-x(k(ks)));
% Take the angle of the reference line (to be intersected)
wSE=w(k(ke));
% Calculate the angle differences
dw=w-wSE;
% Angles to starting and ending point would be zero and must be skipped.
dw(k(ke))=NaN;
dw(k(ks))=NaN;
% Second condition: calculate the distances
s=sqrt((x-x(k(ks))).^2+(y-y(k(ks))).^2);
% Take the distance of reference line
sSE=s(k(ke));
% Skip too long distances
dw(s>sSE)=NaN;
% Look if there are negative angles and if it is so, set the flag lp to 1
if min(dw)>0,lp=0;else,lp=1;end
% Find the index of the smallest angle
kn=find(dw==min(abs(dw)));
% if no points to calculate the angle to were left, the result is NaN. But
% wen want an empty variable to be returned instead.
if isnan(kn),kn=[];end

