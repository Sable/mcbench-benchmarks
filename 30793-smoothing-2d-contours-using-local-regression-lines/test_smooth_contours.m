
% by Tolga Birdal
%{
    This file contains both the implementation and the test function for
    contour smoothing. So to test, just press F5.
    The contour smoothing is done by projecting all the contour points 
    onto the local regression line. The radius defines the number of points
    on each side of the contour, which will contribute to the computation
    of the local regression line. The higher the number of points, the
    smoother the curve. 
    
    Because of the linear nature of fitting, when too much smoothing is 
    desired,  the algorithm loses important features such as corners, and
    confuses in such critical regions.

    Actually, the algorithm is fully parallelizable. If a parallel
    implemtation is desired the main loop in smooth_contours function can
    easily be parallelized.

    You can check further details in the comments.
%}
function test_smooth_contours()

close all;
I=imread('c:\Data\hand_contour.png');

% to binary
L=logical(I);

% get the start point for bwtraceboundary
[y x]=find(L==1);

% get the contour
contour = bwtraceboundary(L, [47,187], 'E', 8);

% smooth the contour
[Ys Xs]=smooth_contours(contour(:,1), contour(:,2), 21);

out=zeros(size(I));
ind=sub2ind(size(I),round(Ys), round(Xs));
out(ind)=1;
figure,imshow(out);

% show both
figure, subplot(1,2,1), scatter(x,y);
subplot(1,2,2), scatter(Xs, Ys);

end

% The actual computation
function [Xs Ys]=smooth_contours(X, Y, Radius)

Xs=zeros(length(X),1);
Ys=zeros(length(X),1);

% copy out-of-bound points as they are
Xs(1:Radius)=X(1:Radius);
Ys(1:Radius)=Y(1:Radius);
Xs(length(X)-Radius:end)=X(length(X)-Radius:end);
Ys(length(X)-Radius:end)=Y(length(X)-Radius:end);

% obtain the bounding box
maxX=max(max(X));
minX=min(min(X));
maxY=max(max(Y));
minY=min(min(Y));

% smooth now
for i=Radius+1:length(X)-Radius
    ind=(i-Radius:i+Radius);
    xLocal=X(ind);
    yLocal=Y(ind);
    
    % local regression line
    %p=polyfit(xLocal,yLocal,1);
    [a b c] = wols(xLocal,yLocal,gausswin(length(xLocal),5));
    p(1)=-a/b;
    p(2)=-c/b;
    
    % project point on local regression line
    [x2, y2]=project_point_on_line(p(1), p(2), X(i), Y(i));
    
    % check erronous smoothing
    % points should stay inside the bounding box
    if (x2>=minX && y2>minY && x2<=maxX && y2<=maxY)
        Xs(i)=x2;
        Ys(i)=y2;
    else
        Xs(i)=X(i);
        Ys(i)=Y(i);
    end
end

end

% Projects the point (x1, y1) onto the line defined as y=m1*x+b1
function [x2, y2]=project_point_on_line(m1, b1, x1, y1)

m2=-1./m1;
b2=-m2*x1+y1;
x2=(b2-b1)./(m1-m2);
y2=m2.*x2+b2;

end

function [a b c] = wols(x,y,w)
% Weighted orthogonal least squares fit of line a*x+b*y+c=0 to a set of 2D points with coordiantes given by x and y and weights w
n = sum(w);
meanx = sum(w.*x)/n;
meany = sum(w.*y)/n;
x = x - meanx;
y = y - meany;
y2x2 = sum(w.*(y.^2 - x.^2));
xy = sum(w.*x.*y);
alpha = 0.5 * acot(0.5 * y2x2 / xy) + pi/2*(y2x2 > 0);
%if y2x2 > 0, alpha = alpha + pi/2; end
a = sin(alpha);
b = cos(alpha);
c = -(a*meanx + b*meany);
end