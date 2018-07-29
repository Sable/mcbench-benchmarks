function [yout,t] = ramp(num, den, c)
%RAMP  RAMP response of SISO LTI models.
%
%   RAMP(num,den) plots the ramp response of the Transfer Functions.
%   defined with the numerator and denominator coefficients.
%   The time range and number of points are chosen automatically.
%   
%   RAMP(num,den,TFINAL) simulates the ramp response from t=0 to the 
%   final time t=TFINAL. 
%
%   [Y,T] = RAMP(SYS) returns the output response Y and the time 
%   vector T used for simulation.  No plot is drawn on the screen.  
%
%   Version 1.0 Atakan Varol 9-6-2005
%   The function RAMP is based on the Matlab function STEP
%   Hopefully will be updated soon for SS, discrete time systems and MIMO.

ni = nargin;
no = nargout;
den = [den 0];          % Just add one integrator to the transfer function
error(nargchk(2,3,ni));

% Determine which syntax is being used
switch ni
    case 2
        sys = tf(num,den);
        t = [];
    case 3
        % Transfer function form with time vector
        sys = tf(num,den);
        t = c;
end

if no==1,
   yout = step(sys,t);
   yout = yout(:,:);
elseif no>1,
   [yout,t] = step(sys,t);
   yout = yout(:,:);
   t = t';
else
   step(sys,t);
   title('Ramp Response')
end
% end ramp