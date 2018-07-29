function [z,gz,hz] = j134org(x,varargin) 
% example 13.4 of Optimization of Chemical Processes. 
% x = [c1 c2 c3 ... r1 r2 r3 ... theta1 theta2 theta3 ...]' 
%
% Calculating the criterion z (output concentration from last reactor)
% and eventually its 1. and 2. derivatives with respect to x

[m,n]=size(x); 
% fprintf(1,'%7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f \n',x);

tanks=m/3;

% scaling
  en=ones(1,tanks);
  xscaling=diag([ en 0.01*en 100*en]);
  x = xscaling*x;
% end scaling

z=x(m/3,:);	% output concentration from last reactor
  
if nargout > 1 
  gz=zeros(1,m); % gradient 
  gz(1,m/3)=1;
  gz = xscaling * gz';	% scale and transpose  
end 
 
if nargout > 2 
   hz=zeros(m,m); % hessian
   hz = xscaling * hz * xscaling; % scale
end 
 
return 


