function [v1,v2,v3,v4,v5,v6,v7]=lsqnonlinCSD(funhandle,varargin)
% LSQNONLINCSD   A wrap of lsqnonlin to use Complex Step Differentiation 
%                to obtain Jacobian.
% Limitation: The objective function cannot have conditional operation, 
% such as if, max, min etc.
% 
% Its usage is the same as the original lsqnonlin.
%
% Example: see lsqnonlinCSD_example
%
% By Yi Cao, Cranfield University, 01/01/2008
%
x0=varargin{1};
nv=numel(varargin);

if nv>=4
    opt = varargin{4};
    opt = optimset(opt,'jacobian','on');
else
    opt = optimset('jacobian','on');
end
if nv>4
    fun=@(x) funhandle(x,varargin(5:end));
else
    fun=funhandle;
end

switch nv
    case 1
        [v1,v2,v3,v4,v5,v6,v7]=lsqnonlin(@csdFun,x0,[],[],opt,fun);
    case 2
        LB=varargin{2};
        [v1,v2,v3,v4,v5,v6,v7]=lsqnonlin(@csdFun,x0,LB,[],opt,fun);    
    otherwise
        LB=varargin{2};
        UB=varargin{3};
        [v1,v2,v3,v4,v5,v6,v7]=lsqnonlin(@csdFun,x0,LB,UB,opt,fun);
end

function [E,J]=csdFun(x0,fun)
E=fun(x0);
if nargout==2
    n=numel(x0);
    h=n*eps;
    m=numel(E);
    J=zeros(m,n);
    for k=1:n
        x=x0;
        x(k)=x(k)+h*i;
        J(:,k)=imag(fun(x))/h;
    end
end