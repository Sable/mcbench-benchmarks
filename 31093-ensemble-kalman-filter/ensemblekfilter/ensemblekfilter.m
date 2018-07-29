%       Created by Dwight Nwaigwe  April 2011
%	This program uses the ensemble kalman filter to estimate a system's state.
%	The state is x_new=f(x,u)+w, where u some input, w the
%	Gaussian distributed process noise, and f is a nonlinear function. The measurement 
%	is y_new=h(x)+v where h is a nonlinear function and v Gaussian distributed measurement noise.                 


%       The algorithm used in this code is referenced from the following:
%       S Gillijns et. al., "What Is the Ensemble Kalman Filter and How Well Does it Work?"
%       Proceedings of the 2006 American Control Conference,
%       Minneapolis, Minnesota, USA, June 14-16, 2006, pp 4448-4453.


function [x_tr,x_estbar,ybar]= ensemblekfilter(f,h,x_tr,x_ini,w,z,num_iterations) 


%      Example

%      The state and measurement in this example  is taken from Dan Simon, "Kalman Filtering", 
%      Embedded Systems Programming,2001.
%       
%
%	syms  x1 x2;   %variables must be named x1...xn
%	f=[x1+.1*x2+.005;x2+.1];
%	h=[x1];
%	x_tr=[1;1]; %initial value of state
%	x_ini=ones(2,20); %ensemble of initial estimate of the state
%	w=[10^-3; .02];  %process noise standard deviation
%	z=[10];  %measurement noise standard deviation
%	num_iterations=600;
% 	num_members=20;
% 	[a,b,c]=ensemblekfilter(f,h,x_tr,x_ini,w,z,num_iterations);


[dummy,num_members]=size(x_ini);
p1=length(f);
m1=length(h);
var_vector=[];
xvec=[];
x_estvec=[];
yvec=[];
x_est=x_ini;

for j=1:p1  %create vector containing variables x1 to xn
  eval(sprintf(' syms x%d', j));
  var_vector=[var_vector sprintf('x%d ',j)];
  end
var_vector=strcat('[',var_vector);
var_vector=strcat(var_vector,']');

Zcov=eye(m1); %create measurement noise covariance matrix
for j=1:m1
  Zcov(j,j)=z(j)^2;
end


for i=1:num_iterations  

   x_tr=subs(f,var_vector,x_tr)+w.*randn(p1,1); %compute true value of state at next time step
   
   for j=1:num_members
     W(:,j)=w.*randn(p1,1);                          %create process noise
     Z(:,j)=z.*randn(m1,1);                          %create measurement noise
     x_est(:,j)=subs(f,var_vector,x_est(:,j))+W(:,j);      %forecast state
     y(:,j)=subs(h,var_vector,x_tr)+Z(:,j);                 %make measurement
     y_for(:,j)=subs(h,var_vector,x_est(:,j));              %forecast measurement
   end

   x_estbar=mean(x_est,2);                    
   ybar=mean(y,2);
   y_forbar=mean(y_for,2);

   for j=1:p1
     Ex(j,:)=[x_est(j,:)-x_estbar(j)];
   end

   for j=1:m1
     Ey(j,:)=[y_for(j,:)-y_forbar(j)];
   end

   Pxy=Ex*Ey'/(num_members-1);
   Pyy=Ey*Ey'/(num_members-1)+Zcov;                     %The addition of Zcov to Pyy is not done in Gillijns et. al but I use it here in case num_members=2 or Pyy is nearly singular
   K=Pxy*inv(Pyy);
   x_est=x_est+K*(y-y_for);
   xvec=[xvec x_tr];
   x_estvec=[x_estvec x_estbar];
   yvec=[yvec ybar];
   if i==num_iterations
   x_estbar=mean(x_est,2);
   end
end



