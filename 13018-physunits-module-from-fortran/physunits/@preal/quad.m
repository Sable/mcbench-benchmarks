function p3=quad(fun,p1,p2)
%PREAL/QUAD Overloaded quad function for class PREAL.
%
% Limitations: preal/quad only supports the basic quad syntax.
%   q = quad(fun,a,b)

global useUnitsFlag

p1=preal(p1);
p2=preal(p2);
tol=0.001;

if nargin~=3 || nargout>1
    error('preal/quad only supports the basic syntax: q=quad(fun,a,b).')
end

if ~isa(fun,'function_handle')
    error('First argument must be a function handle.')
end

if ~isscalar(p1)||~isscalar(p2)
    error('Integration limits must be scalars.')
end

if any(abs(p1.units-p2.units)>tol)
    error('Integration limits must be of same dimension.')
end

u1=get(preal(fun(p1)),'units');
u2=get(preal(p1),'units');
p01=preal(1,u1);
p00=preal(1,u2);
useUnitsFlag=false; %#ok
p3=quad(fun,double(p1),double(p2));
useUnitsFlag=true;
p3=p3*p00*p01;