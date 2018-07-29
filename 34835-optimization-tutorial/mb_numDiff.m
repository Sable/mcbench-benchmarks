function dp = mb_numDiff(func,p,h)

% 2010 m.bangert@dkfz.de
% numerical differentiation df(x) = (df(x+h)-df(x))/h
%
% func - function handle
% p    - x
% h    - delta_x
%
% example : mb_numDiff(@(x) x(1)^2+x(1)*x(2),[1 1],1e-3)

if nargin < 2
    error('mb_numDiff(func,p,h) needs at least 2 input arguments\n')
end
if nargin < 3
    h  = 1e-8;
end

dp = NaN*p;

oldObjFuncValue = func(p);

for i = 1:numel(p)
    
    p_new    = p;
    p_new(i) = p_new(i) + h;
    
    newObjFuncValue = func(p_new);
    
    dp(i) = (newObjFuncValue-oldObjFuncValue)/h;

end

end
