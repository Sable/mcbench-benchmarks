% Author: John D'Errico
% Release: 2.0
% Release date: 8/8/06
% What follows are example usages of polyfitn, polyvaln, poly2sympoly, polyn2sym

%% Fit a 1-d model to cos(x). We only need the even order terms.
x = -2:.1:2;
y = cos(x);
p = polyfitn(x,y,'constant x^2 x^4 x^6')

if exist('sympoly') == 2
  % Conversion to a sympoly. If nothing else, its a nice way to display the model.
  polyn2sympoly(p)
end
if exist('sym') == 2
  % Conversion to a symbolic form. Its also nice.
  polyn2sym(p)
end

% Evaluate the regression model at some set of points
polyvaln(p,[0 .5 1])

%% A surface model in 2-d, with all terms up to third order.

% Use lots of data.
n = 1000;
x = rand(n,2);
y = exp(sum(x,2)) + randn(n,1)/100;
p = polyfitn(x,y,3)

if exist('sympoly') == 2
  polyn2sympoly(p)
end
if exist('sym') == 2
  polyn2sym(p)
end

% Evaluate on a grid and plot:
[xg,yg]=meshgrid(0:.05:1);
zg = polyvaln(p,[xg(:),yg(:)]);
surf(xg,yg,reshape(zg,size(xg)))
hold on
plot3(x(:,1),x(:,2),y,'o')
hold off

%% A linear model, but with no constant term, in 2-d
uv = rand(100,2);
w = sin(sum(uv,2));
p = polyfitn(uv,w,'u, v');
if exist('sympoly') == 2
  polyn2sympoly(p)
end
if exist('sym') == 2
  polyn2sym(p)
end

%% A model with various exponents, not all positive integers.

% Note: with only 1 variable, x & y may be row or column vectors.
x = 1:10;
y = 3 + 2./x + sqrt(x) + randn(size(x))/100;
p = polyfitn(x,y,'constant x^-1 x^0.5');
if exist('sympoly') == 2
  polyn2sympoly(p)
end
if exist('sym') == 2
  polyn2sym(p)
end

xi = 1:.1:10;
yi = polyvaln(p,xi);
plot(x,y,'ro',xi,yi,'b-')


