function [sys,x0,str,ts] = scfpd(t,x,u,flag,T0)
% PID controller based on forward rectangular method of discretization
% replacing derivation by a four-point difference.
% Transfer function of the controller is as follows:
%
%           U(z^-1)    q0 + q1*z^-1 + q2*z^-2 + q3*z^-3 + q4*z^-4
% G(z^-1) = ------- = --------------------------------------------
%           E(z^-1)                   1 - z^-1
%
% u(k) = q0*e(k) + q1*e(k-1) + q2*e(k-2) + q3*e(k-3) + q4*e(k-4) + u(k-1)
%
% [sys,x0,str,ts] = scfpd(t,x,u,flag,T0)
% States: x(1) ... e(k-1)
%         x(2) ... e(k-2)
%         x(3) ... e(k-3)
%         x(4) ... e(k-4)
% Inputs: u(1) ... e(k)
%         u(2) ... q0
%         u(3) ... q1
%         u(4) ... q2
%         u(5) ... q3
%         u(6) ... q4
%         u(7) ... u(k-1) real input to the controlled system, can differ to u(k) computed
%                  in previous loop (case of saturation, ...)
%         T0 ..... sample time

if flag == 0    %initialization   
   %zero initial conditions
   x0 = zeros(4,1);  %[e(k-1) e(k-2) e(k-3) e(k-4)]
   %information about this function
   sys(1) = 0;  %Number of continuous states.
   sys(2) = 4;  %Number of discrete states.
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
   ek3 = x(3);  %e(k-3)
   ek4 = x(4);  %e(k-4)
   ek = u(1);   %e(k)
   q0 = u(2);
   q1 = u(3);
   q2 = u(4);
   q3 = u(5);
   q4 = u(6);
   uk1 = u(7);  %u(k-1)
   
   u = q0*ek + q1*ek1 + q2*ek2 + q3*ek3 + q4*ek4 + uk1;   
   
   if (flag==2)    %update states
      sys = [ek x(1:3)'];  %[e(k-1) e(k-2) e(k-3) e(k-4)]
      
   else    % flag == 3   %compute output
      sys = u;
      
   end
   
else
   
   sys=[];
end

