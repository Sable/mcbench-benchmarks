%% How does limest work?
% How might one best compute the limit of a function at a specific point
% using numerical techniques? Since we need to compute a limit, the
% function will generally be singular in some fashion at that point.
% Either a discontinuity exists, or if we tried to evaluate the function,
% we might encounter a 0/0 problem. In either case, we need to infer the
% limit purely from function evaluations taken in the vicinity of the
% limit point. In some cases, we might even find that if we try to evaluate
% the function too closely to the point in question, there are numerical
% problems that occur.
%
% Likewise, if we sample our function too far away from the point, the
% function values will not be a good indicator of the limiting value.
%
% So an adaptive numerical tool must be careful, like Goldilocks in the
% fairy tale, it must find the middle ground.
%
% The approach taken by limest is to sample the function at a geometric
% sequence of points approaching the limit point. (See also my derivest
% tools and residueEst.)
%
% For example, suppose we wish to compute the limit of the function
% f(x) = sin(x)./x, at x = 0. (The limit is 1.) We cannot evaluate this
% function at 0, since MATLAB will return a NaN there. If we evaluate
% the function too far away from 0, then it will not be an accurate
% indicator of the true limit.
fun = @(x) sin(x)./x;
ezplot(fun)
format long g
fun(0)
fun(.000001)
fun(.001)

%%
% A somewhat worse test case is the function f(x) = exp(x) - 1 - x.
% Ezplot suggests the limit is 0.5 at x = 0.
fun = @(x) (exp(x) - 1 - x)./x.^2;
ezplot(fun,[-1,1])
grid on

%%
% At x = 0, we get NaN.
fun(0)

%%
% If we evaluate the function near the limit point, there are
% serious numerical problems. Below approximately sqrt(eps), this
% function returns pure garbage.
x = 10.^(-1:-1:-15)';
[x,fun(x)]

%%
% Limest solves this problem by choosing some offset, dx, from x0.
% Pick some small offset from the limit point, say 1e-8. Now,
% evaluate the function at a sequence of points:
%
%  x0 + dx, x0 + k*dx, x0 + k^2*dx, x0 + k^3*dx, ...
%
% The default in limest is to use the geometric factor of k = 4.
x0 = 0;
dx = 1e-8;
k = 4;
delta = dx*k.^[-10:15]'

%%
% Now, evaluate the function at each of these points, x0 + delta
fun = @(x) (exp(x) - 1 - x)./x.^2;
fun_of_x = fun(x0+delta);
[delta,fun_of_x]

%%
% Use a polynomial to fit a subsequence of points. Polyfit would do
% in a pinch, although more efficient methods are employed in practice.
% Note that if we look at the points that are very close to z0, then the
% polynomial may have strange coefficients.
%
% To compute the limit, we are really only interested in the value
% of the constant term for this polynomial model. Essentially, this
% is the extrapolated prediction of the limiting value of our product
% extrapolated down to delta = 0. In effect, this process is highly
% related to the idea of 
% <http://en.wikipedia.org/wiki/Richardson_extrapolation |Richardson extrapolation|>
% , except that we do not use a polynomial interpolant to derive the
% necessary coefficients. The use of a regression polynomial provides
% the error estimates from limest.
P = polyfit(delta(1:4),fun_of_x(1:4),2)

%%
% Our estimate of the limit at x = 0 is just P1(end), the constant term
% in the polynomial. Recall that the true limit for ths function was 0.5.
% This estimate is a poor one.
P(end)

%%
% A nice feature of this sequence of points, is we can re-use the
% function values for the points, adding one more to the end of the
% sequence, and dropping the first one in our call to polyfit. (By the
% way, limest carefully scales its problems to avoid the problems that
% polyfit would have seen. The actual code does not call polyfit anyway.
% For this example, I'll just turn off those warning messages.)
warning('off','MATLAB:polyfit:RepeatedPointsOrRescale')
P = zeros(23,3);
for i = 2:23
  P(i,:) = polyfit(delta(i:i+3),fun_of_x(i:i+3),2);
end
P

%%
% See how, as we move along this sequence using a sliding window of 4
% points, the constant terms will approach 0.5. Then
% at some point, we move just too far away from the pole, and our
% extrapolated estimate of the limit becomes poor again.
[delta(1:23),P(:,end)]

%%
% The trick is to learn from Goldilocks. Choose a prediction of
% the limit for some model that is not too close to the limit
% point, nor too far away. The choice is made by a simple
% set of rules. First, discard any predictions of the limit that are
% either NaN or inf. Then trim off a few more predictions, leaving
% only those predictions in the middle. Next, each prediction is made
% from a polynomial model with ONE more data point than coefficients
% to estimate. This yields an estimate of the uncertainty in the
% constant term using standard statistical methodologies. While a
% 95% confidence limit has no true statistical meaning, since the
% data is not truly random, we can still use the information.
%
% Limest chooses the model that had the narrowest confidence
% bounds around the constant term.
[res,errest] = limest(fun,0)

