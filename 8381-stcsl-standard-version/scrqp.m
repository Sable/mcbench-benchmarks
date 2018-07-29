function [sys,x0,str,ts] = scrqp(t,x,u,flag,T0)
% RQP feedforward feedback controller
% Output of the controller is calculated follows:
%
%                  r0                            q0 + q1*z^-1 + q2*z^-2              
% U(z^-1) = ----------------------- * W(z^-1) - ------------------------ * Y(z^-1)
%            1 + p1*z^-1 + p2*z^-2                1 + p1*z^-1 + p2*z^-2
%
% u(k) = r0*w(k) - q0*y(k) - q1*y(k-1) - q2*y(k-2) - p1*u(k-1) - p2*u(k-2) 
%
% [sys,x0,str,ts] = scrqp(t,x,u,flag,T0)
% States: x(1) ... y(k-1)
%         x(2) ... y(k-2)
%         x(3) ... u(k-2)
% Inputs: u(1) ... w(k)
%         u(2) ... y(k)
%         u(3) ... r0
%         u(4) ... q0
%         u(5) ... q1
%         u(6) ... q2
%         u(7) ... p1
%         u(8) ... p2
%         u(9) ... u(k-1) real input to the controlled system, can differ to u(k) computed
%                  in previous loop (case of saturation, ...)
%         T0 ..... sample time

if flag == 0    %initialization   
   %zero initial conditions
   x0 = zeros(3,1);  %[y(k-1) y(k-2) u(k-2)]
   %information about this function
   sys(1) = 0;  %Number of continuous states.
   sys(2) = 3;  %Number of discrete states.
   sys(3) = 1;  %Number of outputs.
   sys(4) = 9;  %Number of inputs.
   sys(5) = 0;  %Reserved for root finding. Must be zero.
   sys(6) = 1;  %Direct feedthrough flag (1=yes, 0=no)
   sys(7) = 1;  %Number of sample times. This is the number of rows in TS.
   ts = [T0 0];
   str = [];
   
elseif (flag==2 | flag==3)
   yk1 = x(1);  %y(k-1)
   yk2 = x(2);  %y(k-2)
   uk2 = x(3);  %u(k-2)
   wk = u(1);   %w(k)
   yk = u(2);   %y(k)
   r0 = u(3);
   q0 = u(4);
   q1 = u(5);
   q2 = u(6);
   p1 = u(7);
   p2 = u(8);
   uk1 = u(9);  %u(k-1)

   
   u = r0*wk - q0*yk - q1*yk1 - q2*yk2 - p1*uk1 - p2*uk2;
   
   if (flag==2)   %update states
      sys = [yk yk1 uk1];  %[y(k-1) y(k-2) u(k-2)]
      
   else     %flag == 3   compute output
      sys = u;
      
   end
   
else
   
   sys=[];
end

