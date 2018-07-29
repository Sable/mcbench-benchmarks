function P = peakfit2d(Z)
% Find sub-sample location of a global peak within 2D-matrix by applying 
% two dimensional polynomial fit & extremum detection. 
%
% Sample usage: 
% >> M = exp(-((1:30) - 19.5).^2/(2*5^2)); % gauss: center=19.5; sigma=5
% >> P = peakfit2d(M'*M);                  % find peak in 2D-gauss
% >> disp(P);
%   19.5050   19.5050
%
% Algebraic solution derived with the following steps:
%
% 0.) Define Approximation-Function: 
%
%     F(x,y) => z = a*x^2+b*x*y+c*x+d+e*y^2+f*y
%
% 1.) Formulate equation for sum of squared differences with
%
%     x=-1:1,y=-1:1,z=Z(x,y)
%
%     SSD = [ a*(-1)^2+b*(-1)*(-1)+c*(-1)+d+e*(-1)^2+f*(-1) - Z(-1,-1) ]^2 + ...
%              ...
%             a*(+1)^2+b*(+1)*(+1)+c*(+1)+d+e*(+1)^2+f*(+1) - Z(-1,-1) ]^2
%        
% 2.) Differentiate SSD towards each parameter
%
%     dSSD / da = ...
%              ...
%     dSSD / df = ...
%
% 3.) Solve linear system to get [a..f]
%
% 4.) Differentiate F towards x and y and solve linear system for x & y
%
%     dF(x,y) / dx = a*... = 0 !
%     dF(x,y) / dy = b*... = 0 !

%% Check input
sZ = size(Z);
if min(sZ)<2
    disp('Wrong matrix size. Input matrix should be numerical MxN type.');
    P = [0 0];
    return;
end


%% peak approximation using 2D polynomial fit within 9 point neighbourship

% find global maximum and extract 9-point neighbourship
[v,p] = max(Z(:));
[yp,xp]=ind2sub(sZ,p); 
if (yp==1)||(yp==sZ(1))||(xp==1)||(xp==sZ(2))
    disp('Maximum position at matrix border. No subsample approximation possible.');
    P = [yp xp];
    return;
end
K = Z(yp-1:yp+1,xp-1:xp+1);

% approximate polynomial parameter
a = (K(2,1)+K(1,1)-2*K(1,2)+K(1,3)-2*K(3,2)-2*K(2,2)+K(2,3)+K(3,1)+K(3,3));
b = (K(3,3)+K(1,1)-K(1,3)-K(3,1));
c = (-K(1,1)+K(1,3)-K(2,1)+K(2,3)-K(3,1)+K(3,3));
%d = (2*K(2,1)-K(1,1)+2*K(1,2)-K(1,3)+2*K(3,2)+5*K(2,2)+2*K(2,3)-K(3,1)-K(3,3));
e = (-2*K(2,1)+K(1,1)+K(1,2)+K(1,3)+K(3,2)-2*K(2,2)-2*K(2,3)+K(3,1)+K(3,3));
f = (-K(1,1)-K(1,2)-K(1,3)+K(3,1)+K(3,2)+K(3,3));

% (ys,xs) is subpixel shift of peak location relative to point (2,2)
ys = (6*b*c-8*a*f)/(16*e*a-9*b^2);
xs = (6*b*f-8*e*c)/(16*e*a-9*b^2);

P = [ys+yp xs+xp];