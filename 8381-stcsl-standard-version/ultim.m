function [Kpu, Tu, err] = ultim(B,A,T0,trace)
% [Kpu, Tu, err] = ultim(B,A,T0)
% Computes ultimate gain and corresponding ultimate periode
% for descrete model described by transfer function.
% Output: Kpu ... ultimete gain
%         Tu .... ultimate period
%         err ... can't compute ultimate gain (defaults returned)
% Input: B .... numerator of discrete model
%        A .... denominator of discrete model
%        T0 ... sample time
% Model order is determined as length of input vector.
% Length of both input vectors (B,A) must be the same.
% Supported model orders are 1-3.

% Transfer function of the model (3rd order):
%
%               B(1)*z^(-1) + B(2)*z^(-1) + B(3)*z^(-3)       B(z)
% Gs(z^-1) = --------------------------------------------- = ------
%             1 + A(1)*z^(-1) + A(2)*z^(-1) + A(3)*z^(-3)     A(z)
%
% Transfer function of control circuit:
% 
%          Kpu * Gs(z)           Kpu * B(z)
% G(z) = ----------------- = ------------------
%         1 + Kpu * Gs(z)     A(z) + Kpu * B(z)
%
% At least one root of denominator (A(z) + Kpu * B(z)) must 
% be ultimate and the others must be stable (within unit circle).
% There are 2 possible alternatives:
%  a) real root z=-1
%  b) complex conjugated roots z1 = alfa + j*beta and 
%     z2 = alfa - j*beta, where alfa^2 + beta^2 = 1
%     (this is possible only for 2nd and 3rd order models)
% The aim is to compute appropriate Kpu and Tu
% Priorities for calculaton of Kpu: 1. Kpu>0, 2. use complex roots

if (nargin <4)
   trace = 0;
end
err = 0;		%expect no error

%check input
if (length(A) ~= length(B))
   error('Lengths of input vectors B and A must be the same');
end;
if (length(A)<1 | length(A)>3)
   error('This function supports model orders 1 to 3 only');
end;
   
if (length(A) == 1)		%model of first order
   b1 = B(1);
   a1 = A(1);
   if (b1 ~= 0)
      Kpu = (1-a1)/b1;
   else
      if (trace)
         disp('Model of 1st order: b1=0 - defaults returned');
         sprintf(' b1=%f\n a1=%f', b1, a1);
      end;
      err = 1;
      %default values
      Kpu = 1;
      Tu = 2*T0;
   end;
elseif (length(A) == 2)	%model of second order
   b1 = B(1);
   b2 = B(2);
   a1 = A(1);
   a2 = A(2);
   
   K_c = 0;		%gain for complex roots
   if (b2 ~= 0)
      K_c = (1-a2)/b2;
      alfa = (a1+K_c*b1)/(-2);
      if (alfa<-1 | alfa>=1)
			K_c = 0;		%can't compute gain for complex roots
      end;
   end;
   K_r = 0;		%gain for real roots
   if (b1 ~= b2)
      K_r = (1-a1+a2)/(b1-b2);
      % check that 2nd root is stable
      f = -(a1+K_r*b1-1);
      if ((f<-1) | (f>1))
         K_r = 0;				%can't compute gain for root -1
      end;
   end;
   
   if (trace)
      disp('Model of 2nd order');
      disp('[K_c K_r] =');
      disp([K_c K_r]);
      if (K_c ~= 0)
         alfa
      end
   end;
   
   %Use 2 complex roots if possible
   if (K_c > 0 | (K_c<0 & K_r<=0))
      Kpu = K_c;
      Tu = T0 * 2*pi/acos(alfa);
   elseif (K_r ~= 0)
      Kpu = K_r;
      Tu = T0 * 2;
   else
      if (trace)
         disp('Model of 2nd order: can''t compute Kpu - defaults returned');
         sprintf(' b1=%f b2=%f\n a1=%f a2=%f', b1, b2, a1, a2);
      end;
      err = 1;
      %default values
      Kpu = 1;
      Tu = 2*T0;
   end;
else					%model of third order
   b1 = B(1);
   b2 = B(2);
   b3 = B(3);
   a1 = A(1);
   a2 = A(2);
   a3 = A(3);
   
   K_c = [0 0];		%gain for complex roots
   aa = (b1-b3)*b3;
   bb = (b1-2*b3)*a3 + b3*a1 - b2;
   cc = a3*(a1-a3)-a2+1;
   if (aa ~= 0)
      D = bb*bb - 4*aa*cc;
      if (D >= 0)
         K_c(1) = (-bb + sqrt(D))/(2*aa);
         K_c(2) = (-bb - sqrt(D))/(2*aa);
      end;
   elseif (bb ~= 0)
      K_c(1) = -cc/bb;
   end;
   for i=1:2
      % check 3rd root
      f = a3 + K_c(i)*b3;
      if (f<-1 | f>=1)
         K_c(i) = 0;
      else
         % check real parts of ultimate roots
         alfa(i) = (a1-a3 + K_c(i)*(b1-b3))/(-2);
         if ((alfa(i)<-1) | (alfa(i)>=1))
            K_c(i) = 0;		%can't compute gain for complex roots
         end;
      end;
   end;
   
   K_r=0;		%gain for real roots
   if (-b1+b2-b3 ~= 0)
      K_r = (-1+a1-a2+a3)/(-b1+b2-b3);
      bb = a2-a3 + K_r*(b2-b3);
      cc = a3 + K_r*b3;
      % check othes 2 roots are stable
      f1 = (-bb + sqrt(bb*bb-4*cc))/2;
      f2 = (-bb - sqrt(bb*bb-4*cc))/2;
      if (abs(f1)>1 | f1==1 | abs(f2)>1 | f2==1)
         K_r = 0;
      end;
   end
   
   if (trace)
      disp('Model of 3rd order');
      disp('[K_c(1) K_c(2) K_r] =');
      disp([K_c K_r]);
      if ( any(K_c~=0))
         alfa
      end
   end;

   %Use 2 complex roots if possible
   if (K_c(1) > 0 | (K_c(1)<0 & K_c(2)<=0 & K_r<=0))
      Kpu = K_c(1);
      Tu = T0 * 2*pi/acos(alfa(1));
   elseif (K_c(2) > 0 | (K_c(2)<0 & K_r<=0))
      Kpu = K_c(2);
      Tu = T0 * 2*pi/acos(alfa(2));
   elseif (K_r~=0)
      Kpu = K_r;
      Tu = T0 * 2;
   else
      if (trace)
         disp('Model of 3rd order: can''t compute Kpu - defaults returned');
         sprintf('b1=%f b2=%f b3=%f\n a1=%f a2=%f a3=%f', b1, b2, b3, a1, a2, a3);
      end;
      err = 1;
      %default values
      Kpu = 1;
      Tu = 2*T0;
   end;
   
end;   