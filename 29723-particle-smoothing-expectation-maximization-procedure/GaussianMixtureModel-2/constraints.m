function y=constraints(x) 
%a=.6; b=.2; c=2; d=.2; g=.5; h=1; lambda=.15;
%  c=[.01,1;.01,1;1,3;0,2;.3,4;0,50;0,.5]; %Simulation
c=[.01,1;.01,1;1,3;0,.5;.01,5;0,50;.01,1]; %Data
[m,n]=size(c);

for i=1:m
    
if (x(i)<c(i,1) || x(i)>c(i,2))
x(i)=c(i,1) + rand*(c(i,2)-c(i,1));
else
x(i)=x(i);
end

end
y=x;