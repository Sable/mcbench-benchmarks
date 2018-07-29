function [M,B] = calibaccel(data)
 %-------------------------------------------------------------------------------
%   Computes the Scale factor Matrix and the bias vector of a MEMS accelerometer.
%   The procedure exploits the fact that, in static conditions, the
%   modulus of the accelerometer output vector matches that of the
%   gravity acceleration. The calibration model incorporates the bias
%   and scale factor for each axis and the cross-axis symmetrical
%   factors. The parameters are computed through Gauss-Newton nonlinear optimization.
%   The mathematical model used is  A = M(V - B)
%   where M and B are scale factor matrix and bias vector respectively.
%   M = [ Mxx Mxy Mxz; Myx Myy Myz; Mzx Mzy Mzz ]; where  Mxy = Myx; Myz = Mzy; Mxz = Mzx;
%   B = [ Bx; By; Bz ];
%   The diagonal elements of M represent the scale factors along the
%   three axes, whereas the other elements of M are called cross-axis
%   factors. These terms allow describing both the axes’ misalignment
%   and the crosstalk effect between different channels caused
%   by the sensor electronics. In an ideal world, M = 1; B = 0
%-------------------------------------------------------------------------------
%   Form:
%   [M,B] = calibaccel( data )
%-------------------------------------------------------------------------------
%   ------
%   Inputs
%   ------
%   data          (9,3)    columns ax, ay and az acceleration values obtained from the accelerometer represented in units of g
%                          9 rows represent data from 9 different static positions.
%                          
%   To convert raw measurements to units of g use the following formula:
%   Vx_g = (Vx - Zerox)* Sensitivity_x
%   Vy_g = (Vy - Zeroy)* Sensitivity_y 
%   Vz_g = (Vz - Zeroz)* Sensitivity_z
%   For LIS3L02AL (Wii Nunchuck) accelerometer the following values are
%   valid:
%   Zerox = 505; Zeroy = 517; Zeroz = 549
%   Sensitivity_x = 0.004673 g/mV
%   Sensitivity_y = 0.004762 g/mV
%   Sensitivity_z = 0.004425 g/mV
%   
%   To find the Zeroxyz values of your own accelerometer, note the max and
%   minimum  of the ADC values for each axis and use the following formula:
%   Zerox = (Max_x - Min_x)/2;Zeroy = (Max_y - Min_y)/2;Zeroz = (Max_z - Min_z)/2
%   To find the Sensitivity use the following formula:
%   Sensitivity_x = n/(Max_x-Min_x); where n is the max g resolution of your accelerometer: typically n = 2  
%
%   -------
%   Outputs
%   -------
%   M         (3,3)     Scale Vector Matrix
%   B         (3,1)     Bias Vector
%-------------------------------------------------------------------------------
%   Reference: Iuri Frosio, Federico Pedersini, N. Alberto Borghese
%   "Autocalibration of MEMS Accelerometers"
%   IEEE TRANSACTIONS ON INSTRUMENTATION AND MEASUREMENT, VOL. 58, NO. 6, JUNE 2009
%-------------------------------------------------------------------------------
%   Author:  Balaji Kumar, Sep 2011, Canada
%   Free to distribute 
%-------------------------------------------------------------------------------
   clc  
 
% Configurable variables

   lambda = 1;      % Damping Gain - Start with 1 
   kl = 0.01;       % Damping paremeter - has to be less than 1. Changing this will affect rate of convergence ; Recommend to use k1 between 0.01 - 0.05
   tol = 1e-9;      % Convergence criterion threshold
   Rold = 100000;   % Better to leave this No. big. 
   itr = 200;       % No. Of iterations. If your solutions don't converge then try increasing this. Typically it should converge within 20 iterations
   
   
% Initial Guess values of M and B.  Change this only if you need to
   
   Mxx0 = 5; 
   Mxy0 = 0.5;
   Mxz0 = 0.5;
   Myy0 = 5;
   Myz0 = 0.5;
   Mzz0 = 5;
   
   Bx0 = 0.5;
   By0 = 0.5;
   Bz0 = 0.5;
   
%   Actual Algorithm

   load ('data.txt');
   V = data;
   [r, c] = size(V);
   
   if r < 9 
              disp('Need atleast 9 Measurements for the calibration procedure!')
       return
   end
   
    if c ~= 3 
              disp('Not enough columns in the data')
       return
   end
   
  
   % f is the error function given by Ax^2+Ay^2+Az^2 - g, where g = 1
   f =  inline('(Mxx*(Bx - Vx) + Mxy*(By - Vy) + Mxz*(Bz - Vz))^2 + (Mxy*(Bx - Vx) + Myy*(By - Vy) + Myz*(Bz - Vz))^2 + (Mxz*(Bx - Vx) + Myz*(By - Vy) + Mzz*(Bz - Vz))^2-1','Vx','Vy','Vz','Mxx','Mxy','Mxz','Myy','Myz','Mzz','Bx','By','Bz'); 
   
  % Functions f1 to f9 are the elements of the Jacobian vector (partial
  % derivatives of the error function with respect to the gain and bias
  % components)
   f1 = inline('2*(Bx - Vx)*(Mxx*(Bx - Vx) + Mxy*(By - Vy) + Mxz*(Bz - Vz))','Vx','Vy','Vz','Mxx','Mxy','Mxz','Myy','Bx','By','Bz');
   f2 = inline('2*(By - Vy)*(Mxx*(Bx - Vx) + Mxy*(By - Vy) + Mxz*(Bz - Vz)) + 2*(Bx - Vx)*(Mxy*(Bx - Vx) + Myy*(By - Vy) + Myz*(Bz - Vz))','Vx','Vy','Vz','Mxx','Mxy','Mxz','Myy','Myz','Bx','By','Bz' );
   f3 = inline('2*(Bx - Vx)*(Mxz*(Bx - Vx) + Myz*(By - Vy) + Mzz*(Bz - Vz)) + 2*(Bz - Vz)*(Mxx*(Bx - Vx) + Mxy*(By - Vy) + Mxz*(Bz - Vz))','Vx','Vy','Vz','Mxx','Mxy','Mxz','Myz','Mzz','Bx','By','Bz');
   f4 = inline('2*(By - Vy)*(Mxy*(Bx - Vx) + Myy*(By - Vy) + Myz*(Bz - Vz))','Vx','Vy','Vz','Mxy','Myy','Myz','Bx','By','Bz');
   f5=  inline('2*(By - Vy)*(Mxz*(Bx - Vx) + Myz*(By - Vy) + Mzz*(Bz - Vz)) + 2*(Bz - Vz)*(Mxy*(Bx - Vx) + Myy*(By - Vy) + Myz*(Bz - Vz))','Vx','Vy','Vz','Mxy','Mxz','Myy','Myz','Mzz','Bx','By','Bz');
   f6=  inline('2*(Bz - Vz)*(Mxz*(Bx - Vx) + Myz*(By - Vy) + Mzz*(Bz - Vz))','Vx','Vy','Vz','Mxz','Myz','Mzz','Bx','By','Bz');
   f7 = inline('2*Mxx*(Mxx*(Bx - Vx) + Mxy*(By - Vy) + Mxz*(Bz - Vz)) + 2*Mxy*(Mxy*(Bx - Vx) + Myy*(By - Vy) + Myz*(Bz - Vz)) + 2*Mxz*(Mxz*(Bx - Vx) + Myz*(By - Vy) + Mzz*(Bz - Vz))','Vx','Vy','Vz','Mxx','Mxy','Mxz','Myy','Myz','Mzz','Bx','By','Bz');
   f8 = inline('2*Mxy*(Mxx*(Bx - Vx) + Mxy*(By - Vy) + Mxz*(Bz - Vz)) + 2*Myy*(Mxy*(Bx - Vx) + Myy*(By - Vy) + Myz*(Bz - Vz)) + 2*Myz*(Mxz*(Bx - Vx) + Myz*(By - Vy) + Mzz*(Bz - Vz))','Vx','Vy','Vz','Mxx','Mxy','Mxz','Myy','Myz','Mzz','Bx','By','Bz');
   f9 = inline('2*Mxz*(Mxx*(Bx - Vx) + Mxy*(By - Vy) + Mxz*(Bz - Vz)) + 2*Myz*(Mxy*(Bx - Vx) + Myy*(By - Vy) + Myz*(Bz - Vz)) + 2*Mzz*(Mxz*(Bx - Vx) + Myz*(By - Vy) + Mzz*(Bz - Vz))','Vx','Vy','Vz','Mxx','Mxy','Mxz','Myy','Myz','Mzz','Bx','By','Bz');
            
   
   Vx = V(:,1); 
   Vy = V(:,2);
   Vz = V(:,3);

    
   m = length(V);
   R = zeros(m, 1);
   J = zeros(m, 2);
   v = [Mxx0, Mxy0, Mxz0, Myy0, Myz0, Mzz0, Bx0, By0, Bz0]';
 
   for n=0:itr % iterate
     % Calculate the Jacobian at every iteration 
     for i=1:length(Vx)
	      R(i)    =  f (Vx(i), Vy(i), Vz(i), Mxx0,Mxy0,Mxz0,Myy0,Myz0,Mzz0,Bx0,By0,Bz0);
	      J(i, 1) =  f1 (Vx(i),Vy(i),Vz(i),Mxx0,Mxy0,Mxz0,Myy0,Bx0,By0,Bz0);
          J(i, 2) =  f2(Vx(i),Vy(i),Vz(i),Mxx0,Mxy0,Mxz0,Myy0,Myz0,Bx0,By0,Bz0);
          J(i, 3) =  f3(Vx(i),Vy(i),Vz(i),Mxx0,Mxy0,Mxz0,Myz0,Mzz0,Bx0,By0,Bz0);
          J(i, 4) =  f4(Vx(i),Vy(i),Vz(i),Mxy0,Myy0,Myz0,Bx0,By0,Bz0);
          J(i, 5) =  f5(Vx(i),Vy(i),Vz(i),Mxy0,Mxz0,Myy0,Myz0,Mzz0,Bx0,By0,Bz0);
          J(i, 6) =  f6(Vx(i),Vy(i),Vz(i),Mxz0,Myz0,Mzz0,Bx0,By0,Bz0);
          J(i, 7) =  f7(Vx(i), Vy(i), Vz(i), Mxx0,Mxy0,Mxz0,Myy0,Myz0,Mzz0,Bx0,By0,Bz0);
          J(i, 8) =  f8(Vx(i), Vy(i), Vz(i), Mxx0,Mxy0,Mxz0,Myy0,Myz0,Mzz0,Bx0,By0,Bz0);
          J(i, 9) =  f9(Vx(i), Vy(i), Vz(i), Mxx0,Mxy0,Mxz0,Myy0,Myz0,Mzz0,Bx0,By0,Bz0);
     end
      
      Rnew = norm(R);
     
      H = inv(J'*J); % Hessian matrix
      D = (J'*R)';
      
      v = v - lambda*(D*H)';
      disp(sprintf('%d %0.9g %0.9g %0.9g %0.9g %0.9g %0.9g %0.9g %0.9g %0.9g % 0.9g ', n, v(1), v(2), v(3), v(4), v(5), v(6), v(7), v(8), v(9), norm(R)));
      
      % This is to make sure that the error is decereasing with every
      % iteration 
      if (Rnew <= Rold)
          lambda = lambda-kl*lambda;          
      else
          lambda = kl*lambda;          
      end
            
      % Iterations are stopped when the following convergence criteria is
      % satisfied
      if  (n>1)
          disp(sprintf('%d', abs(max(2*(v-vold)/(v+vold)))));
          if (abs(max(2*(v-vold)/(v+vold))) <= tol)
              disp('Convergence achieved');
              break;
          end
      end
           
      Mxx0 = v(1);
      Mxy0 = v(2);
      Mxz0 = v(3);
      Myy0 = v(4);
      Myz0 = v(5);
      Mzz0 = v(6);
      Bx0 = v(7);
      By0 = v(8);
      Bz0 = v(9);
      vold = v;
      Rold = Rnew;
   end
   
   % Save Outputs
   
   M = [v(1) v(2) v(3); v(2) v(4) v(5); v(3) v(5) v(6)];
   B = [v(7);v(8);v(9)];
   save M.mat;
   save B.mat;
   clear all
   
