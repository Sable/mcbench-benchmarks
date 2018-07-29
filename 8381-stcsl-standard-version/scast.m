function [sys,x0,str,ts] = scast(t,x,u,flag,T0,alfa,beta)
% Åström controller S-function
% The output of the controller is computed as follows:
% u(k) = upi(k) + ud(k)
% where:
%   upi(k) = Kp*(y(k-1)-y(k)) + Kp*T0/(2*Ti)*(e(k)+e(k-1)) +...
%            beta*Kp*(w(k)-w(k-1)) + upi(k-1) 
%          = Kp*(y(k)-y(k-1) + T0/(2*Ti)*(w(k)-y(k)+w(k-1)-y(k-1)) +...
%            beta*(w(k)-w(k-1))) + upi(k-1);
%   ud(k) = Kp*Td*alfa/(Td+T0*alfa)*(y(k-1)-y(k)) + Td/(Td+T0*alfa)*ud(k-1)
%         = Td/(Td+T0*alfa) * (Kp*alfa*(y(k-1)-y(k)) + ud(k-1))
% 
% [sys,x0,str,ts] = scast(t,x,u,flag,T0,alfa,beta)
% States: x(1) ... w(k-1)
%         x(2) ... y(k-1)
%         x(3) ... upi(k-1)
%         x(4) ... ud(k-1)
% Inputs: u(1) ... w(k)
%         u(2) ... y(k)
%         u(3) ... Kp
%         u(4) ... Ti
%         u(5) ... Td
%         T0 ..... sample time
%         alfa ... filter constant
%         beta ... weight

if flag == 0    %initialization   
   %zero initial conditions
   x0 = zeros(4,1);  %[w(k-1) y(k-1) upi(k-1) ud(k-1)]
   %information about this function
   sys(1) = 0;  %Number of continuous states.
   sys(2) = 4;  %Number of discrete states.
   sys(3) = 1;  %Number of outputs.
   sys(4) = 5;  %Number of inputs.
   sys(5) = 0;  %Reserved for root finding. Must be zero.
   sys(6) = 1;  %Direct feedthrough flag (1=yes, 0=no)
   sys(7) = 1;  %Number of sample times. This is the number of rows in TS.
   ts = [T0 0];
   str = [];
   
elseif (flag == 2 | flag==3)
   wk1 = x(1);  %w(k-1)
   yk1 = x(2);  %y(k-1)
   upi = x(3);  %upi(k-1)
   ud = x(4);   %ud(k-1)
   wk = u(1);   %w(k)
   yk = u(2);   %y(k)
   Kp = u(3);
   Ti = u(4);
   Td = u(5);
   
   upi = Kp * (yk1-yk + T0/(2*Ti)*(wk-yk+wk1-yk1) + beta*(wk-wk1)) + upi;
   ud = Td/(Td+T0*alfa) * (Kp*alfa*(yk1-yk) + ud);
   
   if (flag==2)    %update states
      sys = [wk yk upi ud];
      
   else  % falg==3 compute output
      u = upi+ud;
      sys = u;
      
   end
   
else
   
   sys=[];
end

