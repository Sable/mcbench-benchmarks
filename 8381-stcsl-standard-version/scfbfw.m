function [sys,x0,str,ts] = scrqp(t,x,u,flag,T0,nr,nq,np)
% FBFW feedforward feedback controller
% Output of the controller is calculated follows:
%
%            R(z^-1)                Q(z^-1)              
% U(z^-1) = ---------- * W(z^-1) - --------- * Y(z^-1)
%            P(z^-1)                P(z^-1)
%
% Orders of polynomials R, Q and P are determined by parameters nr, nq and np.
%
% [sys,x0,str,ts] = scrqp(t,x,u,flag,T0,nr,nq,np)
% States: x(1:nr) ... w(k-1), w(k-2), ...
%         x(nr+1:nr+nq) ... y(k-1), y(k-2), ...
%         x(nr+nq+1:nr+nq+np-1) ... u(k-2), u(k-3), ... (u(k-1) is input - see below)
% Inputs: u(1) ... w(k)
%         u(2) ... y(k)
%         u(2+1:2+nr+1) ... r0, r1, ....
%         u(2+nr+1+1:2+nr+1+nq+1) ... q0, q1, ...
%         u(2+nr+1+nq+1+1:2+nr+1+nq+1+np+1) ... p0, p1, ...
%         u(2+nr+1+nq+1+np+1+1) ... u(k-1) real input to the controlled system, can differ to u(k) computed
%                             in previous loop (case of saturation, ...)
%         T0 ... sample time
%         nr ... odrer of polynomial R (R has nr+1 coefficients)
%         nq ... odrer of polynomial R (R has nq+1 coefficients)
%         np ... odrer of polynomial R (R has np+1 coefficients)

if flag == 0    %initialization   
   %zero initial conditions
   x0 = zeros(nr+nq+np-1,1);  
   %information about this function
   sys(1) = 0;  %Number of continuous states.
   sys(2) = nr+nq+np-1;  %Number of discrete states.
   sys(3) = 1;  %Number of outputs.
   sys(4) = 2 + nr+1 + nq+1 + np+1 + 1;  %Number of inputs.
   sys(5) = 0;  %Reserved for root finding. Must be zero.
   sys(6) = 1;  %Direct feedthrough flag (1=yes, 0=no)
   sys(7) = 1;  %Number of sample times. This is the number of rows in TS.
   ts = [T0 0];
   str = [];
   
elseif (flag==2 | flag==3)
    W = [u(1); x(1:nr)];             %[w(k), w(k-1), w(k-2), ...]
    Y = [u(2); x(nr+1:nr+nq)];       %[y(k), y(k-1), y(k-2), ...]
    U1 = [u(2+nr+1+nq+1+np+1+1); x(nr+nq+1:nr+nq+np-1)];      %[u(k-1), u(k-2), u(k-3),...]
    R = u(2+1:2+nr+1);                      % [r0, r1, ...]
    Q = u(2+nr+1+1:2+nr+1+nq+1);            % [q0, q1, ...]
    p0 = u(2+nr+1+nq+1+1);
    P1 = u(2+nr+1+nq+1+2:2+nr+1+nq+1+np+1);  % [p0, p1, ...]
       
    if (flag==2)   %update states
        sys = [W(1:nr); Y(1:nq); U1(1:np-1)];  %[y(k-1) y(k-2) u(k-2)]
      
    else     %flag == 3   compute output
        u = 1/p0*( R'*W - Q'*Y - P1'*U1);
        sys = u;      
    end
   
else
   
    sys=[];
end

