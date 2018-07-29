% orientation filtering function(Eq.(9)in the paper)
function K = angfilter(I,Theta,angle,sigma)

b = angle;
c = sigma;
[m,n] = size(Theta);

X = 0:180;
f = (1/(sqrt(2*pi)*c))*exp(-(((X-b).^2)/(2*(c^2))));

for i=1:m  
    for j=1:n
        T(i,j)=f(Theta(i,j));
    end
end

K = I.*T;
