function [qp]=ba2(input)
% [qp]=ba2(input)
% Banyasz-Keviczky's controller for 2nd order processes with dead time.
% This function computes parameters of the controller (q0, q1, q2, p1, p2).
% Controller is based on backward rectangular method of discretization.
% Transfer function of the controller is as follows:
%
%            q0 + q1*z^-1 + q2*z^-2
% G(z^-1) = ------------------------
%             1 + p1*z^-1 + p2*z^-2
%
% Transfer function of the controlled system is:
%
%                 b0 + b1*z^-1       
% Gs(z^-1) = ----------------------- * z^-d
%             1 + a1*z^-1 + a2*z^-2
%
% Input: input ... input parameters
%                  input(1) ... a1
%                  input(2) ... b0
%                  input(3) ... a2
%                  input(4) ... b1
%                  input(5) ... d
% Output: qp ... controller parameters   
%                qp(1) ... q0
%                qp(2) ... q1
%                qp(3) ... q2
%                qp(4) ... p1
%                qp(5) ... p2

a1 = input(1);
b0 = input(2);
a2 = input(3);
b1 = input(4);
d = input(5);       

% check inputs
if (d<1)
   disp('ba2.m: Input parameter d (dead time) must be greater or equal 1');
   disp('       parameter value has been changed to 1');
   d = 1;
else
   d = round(d);
end;

if (b0==0)
   b0 = b1;
   b1 = 0;
   d = d+1;
end;
d = max([round(d)],1);

%compute the controller parameters
gama = b1/b0;
if ((gama <= 0) | (gama == 1))
   ki = 1/(2*d-1);
   %use serial filter 1/(1 + gama*z^-1)
   p1 = -1+gama;
   p2 = -gama;
else	%gama>0
   ki = 1/(2*d*(1+gama)*(1-gama));
   p1 = -1;
	p2 = 0;
end;
q0=ki/b0;
q1=q0*a1;
q2=q0*a2;

qp=[q0; q1; q2; p1; p2];