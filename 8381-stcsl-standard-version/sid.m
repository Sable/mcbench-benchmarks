function  [sys,x0,str,ts]=sid(t,x,u,flag,T0,num_order,denum_order,dead_time,Theta0,ID_type,C0,phi0,lambda0,nu0,rho)
% Discrete model identification function.
% The transfer function of the model is of following type:
%
%           Y(z^-1)       b1*z^-1 + ... + bm*z^-m
% Gs(z^-1) = ------- = ------------------------------ * z^-d     d >= 0
%           U(z^-1)     1 + p1*z^-1 + ... + pn*z^-n
%
% where: m ... order of numerator
%        n ... order of denominator
%        d ... dead time (in sample periods) d>=0
%
% Function identifies system using recursive least square method with exponential or
% adaptive directional forgetting.
%
% [sys,x0,str,ts]=sid(t,x,u,flag,T0,num_order,denum_order,dead_time,Theta0,ID_type,C0,phi0,lambda0,nu0,rho)
% States: 
%   x(1:n+m) .............................. n+m values [a1, a2, ... an, b1, b2, ... bm] 
%                                           parameter estimation
%   x(m+n+1:n+m+n) ........................ n values [-y(k-1), -y(k-2), ... -y(k-n)] 
%                                           previous system outputs
%   x(2*n+m+1:2*n+m+m+d-1) ................ m+d-1 values [u(k-2), u(k-3), ... u(k-m-d)]
%   x(2*(n+m)+d-1, 2*(n+m)+d-1+(m+n)^2) ... (m+n)^2 values - identification matrix C 
%   x(2*(n+m)+d-1+(m+n)^2+1) .............. identificatin variable lambda
%   x(2*(n+m)+d-1+(m+n)^2+2) .............. identificatin variable nu
%   x(2*(n+m)+d-1+(m+n)^2+3) .............. identificatin variable phi
% Inputs: 
%	 u(1) ... controls the identification process 
%            < 1 .... don't perform identification (just remember inputs and outputs)
%            >= 1 ... perform identification
%   u(2) ... u(k-1) input to the identified process in previous step
%   u(3) ... y(k) current output of the identified process
%   T0 ............ sample time
%   num_order ..... (m) order of the polynomial in the numerator of transfer function
%   denum_order ... (n) order of the polynomial in the denominator of transfer function
%   dead_time ..... (d) dead time of the process (in sample times T0)
%   Theta0 ........ initial parameter estimations [a1, a2, ... an, b1, b2, ... bm] 
%   ID_type ....... type of recursive identification 
%                   1 ... pure least squares method (LSM)
%                   2 ... LSM with exponential forgetting   
%                   3 ... LSM with adaptive directional forgetting
%   C0 ............ initial value for identification matrix C (C0=1e3*eye(m+n))
%   phi0 .......... initial value for identification variable phi (phi0=1)
%   lambda0 ....... initial value for identification variable lambda (lambda=1e-3)
%   nu0 ........... initial value for identification variable nu (nu0=1e-6)
%   rho ........... identification constant rho (rho=0.99)
% Outputs:
%   sys = [a1, b1, a2, b2, a3, b3, ...]


%234567890 234567890 234567890 234567890 234567890 234567890 234567890 234567890 234567890*****(max 90 cahrs)**

m = num_order;
n = denum_order;
d = dead_time;

if flag == 0    %initialization   
   x0(1:n+m) = Theta0;                              %[a1, a2, ... an, b1, b2, ... bm] 
   x0(m+n+1:n+m+n) = zeros(1,n);                    %[-y(k-1), -y(k-2), ... -y(k-n)] 
   x0(2*n+m+1:2*n+m+m+d-1) = zeros(1,m+d-1);        %[u(k-2), u(k-3), ... u(k-m-d)]
   x0(2*(n+m)+d:2*(n+m)+d-1+(m+n)^2) = C0(:);  
   x0(2*(n+m)+d-1+(m+n)^2+1) = lambda0;
   x0(2*(n+m)+d-1+(m+n)^2+2) = nu0;
   x0(2*(n+m)+d-1+(m+n)^2+3) = phi0;
   %information about this function
   sys(1) = 0;                      %Number of continuous states.
   sys(2) = 2*(n+m)+d-1+(m+n)^2+3;  %Number of discrete states.
   sys(3) = m+n;                    %Number of outputs.
   sys(4) = 3;  %Number of inputs.
   sys(5) = 0;  %Reserved for root finding. Must be zero.
   sys(6) = 1;  %Direct feedthrough flag (1=yes, 0=no)
   sys(7) = 1;  %Number of sample times. This is the number of rows in TS.
   ts = [T0 0];
   str = [];
   
elseif (flag == 2 | flag==3)
   %ID types:
   LSM = 1;			%pure least squares method
   LSM_ef = 2;	%LSM with exponential forgetting   
   LSM_adf = 3;	%LSM with adaptive directional forgetting
    
   uk1 = u(2);	           %u(k-1)   
   yk = u(3);	           %y(k)
   Theta = x(1:n+m);      %[a1, a2, ... an, b1, b2, ... bm] 
   %[-y(k-1), -y(k-2), ... -y(k-n), u(k-1), u(k-2), u(k-3), ... u(k-m-d)] 
   yu = [x(m+n+1:n+m+n); uk1; x(2*n+m+1:2*n+m+m+d-1)];
   %[-y(k-1), -y(k-2), ... -y(k-n),   u(k-d-1) u(k-d-2), ... u(k-m-d)] 
   PHI = [yu(1:n); yu(n+1+d:n+d+m)];
   C = zeros(m+n);
   C(:) =  x(2*(n+m)+d:2*(n+m)+d-1+(m+n)^2);
   lambda = x(2*(n+m)+d-1+(m+n)^2+1);
   nu = x(2*(n+m)+d-1+(m+n)^2+2);
   phi = x(2*(n+m)+d-1+(m+n)^2+3);
   
   if (u(1) >= 1)   %perform identification
      xi = PHI' * C * PHI;
      e = yk - Theta' * PHI;
      if (ID_type == LSM) | (ID_type == LSM_adf) % | (ID_type == LSM_ef)
         Theta = Theta + C*PHI/(1+xi) * e;
      elseif (ID_type == LSM_ef)
         Theta = Theta + C*PHI/(phi+xi) * e;
      end;
   end;
   
   if (flag==2)   %update states
      if (u(1) >= 1)   %perform identification
         if (xi > 0)
            if (ID_type == LSM)
               C = C - C*PHI*PHI'*C/(1+xi);
            elseif (ID_type == LSM_ef)
               C = (C - C*PHI*PHI'*C/(phi+xi))/phi;
            elseif (ID_type == LSM_adf) %| (ID_type == LSM_ef)
               %Kulhavy, dizertace, vztah 5.56
               eta = e*e/lambda;

               %Kulhavy, dizertace, vztah 5.92
               phi = 1/(1+(1+rho)*(log(1+xi)+((nu+1)*eta/(1+xi+eta)-1)*xi/(1+xi)));
               %Kulhavy, dizertace, vztah 5.96
               %phi = 1/(1+(1+rho)*(nu+1)*eta/(1+xi+eta)*xi/(1+xi));
               %drive pouzivane (asi spatne):
               %phi = 1/(1+(1+rho)*(log(1+xi+((nu+1)*eta/(1+xi+eta)-1)*xi/(1+xi))));

               %Kulhavy, dizertace, vztah 5.49
               epsilon = phi-(1-phi)/xi;

               %Kulhavy, dizertace, vztah 5.48
               C = C - C*PHI*PHI'*C/(inv(epsilon)+xi);

               %Kulhavy, dizertace, vztah 5.52
               lambda = phi*(lambda + e*e/(1+xi));

               %Kulhavy, dizertace, vztah 5.53
               nu = phi*(nu+1);
            end
         end
      end
      
      %values for next loop
      x(1:n+m) = Theta;                               %[a1, a2, ... an, b1, b2, ... bm]
      x(m+n+1:n+m+n) = [-yk; PHI(1:n-1)];             %[-y(k-1), -y(k-2), ... -y(k-n)] 
      x(2*n+m+1:2*n+m+m+d-1) = yu(n+1:n+d+m-1);       %[u(k-2), ... u(k-m-d)]
      x(2*(n+m)+d:2*(n+m)+d-1+(m+n)^2) = C(:);  
      x(2*(n+m)+d-1+(m+n)^2+1) = lambda;
      x(2*(n+m)+d-1+(m+n)^2+2) = nu;
      x(2*(n+m)+d-1+(m+n)^2+3) = phi;
      
      sys = x;
      
   else     %flag==3 compute output
      %Theta = [a1,a2,...an, b1,b2,...bm]
      %sys = [a1, b1, a2, b2, a3, b3, ...]
      
      sys = zeros(1,m+n);
      sys(1:2:2*n-1) = Theta(1:n);
      sys(2:2:2*m) = Theta(n+1:n+m);
            
   end
   
else
   sys=[];
end
