function [x,y,d,t,h,iter,alpha,beta,e,m,n,el]=ants_information;
iter=100;%number of cycles.
m=200;%number of ants.
x=[8 0 -1 2 4 6 3 10 2.5 -5 7 9 11 13];
y=[2 4 6 -1 -2 0.5 0 3.7 1.8 1 0 4 3 2];%take care not to enter iterative points.
n=length(x);%number of nodes.
for i=1:n%generating link length matrix.
    for j=1:n
        d(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
    end
end
e=.1;%evaporation coefficient.
alpha=1;%order of effect of ants' sight.
beta=5;%order of trace's effect.
for i=1:n%generating sight matrix.
    for j=1:n
        if d(i,j)==0
            h(i,j)=0;
        else
            h(i,j)=1/d(i,j);
        end
    end
end
t=0.0001*ones(n);%primary tracing.
el=.96;%coefficient of common cost elimination. 