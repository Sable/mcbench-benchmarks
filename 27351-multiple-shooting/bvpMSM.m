% Multiple Shooting method
function [T,Y]=bvpMSM(odefunction,solinit,bcondition,dbcondition,options)
%% solutions
if isempty(options)==0 
    if isempty(options.RelTol)==0 
        tolerance=options.RelTol;
    else
        tolerance=1e-3;
    end
else
    tolerance=1e-3;
end
global n
nn=size(solinit.y);n=nn(1);
m=length(solinit.x)-1;
Fp=zeros(m*n,m*n);
F=zeros(m*n,1);
t=solinit.x;
s=solinit.y(:,1:m);
error=1;it=0;
while error>tolerance
    T=[];Y=[];
    it=it+1;
for i=1:m
    dyds=[];
    [tn,yn,dydu]=sens_sys(odefunction,[t(i);t(i+1)],s(:,i),options,ones(n,1),0,@inibvpme);
    T=[T;tn];Y=[Y;yn]; %#ok<AGROW,AGROW>
    if i==1
        ya=yn(1,:)';
    elseif i==m
        yb=yn(end,:)';
    end
    for p=1:n
        dyds=[dyds dydu(end,:,p)']; %#ok<AGROW>
    end
    if i~=m
        Fp((i-1)*n+1:i*n,(i-1)*n+1:i*n)=-dyds;
        Fp((i-1)*n+1:i*n,i*n+1:(i+1)*n)=eye(n);
        F((i-1)*n+1:i*n)=s(:,i+1)-yn(end,:)';
    else
        Bab=dbcondition(ya,yb);
        Ba=Bab.Ba;Bb=Bab.Bb;
        Fp((i-1)*n+1:i*n,(i-1)*n+1:i*n)=Bb*dyds;
        Fp((i-1)*n+1:i*n,1:n)=Ba;
        F((i-1)*n+1:i*n)=bcondition(ya,yb);
        error=norm(F);
        iteration_and_error=[it error] %#ok<NOPRT,NASGU>
    end
end
ss=s(:)-inv(Fp)*F;
for j=1:m
    s(:,j)=ss((j-1)*n+1:j*n);
end
end
end
function Y=inibvpme(X,U) %#ok<INUSD>
global n
Y=eye(n);
end