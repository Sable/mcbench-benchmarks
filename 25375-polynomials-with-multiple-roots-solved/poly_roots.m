function Z = poly_roots(p)
%
% *** Solve multiple-root polymonials ***
%     Revised from polyroots.m
%     All are simple arithematic operations, except roots.m. 
%     F C Chang    05/22/12
%
      Z = [ ];
      mz = length(p)-max(find(p));
   if mz > 0,   Z = [Z; 0,mz];   end;
      p0 = p(min(find(p)):max(find(p)));
      sr = abs(p0(end)/p0(1));
   if sr < 1,   p0 = p0(end:-1:1);     end;
      np0 = length(p0)-1;
   if np0 == 1,  return,   end;
      q0 = p0(1:np0+1).*[np0:-1:0];
      g1 = p0/p0(1); 
      g2 = q0/q0(1);
  for k = 1:np0+np0,
      l12 = length(g1)-length(g2);  l21 = -l12;
      g3 = [g2,zeros(1,l12)]-[g1,zeros(1,l21)];
      g3 = g3(min(find(abs(g3)>1.e-8)):max(find(abs(g3)>1.e-8))); 
   if norm(g3,inf)/norm([g1,g2],inf) < 1.e-3,   break;   end;
   if l12 > 0,  
      g1 = g2;      end;
      g2 = g3/g3(1);
  end;
      g0 = g1;
      ng0 = length(g0)-1;                          % p0,q0,g0
   if ng0 == 0,
      z0 = roots(p0);  if sr < 1, z0 = z0.^-1;  end;
      Z = [Z; z0,ones(np0,1)];    return,
   end;
      nu0 = np0-ng0;                               % np0,ng0,nu0
      g0 = [g0,zeros(1,nu0)];   u0 = [ ]; v0 = [ ];
  for k =1:nu0+1,
      u0(k) = p0(k)-[u0(1:k-1)]*[g0(k:-1:2)].';
      v0(k) = q0(k)-[v0(1:k-1)]*[g0(k:-1:2)].';
  end;
      u0 = u0(1:nu0+1);
      v0 = v0(1:nu0);
      w0 = u0(1:nu0).*[nu0:-1:1];                  % u0,v0,w0
      z0 = roots(u0);  if sr < 1, z0 = z0.^-1;  end;
      A0 = (z0*ones(1,nu0)).^(ones(nu0,1)*(nu0-1:-1:0));
      m0 = (A0*v0')./(A0*w0');                     % A0,z0,m0
      Z = [Z; z0,round(m0)];
