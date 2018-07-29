function [v1,v2,v3,v4,v5,v6,v7]=lsqnonlinSym(funhandle,varargin)
% LSQNONLINSYM   A wrap of lsqnonlin to use symbolic toolbox to obtain Jacobian.
% Limitation: The cost function and nonlinear constraint function cannot
% have conditional operation, such as if, max, min etc.
% Its usage is the same as the original lsqnonlin.
%
% Example: see lsqnonlinSym_example
%
% By Yi Cao, Cranfield University, 25/09/2007
%
x0=varargin{1};
n=numel(x0);

x=[];
for k=1:n
    eval(['syms x' num2str(k)]);
    eval(['x=[x;x' num2str(k) '];']);
end

nv=numel(varargin);
if nv>4
    F=feval(funhandle,x,varargin(5:end));
else
    F=feval(funhandle,x);
end
F=simplify(F);
Fx=simplify(jacobian(F,x));

if nv>=4
    opt = varargin{4};
    opt = optimset(opt,'jacobian','on');
else
    opt = optimset('jacobian','on');
end

switch numel(varargin)
    case 1
        [v1,v2,v3,v4,v5,v6,v7]=lsqnonlin(@symFun,x0,[],[],opt,F,Fx);
    case 2
        LB=varargin{2};
        [v1,v2,v3,v4,v5,v6,v7]=lsqnonlin(@symFun,x0,LB,[],opt,F,Fx);    
    otherwise
        LB=varargin{2};
        UB=varargin{3};
        [v1,v2,v3,v4,v5,v6,v7]=lsqnonlin(@symFun,x0,LB,UB,opt,F,Fx);
end

function [E,J]=symFun(x0,F,Fx)
n=numel(x0);
for k=1:n
    eval(['x' num2str(k) '=x0(k);']);
end
E = eval(F);
if nargout>1
    J  = eval(Fx);
end
