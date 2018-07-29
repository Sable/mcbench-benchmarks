function overlap = overlap_ellipses(x0,y0,a0,b0,theta0,x1,y1,a1,b1,theta1)

overlap = -1;
%x0 = 15; y0=13; a0 = 30; b0 = 5; theta0 = 2/4*pi;
%x1 = 20; y1=20; a1 = 30; b1 = 5; theta1 = 2/4*pi; image_size=4096;

%% First ellipse overlap check
% First try the easiest check, which is whether the distance between the
% two centers if less than the minimum possible distance between the two
% centers, i.e., b0 + b1.  If so, overlap = 1 and no other checks are
% needed. If the distance is greater than the maximum possible, then
% overlap = 0.

DIST = [x1-x0;y1-y0]';
NORM = sqrt(DIST(:,1).^2+DIST(:,2).^2);
if NORM < b0 + b1; overlap = 1; end;
if NORM > a0 + a1; overlap = 0; end;

%% Second ellipse overlap check
% This check is a little more complicated.  First, a certain number of
% points (NOP) on the ellipses are generated. Then, the distances between
% ellipse 0 (or 1) and the points on ellipse 1 (or 0, respectively) are
% calculated.  If any of these points is less than the minimum distance for
% that ellipse (b0 or b1), then overlap = 1.  Conversely, if all points are
% greater than the maximum distance, a0 or a1, then the ellipses cannot
% overlap, i.e., overlap = 0.

if overlap == -1;

    NOP = 2^(5);
    THETA=linspace(0,2*pi,NOP);
    x = a0*cos(THETA);
    y = b0*sin(THETA);
    X0 = cos(theta0)*x - sin(theta0)*y;
    Y0 = sin(theta0)*x + cos(theta0)*y;
    X0 = X0 + x0;
    Y0 = Y0 + y0;

    x = a1*cos(THETA);
    y = b1*sin(THETA);
    X1 = cos(theta1)*x - sin(theta1)*y;
    Y1 = sin(theta1)*x + cos(theta1)*y;
    X1 = X1 + x1;
    Y1 = Y1 + y1;

    %figure; hEllipse = plot(X0,Y0,'bo'); axis equal; hold on; hEllipse = plot(X1,Y1,'ro'); axis equal;

    % Check distances for severe overlaps
    DIST = [X1-x0;Y1-y0]';
    NORM = sqrt(DIST(:,1).^2+DIST(:,2).^2);
    if min(NORM) < b1; overlap = 1; end;
    if min(NORM) > a1; overlap = 0; end;

    % Check distances for severe overlaps
    DIST = [X0-x1;Y0-y1]';
    NORM = sqrt(DIST(:,1).^2+DIST(:,2).^2);
    if min(NORM) < b0; overlap = 1; end;
    if min(NORM) > a0; overlap = 0; end;
end

%% Third ellipse overlap check
% First, only use points on the ellipses that can possibly overlap.  This
% works for most ellipses, but there may still be a few bugs (that will be
% corrected later).  For each of these points, the closest point on the
% other ellipse is calculated.  Then, using a vector-based criterion for
% each point, the overlap is calculated.

if overlap == -1
    % Only use points that could possibly overlap
    Ys = (Y1-y0); s = Ys == 0; Ys(s) = 0.01;
    TAN = atan((X1-x0)./Ys);
    if max(abs(diff(TAN))) > pi/2
        m = sort(diff(TAN),'descend');
        n = find(diff(TAN)==m(1));
        o = find(diff(TAN)==m(end));
        if o<n; p = o+1:n; TAN(p) = TAN(p)+pi; end
        if o>n; p = n+1:o; TAN(p) = TAN(p)+pi; end
    end
    n = find(gradient(TAN)>0); m = find(gradient(TAN)<0); 
    if length(n)>length(m); n=m; end;
    X1 = X1(n); Y1=Y1(n);

    % Only use points that could possibly overlap
    Ys = (Y0-y1); s = Ys == 0; Ys(s) = 0.01;
    TAN = atan((X0-x1)./Ys);
    if max(abs(diff(TAN))) > pi/2
        m = sort(diff(TAN),'descend');
        n = find(diff(TAN)==m(1));
        o = find(diff(TAN)==m(end));
        if o<n; p = o+1:n; TAN(p) = TAN(p)+pi; end
        if o>n; p = n+1:o; TAN(p) = TAN(p)-pi; end
    end
    n = find(gradient(TAN)>0); m = find(gradient(TAN)<0); 
    if length(n)>length(m); n=m; end;
    X0 = X0(n); Y0=Y0(n);

    %figure; hEllipse = plot(X0,Y0,'bo'); axis equal; hold on; hEllipse = plot(X1,Y1,'ro'); axis equal;

    % Only check point with shortest distance away
    clear CLOSE;
    j = length(X0);
    CLOSE(1:length(X0),1:3) = 0;
    for i = 1:length(X0)
        DIST = [X0(i)-X1;Y0(i)-Y1]';
        NORM = sqrt(DIST(:,1).^2+DIST(:,2).^2);
        n = find(NORM == min(NORM));
        if length(n) == 1
            CLOSE(i,1) = sort(NORM(n));
            CLOSE(i,2) = i;
            CLOSE(i,3) = n;
        elseif length(n) == 2
            CLOSE(i,1) = NORM(n(1));
            CLOSE(i,2) = i;
            CLOSE(i,3) = n(1);
            j = j + 1;
            CLOSE(j,1) = NORM(n(2));
            CLOSE(j,2) = i;
            CLOSE(j,3) = n(2);
        end
    end
    
    % Weed out points that are furthest away
    n = ceil(length(X0)/2);
    if n > 2;
        CLOSE_sort = sort(CLOSE); m = CLOSE_sort(n);
        o = CLOSE(:,1) > m; CLOSE(o,:) = [];
    end

    if size(CLOSE,1) < 3; 
      overlap = 1; % Something screwy going on - REJECT
    else
      for ii = 1:size(CLOSE,1)
        i = CLOSE(ii,2);
        if i == 1; j = 1; else j=i-1; end;
        if i == length(X0); k = length(X0); else k=i+1; end;
        r12 = [X0(k)-X0(j) Y0(k)-Y0(j)];
        r1 = [r12(2) -r12(1)]; %normal to ellipse
        rc = [x0-X0(i) y0-Y0(i)];
        n = dot(r1,rc);
        if n < 0; r1 = -r1; end;
        
        j = CLOSE(ii,3);
        r2 = [X1(j)-X0(i) Y1(j)-Y0(i)];
        n = dot(r1,r2);
        if n > 0; overlap = 1; break; end;
        if overlap == 1; break;end
      end
    end
end

%% Last overlap step
% Last, if none of the checks found an overlap between the two ellipses,
% then the overlap is 0.

if overlap == -1;
    overlap = 0;
end
