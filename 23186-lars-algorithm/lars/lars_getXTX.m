function XTX = lars_getXTX(xin, no_xtx)
% Utility function for lars function
%
% Example:
%     XTX = lars_getXTX(x);
%     sol = lars(y, x, 'lasso', maxKernels, XTX); % for a big big big matrix x. In this case, x should be normalized before do x'*x as shown above.
%
% Note: This does not reduce the time, but if you reuse x for various y
%       sets, then you can run lars_getXTX once and use it in lars over
%       and over again. Good for neurons with the same stimulus set.
% Important: If no_xtx is 1, then, return value does not calculate xtx.
%

global RESOLUTION_OF_LARS;
lars_init();

[x,mx,sx,ignores] = lars_scale(xin);             % scale x -> mean = 0, norm = 1, ignores is a list of too small vectors

if nargin==1 | (nargin==2 & no_xtx==0)
    xtx = x'*x;             % Do this once to save time.
    %{
    A very important thing that following codes do is that if there are
    duplicating columns, then it selects only the first appearing one, 
    and make sx(size info) of other columns inf, so that those are
    ignored by remaining portion of this lars function.
        "all_candidate = find(sx<inf)" does this.
    It increases the possibility to get inverse of Ga (invga in this function).
    But, it does not remove all multicolinearity.
    %}
    dup_columns = find(sum(abs(triu(xtx,1))>1-RESOLUTION_OF_LARS*min(100,length(xtx)))>1-RESOLUTION_OF_LARS*min(100,length(xtx)));
    sx(dup_columns) = inf;
end

all_candidate = find(sx<inf);  % we are not interested in zero-variance predictors.

XTX.x = x;
XTX.mx = mx;
XTX.sx = sx;
XTX.ignores = ignores;
XTX.all_candidate = all_candidate;
if nargin==1 | (nargin==2 & no_xtx==0)
    XTX.dup_columns = dup_columns;
    XTX.xtx = xtx;
end

return;