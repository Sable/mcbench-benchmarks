function [rf, vf, stm] = stm2 (mu, tau, ri, vi)

% two body state transition matrix

% Shepperd's method

% input

%  tau = propagation time interval (seconds)
%  ri  = initial eci position vector (kilometers)
%  vi  = initial eci velocity vector (km/sec)

% output

%  rf  = final eci position vector (kilometers)
%  vf  = final eci velocity vector (km/sec)
%  stm = state transition matrix

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% convergence criterion

tol = 1.0e-6;

n0 = dot(ri, vi);
   
r0 = norm(ri);
   
beta = (2 * mu / r0) - dot(vi, vi);

u = 0;
    
if (beta ~= 0)
   umax = 1 / sqrt(abs(beta));
else
   umax = 1.0e24;
end

umin = -umax;

if (beta <= 0)
   delu = 0;
else
   p = 2 * pi * mu * beta ^ (-1.5);
   n = fix((1 / p) * (tau + 0.5 * p - 2 * n0 / beta));
   delu = 2 * n * pi * beta ^ (-2.5);
end

tsav = 1.0e99;

niter = 0;

% kepler iteration loop

while (1)
    
  niter = niter + 1;
      
  q = beta * u * u;
  q = q / (1 + q);
  u0 = 1 - 2 * q;
  u1 = 2 * u * (1 - q);
      
  % continued fraction iteration

  n = 0;
  l = 3;
  d = 15;
  k = -9;
  a = 1;
  b = 1;
  g = 1;

  while (1)
      
    gsav = g;
    k = -k;
    l = l + 2;
    d = d + 4 * l;
    n = n + (1 + k) * l;
    a = d / (d - n * a * q);
    b = (a - 1) * b;
    g = g + b;
    
    if (abs(g - gsav) < tol)
       break;
    end
    
  end  
  
  uu = (16 / 15) * u1 * u1 * u1 * u1 * u1 * g + delu;
       
  u2 = 2 * u1 * u1;
  u1 = 2 * u0 * u1;
  u0 = 2 * u0 * u0 - 1;
  u3 = beta * uu + u1 * u2 / 3;
      
  r1 = r0 * u0 + n0 * u1 + mu * u2;
  t = r0 * u1 + n0 * u2 + mu * u3;
       
  dtdu = 4 * r1 * (1 - q);
     
  % check for time convergence

  if (abs(t - tsav) < tol)
     break;
  end   

  usav = u;
  tsav = t;
  terr = tau - t;

  if (abs(terr) < abs(tau) * tol)
     break;
  end   

  du = terr / dtdu;
      
  if (du < 0)
     umax = u;
     u = u + du;
     if (u < umin)
        u = 0.5 * (umin + umax);
     end   
  else
     umin = u;
     u = u + du;
     if (u > umax)
        u = 0.5 * (umin + umax);
     end   
  end

  % check for independent variable convergence

  if (abs(u - usav) < tol)
     break;
  end   
  
  % check for more than 20 iterations
  
  if (niter > 20)
      
     fprintf('\nmore than 20 iterations in stm2\n');
     
     pause;
  end   

end

uc = u;

fm = -mu * u2 / r0;
ggm = -mu * u2 / r1;
f = 1 + fm;
g = r0 * u1 + n0 * u2;
ff = -mu * u1 / (r0 * r1);
gg = 1 + ggm;

% compute final state vector

rx = ri;
vx = vi;
rf = f * ri + g * vi;
vf = ff * ri + gg * vi;

uu = g * u2 + 3 * mu * uu;

a0 = mu / r0^3;
a1 = mu / r1^3;

m(1,1) = ff * (u0 / (r0 * r1) + 1 / (r0 * r0) + 1 / (r1 * r1));
m(1,2) = (ff * u1 + (ggm / r1)) / r1;
m(1,3) = ggm * u1 / r1;
m(2,1) = -(ff * u1 + (fm / r0)) / r0;
m(2,2) = -ff * u2;
m(2,3) = -ggm * u2;
m(3,1) = fm * u1 / r0;
m(3,2) = fm * u2;
m(3,3) = g * u2;

m(1,1) = m(1,1) - a0 * a1 * uu;
m(1,3) = m(1,3) - a1 * uu;
m(3,1) = m(3,1) - a0 * uu;
m(3,3) = m(3,3) - uu;

for i = 1:1:2
    x = 2 * i - 3;
    ib = 3 * (2 - i);
    for j = 1:1:2
        jb = 3 * (j - 1);
        for ii = 1:1:3
            t1 = rf(ii) * m(i,j) + vf(ii) * m(i+1,j);
            t2 = rf(ii) * m(i,j+1) + vf(ii) * m(i+1,j+1);
            for jj = 1:1:3
                stm(ii+ib, jj+jb) = x * (t1 * rx(jj) + t2 * vx(jj));
            end
        end
    end
end

for i = 1:1:3
    j = i + 3;
    stm(i,i) = stm(i,i) + f;
    stm(i,j) = stm(i,j) + g;
    stm(j,i) = stm(j,i) + ff;
    stm(j,j) = stm(j,j) + gg;
end

