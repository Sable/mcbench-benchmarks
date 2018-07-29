function [ic,ik] = bspdegelev(d,c,k,t) 
%  
% Function Name: 
%  
%   bspdegevel - Degree elevate a univariate B-Spline. 
%  
% Calling Sequence: 
%  
%   [ic,ik] = bspdegelev(d,c,k,t) 
%  
% Parameters: 
%  
%   d	: Degree of the B-Spline. 
%  
%   c	: Control points, matrix of size (dim,nc). 
%  
%   k	: Knot sequence, row vector of size nk. 
%  
%   t	: Raise the B-Spline degree t times. 
%  
%   ic	: Control points of the new B-Spline. 
%  
%   ik	: Knot vector of the new B-Spline. 
%  
% Description: 
%  
%   Degree elevate a univariate B-Spline. This function provides an 
%   interface to a toolbox 'C' routine. 
 
[mc,nc] = size(c); 
                                                          % 
                                                          % int bspdegelev(int d, double *c, int mc, int nc, double *k, int nk, 
                                                          %                int t, int *nh, double *ic, double *ik) 
                                                          % { 
                                                          %   int row,col; 
                                                          % 
                                                          %   int ierr = 0; 
                                                          %   int i, j, q, s, m, ph, ph2, mpi, mh, r, a, b, cind, oldr, mul; 
                                                          %   int n, lbz, rbz, save, tr, kj, first, kind, last, bet, ii; 
                                                          %   double inv, ua, ub, numer, den, alf, gam; 
                                                          %   double **bezalfs, **bpts, **ebpts, **Nextbpts, *alfs; 
                                                          % 
                                                          %   double **ctrl  = vec2mat(c, mc, nc); 
% ic = zeros(mc,nc*(t));                                  %   double **ictrl = vec2mat(ic, mc, nc*(t+1)); 
                                                          % 
n = nc - 1;                                               %   n = nc - 1; 
                                                          % 
bezalfs =  zeros(d+1,d+t+1);                              %   bezalfs = matrix(d+1,d+t+1); 
bpts = zeros(mc,d+1);                                     %   bpts = matrix(mc,d+1); 
ebpts = zeros(mc,d+t+1);                                  %   ebpts = matrix(mc,d+t+1); 
Nextbpts = zeros(mc,d+1);                                 %   Nextbpts = matrix(mc,d+1); 
alfs = zeros(d,1);                                        %   alfs = (double *) mxMalloc(d*sizeof(double)); 
                                                          % 
m = n + d + 1;                                            %   m = n + d + 1; 
ph = d + t;                                               %   ph = d + t; 
ph2 = floor(ph / 2);                                      %   ph2 = ph / 2; 
                                                          % 
                                                          %   // compute bezier degree elevation coefficeients 
bezalfs(1,1) = 1;                                         %   bezalfs[0][0] = bezalfs[ph][d] = 1.0; 
bezalfs(d+1,ph+1) = 1;                                    % 
 
for i=1:ph2                                               %   for (i = 1; i <= ph2; i++) { 
   inv = 1/bincoeff(ph,i);                                %     inv = 1.0 / bincoeff(ph,i); 
   mpi = min(d,i);                                        %     mpi = min(d,i); 
                                                          % 
   for j=max(0,i-t):mpi                                   %     for (j = max(0,i-t); j <= mpi; j++) 
       bezalfs(j+1,i+1) = inv*bincoeff(d,j)*bincoeff(t,i-j);  %       bezalfs[i][j] = inv * bincoeff(d,j) * bincoeff(t,i-j); 
   end                                                        
end                                                       %   } 
                                                          % 
for i=ph2+1:ph-1                                          %   for (i = ph2+1; i <= ph-1; i++) { 
   mpi = min(d,i);                                        %     mpi = min(d, i); 
   for j=max(0,i-t):mpi                                   %     for (j = max(0,i-t); j <= mpi; j++) 
       bezalfs(j+1,i+1) = bezalfs(d-j+1,ph-i+1);          %       bezalfs[i][j] = bezalfs[ph-i][d-j]; 
   end                                                        
end                                                       %   } 
                                                          % 
mh = ph;                                                  %   mh = ph;       
kind = ph+1;                                              %   kind = ph+1; 
r = -1;                                                   %   r = -1; 
a = d;                                                    %   a = d; 
b = d+1;                                                  %   b = d+1; 
cind = 1;                                                 %   cind = 1; 
ua = k(1);                                                %   ua = k[0];  
                                                          % 
for ii=0:mc-1                                             %   for (ii = 0; ii < mc; ii++) 
   ic(ii+1,1) = c(ii+1,1);                                %     ictrl[0][ii] = ctrl[0][ii]; 
end                                                       % 
for i=0:ph                                                %   for (i = 0; i <= ph; i++) 
   ik(i+1) = ua;                                          %     ik[i] = ua; 
end                                                       % 
                                                          %   // initialise first bezier seg 
for i=0:d                                                 %   for (i = 0; i <= d; i++) 
   for ii=0:mc-1                                          %     for (ii = 0; ii < mc; ii++) 
      bpts(ii+1,i+1) = c(ii+1,i+1);                       %       bpts[i][ii] = ctrl[i][ii]; 
   end                                                        
end                                                       % 
                                                          %   // big loop thru knot vector 
while b < m                                               %   while (b < m)  { 
   i = b;                                                 %     i = b; 
   while b < m && k(b+1) == k(b+2)                        %     while (b < m && k[b] == k[b+1]) 
      b = b + 1;                                          %       b++; 
   end                                                    % 
   mul = b - i + 1;                                       %     mul = b - i + 1; 
   mh = mh + mul + t;                                     %     mh += mul + t; 
   ub = k(b+1);                                           %     ub = k[b]; 
   oldr = r;                                              %     oldr = r; 
   r = d - mul;                                           %     r = d - mul; 
                                                          % 
                                                          %     // insert knot u(b) r times 
   if oldr > 0                                            %     if (oldr > 0) 
      lbz = floor((oldr+2)/2);                            %       lbz = (oldr+2) / 2; 
   else                                                   %     else 
      lbz = 1;                                            %       lbz = 1; 
   end                                                    % 
    
   if r > 0                                               %     if (r > 0) 
      rbz = ph - floor((r+1)/2);                          %       rbz = ph - (r+1)/2; 
   else                                                   %     else 
      rbz = ph;                                           %       rbz = ph; 
   end                                                    % 
    
   if r > 0                                               %     if (r > 0) { 
                                                          %       // insert knot to get bezier segment 
      numer = ub - ua;                                    %       numer = ub - ua; 
      for q=d:-1:mul+1                                    %       for (q = d; q > mul; q--) 
         alfs(q-mul) = numer / (k(a+q+1)-ua);             %         alfs[q-mul-1] = numer / (k[a+q]-ua); 
      end                                            
       
      for j=1:r                                           %       for (j = 1; j <= r; j++)  { 
         save = r - j;                                    %         save = r - j; 
         s = mul + j;                                     %         s = mul + j; 
                                                          % 
         for q=d:-1:s                                     %         for (q = d; q >= s; q--) 
            for ii=0:mc-1                                 %           for (ii = 0; ii < mc; ii++) 
               tmp1 = alfs(q-s+1)*bpts(ii+1,q+1);  
               tmp2 = (1-alfs(q-s+1))*bpts(ii+1,q);  
               bpts(ii+1,q+1) = tmp1 + tmp2;              %             bpts[q][ii] = alfs[q-s]*bpts[q][ii]+(1.0-alfs[q-s])*bpts[q-1][ii]; 
            end                                               
         end                                              % 
          
         for ii=0:mc-1                                    %         for (ii = 0; ii < mc; ii++) 
            Nextbpts(ii+1,save+1) = bpts(ii+1,d+1);       %           Nextbpts[save][ii] = bpts[d][ii]; 
         end                                                  
      end                                                 %       } 
   end                                                    %     } 
                                                          %     // end of insert knot 
                                                          % 
                                                          %     // degree elevate bezier 
   for i=lbz:ph                                           %     for (i = lbz; i <= ph; i++)  { 
      for ii=0:mc-1                                       %       for (ii = 0; ii < mc; ii++) 
         ebpts(ii+1,i+1) = 0;                             %         ebpts[i][ii] = 0.0; 
      end                                                     
      mpi = min(d, i);                                    %       mpi = min(d, i); 
      for j=max(0,i-t):mpi                                %       for (j = max(0,i-t); j <= mpi; j++) 
         for ii=0:mc-1                                    %         for (ii = 0; ii < mc; ii++) 
            tmp1 = ebpts(ii+1,i+1);  
            tmp2 = bezalfs(j+1,i+1)*bpts(ii+1,j+1); 
            ebpts(ii+1,i+1) = tmp1 + tmp2;                %           ebpts[i][ii] = ebpts[i][ii] + bezalfs[i][j]*bpts[j][ii]; 
         end                                                  
      end                                                     
   end                                                    %     } 
                                                          %     // end of degree elevating bezier 
                                                          % 
   if oldr > 1                                            %     if (oldr > 1)  { 
                                                          %       // must remove knot u=k[a] oldr times 
      first = kind - 2;                                                    %       first = kind - 2; 
      last = kind;                                        %       last = kind; 
      den = ub - ua;                                      %       den = ub - ua; 
      bet = floor((ub-ik(kind)) / den);                   %       bet = (ub-ik[kind-1]) / den; 
                                                          % 
                                                          %       // knot removal loop 
      for tr=1:oldr-1                                     %       for (tr = 1; tr < oldr; tr++)  { 
         i = first;                                       %         i = first; 
         j = last;                                        %         j = last; 
         kj = j - kind + 1;                               %         kj = j - kind + 1; 
         while j-i > tr                                   %         while (j - i > tr)  { 
                                                          %           // loop and compute the new control points 
                                                          %           // for one removal step 
            if i < cind                                   %           if (i < cind)  { 
               alf = (ub-ik(i+1))/(ua-ik(i+1));           %             alf = (ub-ik[i])/(ua-ik[i]); 
               for ii=0:mc-1                              %             for (ii = 0; ii < mc; ii++) 
                  tmp1 = alf*ic(ii+1,i+1);  
                  tmp2 = (1-alf)*ic(ii+1,i);  
                  ic(ii+1,i+1) = tmp1 + tmp2;             %               ictrl[i][ii] = alf * ictrl[i][ii] + (1.0-alf) * ictrl[i-1][ii]; 
               end                                            
            end                                           %           } 
            if j >= lbz                                   %           if (j >= lbz)  { 
               if j-tr <= kind-ph+oldr                    %             if (j-tr <= kind-ph+oldr) { 
                  gam = (ub-ik(j-tr+1)) / den;            %               gam = (ub-ik[j-tr]) / den; 
                  for ii=0:mc-1                           %               for (ii = 0; ii < mc; ii++) 
                     tmp1 = gam*ebpts(ii+1,kj+1);  
                     tmp2 = (1-gam)*ebpts(ii+1,kj+2);  
                     ebpts(ii+1,kj+1) = tmp1 + tmp2;      %                 ebpts[kj][ii] = gam*ebpts[kj][ii] + (1.0-gam)*ebpts[kj+1][ii]; 
                  end                                     %             } 
               else                                       %             else  { 
                  for ii=0:mc-1                           %               for (ii = 0; ii < mc; ii++) 
                     tmp1 = bet*ebpts(ii+1,kj+1);                                      
                     tmp2 = (1-bet)*ebpts(ii+1,kj+2);                                      
                     ebpts(ii+1,kj+1) = tmp1 + tmp2;      %                 ebpts[kj][ii] = bet*ebpts[kj][ii] + (1.0-bet)*ebpts[kj+1][ii]; 
                  end                                         
               end                                        %             } 
            end                                           %           } 
            i = i + 1;                                    %           i++; 
            j = j - 1;                                    %           j--; 
            kj = kj - 1;                                  %           kj--; 
         end                                              %         } 
                                                          % 
         first = first - 1;                               %         first--; 
         last = last + 1;                                 %         last++; 
      end                                                 %       } 
   end                                                    %     } 
                                                          %     // end of removing knot n=k[a] 
                                                          % 
                                                          %     // load the knot ua 
   if a ~= d                                              %     if (a != d) 
      for i=0:ph-oldr-1                                   %       for (i = 0; i < ph-oldr; i++)  { 
         ik(kind+1) = ua;                                 %         ik[kind] = ua; 
         kind = kind + 1;                                 %         kind++; 
      end 
   end                                                    %       } 
                                                          % 
                                                          %     // load ctrl pts into ic 
      for j=lbz:rbz                                       %     for (j = lbz; j <= rbz; j++)  { 
         for ii=0:mc-1                                    %       for (ii = 0; ii < mc; ii++) 
            ic(ii+1,cind+1) = ebpts(ii+1,j+1);            %         ictrl[cind][ii] = ebpts[j][ii]; 
         end                                                  
         cind = cind + 1;                                 %       cind++; 
      end                                                 %     } 
                                                          % 
      if b < m                                            %     if (b < m)  { 
                                                          %       // setup for next pass thru loop 
         for j=0:r-1                                      %       for (j = 0; j < r; j++) 
            for ii=0:mc-1                                 %         for (ii = 0; ii < mc; ii++) 
               bpts(ii+1,j+1) = Nextbpts(ii+1,j+1);       %           bpts[j][ii] = Nextbpts[j][ii]; 
            end                                            
         end                                               
         for j=r:d                                        %       for (j = r; j <= d; j++) 
            for ii=0:mc-1                                 %         for (ii = 0; ii < mc; ii++) 
               bpts(ii+1,j+1) = c(ii+1,b-d+j+1);          %           bpts[j][ii] = ctrl[b-d+j][ii]; 
            end                                               
         end                                                  
         a = b;                                           %       a = b; 
         b = b+1;                                         %       b++; 
         ua = ub;                                         %       ua = ub; 
                                                          %     } 
      else                                                %     else 
                                                          %       // end knot 
         for i=0:ph                                       %       for (i = 0; i <= ph; i++) 
            ik(kind+i+1) = ub;                            %         ik[kind+i] = ub; 
         end                                                  
      end                                                     
end                                                       %   } 
% End big while loop                                      %   // end while loop 
                                                          % 
                                                          %   *nh = mh - ph - 1; 
                                                          % 
                                                          %   freevec2mat(ctrl); 
                                                          %   freevec2mat(ictrl); 
                                                          %   freematrix(bezalfs); 
                                                          %   freematrix(bpts); 
                                                          %   freematrix(ebpts); 
                                                          %   freematrix(Nextbpts); 
                                                          %   mxFree(alfs); 
                                                          % 
                                                          %   return(ierr); 
                                                          % } 
 
                                                           
function b = bincoeff(n,k) 
%  Computes the binomial coefficient. 
% 
%      ( n )      n! 
%      (   ) = -------- 
%      ( k )   k!(n-k)! 
% 
%  b = bincoeff(n,k) 
% 
%  Algorithm from 'Numerical Recipes in C, 2nd Edition' pg215. 
 
                                                          % double bincoeff(int n, int k) 
                                                          % { 
b = floor(0.5+exp(factln(n)-factln(k)-factln(n-k)));      %   return floor(0.5+exp(factln(n)-factln(k)-factln(n-k))); 
                                                          % } 
 
function f = factln(n) 
% computes ln(n!) 
if n <= 1, f = 0; return, end 
f = gammaln(n+1); %log(factorial(n));</pre>
