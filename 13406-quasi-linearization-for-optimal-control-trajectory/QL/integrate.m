function y = integrate(t,x)

if length(t)~=length(x)
    error('Langths of two vectors must agree with each other');
end
loop = 1;
y    = 0;
for loop = 1:length(x)-1
   
    h = (t(loop+1)-t(loop));
    y = y + h/2*(x(loop)+x(loop+1));
    
end