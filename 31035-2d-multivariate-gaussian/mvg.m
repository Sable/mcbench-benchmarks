function x=mvg(mean,cov)
%%%%this function plots the 2D multivariate gaussian when the mean and
%%%%covariance are provided without using for loops.
% mean= 2x1 vector of  means in each two dimension 
% cov= 2x2 covarience matrix
% % x1=mesh coordinates. limited to 0 to 20 in each dimension.You can
% specify it as needed
% 
% ex: plot mean=[10;11],cov=[6 0;0 6] 2D multivariate gaussian function
%  
% mvg([10;11],[6 0;0 6])
%

mean1=mean;
cov1=cov;
%%%this is the xy plane limits
[x y]=meshgrid(0:20,0:20);
x1=[x(:) y(:)]';
%%%multivar Gassiaan
mn=repmat(mean1,1,size(x1,2));
mulGau= 1/(2*pi*det(cov1)^(1/2))*exp(-0.5.*(x1-mn)'*inv(cov1)*(x1-mn));
G=reshape(diag(mulGau),21,21);
figure(1)
mesh(G)
figure(2)
contour(G)
%plot3(x1(1,:),x1(2,:),diag(mulGau))

end