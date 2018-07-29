 function [yi,yxi,yxxi] = ppinterp( x, y, xi )

% PPINTERP 1-D piecewise parabolic interpolation/extrapolation of  
%    tabulated data and calculation of first and second derivatives. 
%    [YI,YXI,YXXI] = PPINTERP(X,Y,XI) interpolates function values, 
%    first and second derivatives using the rows/columns (X,Y) at 
%    the nodes specified in the vector XI. Either X and Y should contain 
%    at least three values, otherwise the function will return an 
%    empty output. 
%    The vector X specifies the points at which the data Y is
%    given. Out of range values are extrapolated, but it is up 
%    to the user to decide if the extrapolated data can be of any 
%    use. Vectors YI, YXI and YXXI are same size as XI.
%    X and XI can be non-uniformly spaced, but repeated values in X 
%    will be removed and the resulting vector will be sorted. 
%
%    Requires bindex.m (available at Matlab FEX). 
%
% Examples: 
%          x = [0.1:0.1:0.3 1:3]; y = sin( x );
%          xi = linspace(0,3,200); 
%          [yi,yxi,yxxi] = ppinterp(x,y,xi);
%	   figure(1)
%	   plot(x,y,'o',xi,yi,'r-'), box on, grid on
%          xlabel('x')
%          ylabel('y(x)')
%          title('Continuity test')
%          legend('exact','ppinterp')
%
%          n = 101; m = n; 
%          x = linspace(0,2*pi,n); 
%          y = sin( x ); yx = cos( x ); yxx = -y; 
%          xi = 2*pi*rand(1,m); 
%          [yi,yxi,yxxi] = ppinterp(x,y,xi);
%	   figure(2)
%          subplot(311)
%	   plot(x,y,xi,yi,'o'), box on, grid on
%          title('y(x)')
%          legend('exact','ppinterp')
%	   subplot(312)
%	   plot(x,yx,xi,yxi,'o'), box on, grid on
%	   title('dy/dx')
%          legend('exact','ppinterp')
%          subplot(313)
%	   plot(x,yxx,xi,yxxi,'o'), box on, grid on
%	   title('d^2y/dx^2')
%          legend('exact','ppinterp')
% 
%          n = 2001; m = 5001; 
%          x = linspace(0,2*pi,n); 
%          y = sin( x ); yx = cos( x ); yxx = -y; 
%          xi = sort( 2*pi*rand(1,m) );
%          [yi,yxi,yxxi] = ppinterp(x,y,xi);
%	   figure(3)
%          subplot(311)
%	   plot(x,y,'o',xi,yi,'r-'), box on, grid on
%          ylabel('y(x)')
%          title('Large dataset test')
%          legend('exact','ppinterp')
%	   subplot(312)
%	   plot(x,yx,'o',xi,yxi,'r-'), box on, grid on
%	   ylabel('dy/dx')
%          legend('exact','ppinterp')
%          subplot(313)
%	   plot(x,yxx,'o',xi,yxxi,'r-'), box on, grid on
%	   ylabel('d^2y/dx^2')
%          legend('exact','ppinterp') 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First  version: 04/11/2007
% Second version: 13/11/2007
% Third  version: 20/11/2007
% Fourth version: 23/11/2007
% 
% Contact: orodrig@ualg.pt
% 
% Any suggestions to improve the performance of this 
% code will be greatly appreciated. 
% 
% Algorithm implemented: given xi find the point x(j) given in the 
% tabulated data, such that x(j) < = xi < x(j+1). 
% Let us call x(j), x(j+1) and x(j+2) as x1, x2 and x3. 
% Corresponding function values will be y1, y2 and y3. Between 
% those points the function can be interpolated as 
 
% y(xi) = a1( xi - x2 )(xi - x3 ) + a2( xi - x1 )( xi - x3 ) + a3( xi - x1 )( xi - x2 ).
% 
% From the conditions y(x1) = y1, y(x2) = y2 and y(x3) = y3 it follows that 
%   
%              y1                        y2                        y3
% a1 = ------------------ , a2 = ------------------ , a3 = ------------------ .  
%      (x1 - x2)(x1 - x3)        (x2 - x1)(x2 - x3)        (x3 - x1)(x3 - x2)
% 
% Therefore, the first and second derivatives become  
% 
%  dy
% ---- = a1*( 2*xi - x2 - x3 ) + a2*( 2*xi - x1 - x3 ) + a3*( 2*xi - x1 - x2 )
%  dx
% 
% and 
% 
%  d2y
% ----- = 2*( a1 + a2 + a3 )
%  dx2
% 
% Extrapolation is included in order to avoid NaNs when xi is outside the interval [x1,xn]. 
% However, it is up to the user to decide it the extrapolated values are of any use.  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Let's go: 

% Declare an empty output just in case calculations won't be 
% performed: 

  yi = [];
 yxi = [];
yxxi = [];

sx  = size(x);
sy  = size(y);
sxi = size(xi); 

nx = length(x); 
ny = length(y); 

% Error checking: 

if nargin ~= 3 
error('This function requires three input arguments...');
end

if nx ~= ny 
error('The length of x must match the length of y...')
end 

if min(sx) ~= 1 
error('Input x should be a row or column vector...')
end

if min(sy) ~= 1 
error('Input y should be a row or column vector...')
end 

if min(sxi) ~= 1 
error('Input xi should be a row or column vector...')
end 

% Be sure that x, xi and y are row vectors: 

x  =  x(:)'; 
xi = xi(:)';
y  =  y(:)';

m  = length(xi);

% Remove repeated elements: 

[x,ix] = unique(x);

y = y(ix);

nx = length(x); 
ny = length(y); 

% Proceed with calculations only when the # of function points 
% is greater than 2:

if nx > 2 
       
       nmax = 1001; mmax = 1001; 
       
       yi = zeros(1,m);
      yxi = zeros(1,m);
     yxxi = zeros(1,m);
     
        j =  ones(1,m); 
	          
% Get x1, x2 and x3:
       
       j = bindex(xi,x,0);
       
       j( ( j == 0 ) ) = 1;
       
       j( ( j == nx - 1 )|( j == nx ) ) = nx - 2;
       
       x1 = x( j );
       x2 = x(j+1);
       x3 = x(j+2);

        q = [(x1-x2).*(x1-x3);(x2-x1).*(x2-x3);(x3-x1).*(x3-x2)];
        p = [(xi-x2).*(xi-x3);(xi-x1).*(xi-x3);(xi-x1).*(xi-x2)];
       
       Mx = [2.0*xi-x2-x3;2.0*xi-x1-x3;2.0*xi-x1-x2];
       
        if m == 1 
	a = y([j;j+1;j+2])'./q;
	else
        a = y([j;j+1;j+2])./q;
        end
       
       yi =     sum( a.*p  , 1 ); 
      yxi =     sum( a.*Mx , 1 );
     yxxi = 2.0*sum( a     , 1 );
     
% Return output data with same size as input data:  

       yi = reshape(  yi,sxi);
      yxi = reshape( yxi,sxi);
     yxxi = reshape(yxxi,sxi);

end 
