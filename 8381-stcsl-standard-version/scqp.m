function [sys,x0,str,ts] = scqp(t,x,u,flag,T0)
% Q(z^-1)/P(z^-1) controller
% Transfer function of the controller is as follows:
%
%           U(z^-1)    q0 + q1*z^-1 + q2*z^-2 
% G(z^-1) = ------- = ------------------------
%           E(z^-1)     1 + p1*z^-1 + p2*z^-2
%
% u(k) = q0*e(k) + q1*e(k-1) + q2*e(k-2) - p1*u(k-1) - p2*u(k-2)
%
% [sys,x0,str,ts] = scfpd(t,x,u,flag,T0)
% States: x(1) ... e(k-1)
%         x(2) ... e(k-2)
%         x(3) ... u(k-2)
% Inputs: u(1) ... e(k)
%         u(2) ... q0
%         u(3) ... q1
%         u(4) ... q2
%         u(5) ... p1
%         u(6) ... p2
%         u(7) ... u(k-1) real input to the controlled system, can differ to u(k) computed
%                  in previous loop (case of saturation, ...)
%         T0 ..... sample time

if flag == 0    %initialization   
   %zero initial conditions
   x0 = zeros(3,1);  %[e(k-1) e(k-2) u(k-2)]
   %information about this function
   sys(1) = 0;  %Number of continuous states.
   sys(2) = 3;  %Number of discrete states.
   sys(3) = 1;  %Number of outputs.
   sys(4) = 7;  %Number of inputs.
   sys(5) = 0;  %Reserved for root finding. Must be zero.
   sys(6) = 1;  %Direct feedthrough flag (1=yes, 0=no)
   sys(7) = 1;  %Number of sample times. This is the number of rows in TS.
   ts = [T0 0];
   str = [];
   
elseif (flag==2 | flag==3)
   ek1 = x(1);  %e(k-1)
   ek2 = x(2);  %e(k-2)
   uk2 = x(3);  %u(k-2)
   ek = u(1);   %e(k)
   q0 = u(2);
   q1 = u(3);
   q2 = u(4);
   p1 = u(5);
   p2 = u(6);
   uk1 = u(7);  %u(k-1)
   
   u = q0*ek + q1*ek1 + q2*ek2 - p1*uk1 - p2*uk2;
   
   if (flag==2)   %update states
      sys = [ek ek1 uk1];  %[e(k-1) e(k-2) u(k-2)]
      
   else    %flag == 3   compute output
      sys = u;
      
   end
   
else
   
   sys=[];
end

