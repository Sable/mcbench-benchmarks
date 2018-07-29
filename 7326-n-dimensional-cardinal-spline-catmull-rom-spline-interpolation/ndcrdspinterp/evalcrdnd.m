% % Evaluate (interpolate) N-dimensional cubic Cardinal Spline
% % at given value of parameter u (a single value)


% % INPUT
% % P0,P1,P2,P3:  Given four points in N-dimional space such that
% %               P1 & P2 are endpoints of spline.
% %               P0 & P3 are used to calculate the slope of the endpoints
% %               (i.e slope of P1 & P2).
% %               For example: for 2-dimensional data P0=[x, y],
% %               For example: for 3-dimensional data P0=[x, y, z]
% %               similar analogy for P1, P2, AND P3

% % T: Tension (T=0 for Catmull-Rom type)
% % u: parameter value, spline is evaluated at u

% % OUTPUT
% % Pu: Evaluated (interpolated) values of cardinal spline at 
% %     parameter value u. Pu values are in N-dimensional space.

function [Pu] =evalcrdnd(P0,P1,P2,P3,T,u)

Pu=[];

s= (1-T)./2;
% MC is cardinal matrix
MC=[-s     2-s   s-2        s;
    2.*s   s-3   3-(2.*s)   -s;
    -s     0     s          0;
    0      1     0          0];

for i=1:length(P0)
    G(:,i)=[P0(i);   P1(i);   P2(i);   P3(i)];
end

U=[u.^3    u.^2    u    1];

for i=1:length(P0)
    Pu(i)=U*MC*G(:,i);
end

% % --------------------------------
% % This program or any other program(s) supplied with it does not provide any
% % warranty direct or implied.
% % This program is free to use/share for non-commerical purpose only. 
% % Kindly reference the author.
% % Author: Dr. Murtaza Khan
% % Author Reference : http://www.linkedin.com/pub/dr-murtaza-khan/19/680/3b3
% % Research Reference: http://dx.doi.org/10.1007/978-3-642-25483-3_14
% % --------------------------------
