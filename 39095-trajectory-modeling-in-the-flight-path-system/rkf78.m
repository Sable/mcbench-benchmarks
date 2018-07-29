function xout = rkf78 (deq, neq, ti, tf, h, tetol, x)

% solve first order system of differential equations

% Runge-Kutta-Fehlberg 7(8) method

% input

%  deq   = name of function which defines the
%          system of differential equations
%  neq   = number of differential equations
%  ti    = initial simulation time
%  tf    = final simulation time
%  h     = initial guess for integration step size
%  tetol = truncation error tolerance (non-dimensional)
%  x     = integration vector at time = ti

% output

%  xout  = integration vector at time = tf

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global rkcoef ch alph beta

if (rkcoef == 1)

   % allocate arrays

   ch = zeros(13, 1);
   alph = zeros(13, 1);
   beta = zeros(13, 12);

   % define integration coefficients

   ch(6) = 34 / 105;
   ch(7) = 9 / 35;
   ch(8) = ch(7);
   ch(9) = 9 / 280;
   ch(10) = ch(9);
   ch(12) = 41 / 840;
   ch(13) = ch(12);
 
   alph(2) = 2 / 27;
   alph(3) = 1 / 9;
   alph(4) = 1 / 6;
   alph(5) = 5 / 12;
   alph(6) = 0.5;
   alph(7) = 5 / 6;
   alph(8) = 1 / 6;
   alph(9) = 2 / 3;
   alph(10) = 1 / 3;
   alph(11) = 1;
   alph(13) = 1;

   beta(2, 1) = 2 / 27;
   beta(3, 1) = 1 / 36;
   beta(4, 1) = 1 / 24;
   beta(5, 1) = 5 / 12;
   beta(6, 1) = 0.05;
   beta(7, 1) = -25 / 108;
   beta(8, 1) = 31 / 300;
   beta(9, 1) = 2;
   beta(10, 1) = -91 / 108;
   beta(11, 1) = 2383 / 4100;
   beta(12, 1) = 3 / 205;
   beta(13, 1) = -1777 / 4100;
   beta(3, 2) = 1 / 12;
   beta(4, 3) = 1 / 8;
   beta(5, 3) = -25 / 16;
   beta(5, 4) = -beta(5, 3);
   beta(6, 4) = 0.25;
   beta(7, 4) = 125 / 108;
   beta(9, 4) = -53 / 6;
   beta(10, 4) = 23 / 108;
   beta(11, 4) = -341 / 164;
   beta(13, 4) = beta(11, 4);
   beta(6, 5) = 0.2;
   beta(7, 5) = -65 / 27;
   beta(8, 5) = 61 / 225;
   beta(9, 5) = 704 / 45;
   beta(10, 5) = -976 / 135;
   beta(11, 5) = 4496 / 1025;
   beta(13, 5) = beta(11, 5);
   beta(7, 6) = 125 / 54;
   beta(8, 6) = -2 / 9;
   beta(9, 6) = -107 / 9;
   beta(10, 6) = 311 / 54;
   beta(11, 6) = -301 / 82;
   beta(12, 6) = -6 / 41;
   beta(13, 6) = -289 / 82;
   beta(8, 7) = 13 / 900;
   beta(9, 7) = 67 / 90;
   beta(10, 7) = -19 / 60;
   beta(11, 7) = 2133 / 4100;
   beta(12, 7) = -3 / 205;
   beta(13, 7) = 2193 / 4100;
   beta(9, 8) = 3;
   beta(10, 8) = 17 / 6;
   beta(11, 8) = 45 / 82;
   beta(12, 8) = -3 / 41;
   beta(13, 8) = 51 / 82;
   beta(10, 9) = -1 / 12;
   beta(11, 9) = 45 / 164;
   beta(12, 9) = 3 / 41;
   beta(13, 9) = 33 / 164;
   beta(11, 10) = 18 / 41;
   beta(12, 10) = 6 / 41;
   beta(13, 10) = 12 / 41;
   beta(13, 12) = 1;

   % set initialization indicator

   rkcoef = 0;
end

f = zeros(neq, 13);

xdot = zeros(1, neq);

xwrk = zeros(1, neq);

% compute integration "direction"

sdt = sign(tf - ti);

dt = abs(h) * sdt;

while (1)

   % load "working" time and integration vector

   twrk = ti;
       
   xwrk = x;

   % check for last dt

   if (abs(dt) > abs(tf - ti)) 
      dt = tf - ti;
   end

   % check for end of integration period

   if (abs(ti - tf) < 0.00000001)
      xout = x;
      return;
   end

   % evaluate equations of motion

   xdot = feval(deq, ti, x);
   
   f(:, 1) = xdot';
      
   % compute solution

   for k = 2:1:13
       kk = k - 1;
      
       for i = 1:1:neq                      
           x(i) = xwrk(i) + dt * sum(beta(k, 1:kk).* f(i, 1:kk));
       end
       
       ti = twrk + alph(k) * dt;

       xdot = feval(deq, ti, x);

       f(:, k) = xdot';
   end
   
   xerr = tetol;

   for i = 1:1:neq
      
       x(i) = xwrk(i) + dt * sum(ch.* f(i, :)');
       
       % truncation error calculations

       ter = abs((f(i, 1) + f(i, 11) - f(i, 12) - f(i, 13)) * ch(12) * dt);
       tol = abs(x(i)) * tetol + tetol;
       tconst = ter / tol;
       
       if (tconst > xerr)
          xerr = tconst;
       end
   end

   % compute new step size

   dt = 0.8 * dt * (1 / xerr) ^ (1 / 8);
   
   if (xerr > 1)
      % reject current step
      ti = twrk;
      x = xwrk;
   else
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % accept current step              %
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % perform graphics, additional     %
      % calculations, etc. at this point %
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   end
end



