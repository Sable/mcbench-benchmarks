function [mu1,mu2,v1x,v1y,v2x,v2y] = eigfunction(u,sigma,rho)
% This function calculates the eigen values from the
% hessian matrix; 
% input:
% u: image;
% sigma: gaussian smooth scale;
% rho: scale for eigvalue and eigvector calculation;
% output: two eigvalue and eigvecotor;

[N1,N2] = size(u);
u = double(u);
id = [2:N1,N1];  
iu = [1,1:N1-1]; 
ir = [2:N2,N2];   
il = [1,1:N2-1]; 


Ksigma = gaussian(sigma);                       
Krho = gaussian(rho);                           
rhodenom = conv2(Krho,Krho,ones(N1,N2),'same'); 
sigmadenom = conv2(Ksigma,Ksigma,ones(N1,N2),'same');

usigma = conv2(Ksigma,Ksigma,u,'same')./sigmadenom;        
ux = (usigma(:,ir,:) - usigma(:,il,:))/(2);  
uy = (usigma(iu,:,:) - usigma(id,:,:))/(2);

%% structure tensor;
J11 = ux.^2;
J12 = ux.*uy;
J22 = uy.^2;

J11 = conv2(Krho,Krho,J11,'same')./rhodenom;   
J12 = conv2(Krho,Krho,J12,'same')./rhodenom;
J22 = conv2(Krho,Krho,J22,'same')./rhodenom;

%% eigvalue and eigvecotr   
    tmp = sqrt((J11 - J22).^2 + 4*J12.^2);
    v2x = 2*J12;
    v2y = J22 - J11 + tmp;
    mag = sqrt(v2x.^2 + v2y.^2);
    i = (mag ~= 0);
    v2x(i) = v2x(i)./mag(i);      
    v2y(i) = v2y(i)./mag(i);

    v1x = -v2y;                   
    v1y = v2x;

    
    mu1 = 0.5*(J11 + J22 + tmp);  
    mu2 = 0.5*(J11 + J22 - tmp);  

%%
function K = gaussian(sigma)
%GAUSSIAN  Construct Gaussian filter
if sigma > 0
    n = ceil(4*sigma);
    K = exp(-(-n:n).^2/(2*sigma^2));
    K = K/sum(K(:));
else
    K = 1;
end
return;
