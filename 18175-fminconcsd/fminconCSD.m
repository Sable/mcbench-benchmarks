function [v1,v2,v3,v4,v5,v6,v7]=fminconCSD(fun,x0,A,B,Aeq,Beq,LB,UB,nonlcon,opt,varargin)
% FMINCONCSD   A wrap of fmincon to use Complex Step Differentiation (CSD) to calculate gradient.
% Limitation: The cost function and nonlinear constraint function cannot
% have conditional operation, such as if, max, min etc.
% Its usage is the same as the original fmincon.
%
% Example: see fminconCSD_example
%
% By Yi Cao, Cranfield University, 01/01/2008
%

x=[fun(x0)+eps;x0(:)];
opt = optimset(opt,'GradObj','on','GradConstr','on');
if ~numel(varargin)
    costfun=fun;
    consfun=nonlcon;
else
    costfun=@(x)fun(x,varargin{:});
    consfun=@(x)nonlcon(x,varargin{:});
end
[v1,v2,v3,v4,v5,v6,v7]=fmincon(@csdFun,x,A,B,Aeq,Beq,LB,UB,@csdConstr,opt,costfun,consfun);

function [cost,grad]=csdFun(x0,varargin)
n=numel(x0);
cost=x0(1);
if nargout>1
    grad=eye(1,n);
end

function [c,ceq,cg,ceqg]=csdConstr(x0,varargin)
n=numel(x0);
h=n*eps;
x=x0(2:n);
costfun=varargin{1};
consfun=varargin{2};
cost=costfun(x);
[c,ceq]=consfun(x);
c=[cost-x0(1) c];
if nargout>2
    nc=numel(c);
    nceq=numel(ceq);
    costg=zeros(n,1);
    cg=zeros(n,nc);
    ceqg=zeros(n,nceq);
    for k=2:n
        x1=x;
        x1(k-1)=x0(k)+h*i;
        costg(k)=imag(costfun(x1))/h;
        [cZ,ceqZ]=consfun(x1);
        cg(k,:)=imag(cZ)/h;
        ceqg(k,:)=imag(ceqZ)/h;
    end
    cg=[costg-eye(n,1) cg];
end