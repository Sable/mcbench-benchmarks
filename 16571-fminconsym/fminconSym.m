function [v1,v2,v3,v4,v5,v6,v7]=fminconSym(fun,x0,A,B,Aeq,Beq,LB,UB,nonlcon,opt,varargin)
% FMINCONSYM   A wrap of fmincon to use the symbolic toolbox to provide gradient.
% Limitation: The cost function and nonlinear constraint function cannot
% have conditional operation, such as if, max, min etc.
% Its usage is the same as the original fmincon.
%
% Example: see fminconSym_example
%
% By Yi Cao, Cranfield University, 25/09/2007
%
n=numel(x0);
x=[];
for k=1:n
    eval(['syms x' num2str(k)]);
    eval(['x=[x;x' num2str(k) '];']);
end
if isempty(varargin)
    F=feval(fun,x);
    [C,Ceq]=feval(nonlcon,x);
else
    F=feval(fun,x,varargin);
    [C,Ceq]=feval(nonlcon,x,varargin);
end    
Fx=jacobian(F,x);
if ~isempty(C)
    Cx=jacobian(C,x);
else
    Cx=[];
end
if ~isempty(Ceq)
    Ceqx=jacobian(Ceq,x);
else
    Ceqx=[];
end
opt = optimset(opt,'GradObj','on','GradConstr','on');
[v1,v2,v3,v4,v5,v6,v7]=fmincon(@symFun,x0,A,B,Aeq,Beq,LB,UB,@symConstr,opt,F,Fx,C,Ceq,Cx,Ceqx);

function [cost,grad]=symFun(x0,varargin)
n=numel(x0);
for k=1:n
    eval(['x' num2str(k) '=x0(k);']);
end
cost = eval(varargin{1});
if nargout>1
    grad  = eval(varargin{2});
end

function [c,ceq,cx,ceqx]=symConstr(x0,varargin)
n=numel(x0);
for k=1:n
    eval(['x' num2str(k) '=x0(k);']);
end
if ~isempty(varargin{3})
    c = eval(varargin{3});
else
    c=[];
end
if ~isempty(varargin{4})
    ceq = eval(varargin{4});
else
    ceq=[];
end
if nargout>2
    if ~isempty(c)
        cx  = eval(varargin{5})';
    else
        cx=[];
    end
    if ~isempty(ceq)
        ceqx  = eval(varargin{6})';
    else
        ceqx=[];
    end
end
