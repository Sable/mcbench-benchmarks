function [ic,ik] = bspkntins(d,c,k,u) 
%  
% Function Name: 
%  
%   bspkntins - Insert knots into a univariate B-Spline. 
%  
% Calling Sequence: 
%  
%   [ic,ik] = bspkntins(d,c,k,u) 
%  
% Parameters: 
%  
%   d	: Degree of the B-Spline. 
%  
%   c	: Control points, matrix of size (dim,nc). 
%  
%   k	: Knot sequence, row vector of size nk. 
%  
%   u	: Row vector of knots to be inserted, size nu 
%  
%   ic	: Control points of the new B-Spline, of size (dim,nc+nu) 
%  
%   ik	: Knot vector of the new B-Spline, of size (nk+nu) 
%  
% Description: 
%  
%   Insert knots into a univariate B-Spline. This function provides an 
%   interface to a toolbox 'C' routine. 
[mc,nc] = size(c); 
nu = numel(u); 
nk = numel(k); 
                                                     %  
                                                     % int bspkntins(int d, double *c, int mc, int nc, double *k, int nk, 
                                                     %               double *u, int nu, double *ic, double *ik) 
                                                     % { 
                                                     %   int ierr = 0; 
                                                     %   int a, b, r, l, i, j, m, n, s, q, ind; 
                                                     %   double alfa; 
                                                     % 
                                                     %   double **ctrl  = vec2mat(c, mc, nc); 
ic = zeros(mc,nc+nu);                                %   double **ictrl = vec2mat(ic, mc, nc+nu); 
ik = zeros(1,nk+nu); 
                                                     % 
n = size(c,2) - 1;                                   %   n = nc - 1; 
r = length(u) - 1;                                   %   r = nu - 1; 
                                                     % 
m = n + d + 1;                                       %   m = n + d + 1; 
a = findspan(n, d, u(1), k);                         %   a = findspan(n, d, u[0], k); 
b = findspan(n, d, u(r+1), k);                       %   b = findspan(n, d, u[r], k); 
b = b+1;                                             %   ++b; 
                                                     % 
for q=0:mc-1                                         %   for (q = 0; q < mc; q++)  { 
   for j=0:a-d, ic(q+1,j+1) = c(q+1,j+1); end        %     for (j = 0; j <= a-d; j++) ictrl[j][q] = ctrl[j][q]; 
   for j=b-1:n, ic(q+1,j+r+2) = c(q+1,j+1); end      %     for (j = b-1; j <= n; j++) ictrl[j+r+1][q] = ctrl[j][q]; 
end                                                  %   } 
 
for j=0:a, ik(j+1) = k(j+1); end                     %   for (j = 0; j <= a; j++)   ik[j] = k[j]; 
for j=b+d:m, ik(j+r+2) = k(j+1); end                 %   for (j = b+d; j <= m; j++) ik[j+r+1] = k[j]; 
                                                     % 
i = b + d - 1;                                       %   i = b + d - 1; 
s = b + d + r;                                       %   s = b + d + r; 
 
for j=r:-1:0                                         %   for (j = r; j >= 0; j--) { 
   while u(j+1) <= k(i+1) && i > a                   %     while (u[j] <= k[i] && i > a) { 
       for q=0:mc-1                                  %       for (q = 0; q < mc; q++) 
           ic(q+1,s-d) = c(q+1,i-d);                 %         ictrl[s-d-1][q] = ctrl[i-d-1][q]; 
       end                                               
       ik(s+1) = k(i+1);                             %       ik[s] = k[i]; 
       s = s - 1;                                    %       --s; 
       i = i - 1;                                    %       --i; 
   end                                               %     } 
    
   for q=0:mc-1                                      %     for (q = 0; q < mc; q++) 
       ic(q+1,s-d) = ic(q+1,s-d+1);                  %       ictrl[s-d-1][q] = ictrl[s-d][q]; 
   end 
 
   for l=1:d                                         %     for (l = 1; l <= d; l++)  { 
       ind = s - d + l;                              %       ind = s - d + l; 
       alfa = ik(s+l+1) - u(j+1);                    %       alfa = ik[s+l] - u[j]; 
       if abs(alfa) == 0                             %       if (fabs(alfa) == 0.0) 
           for q=0:mc-1                              %         for (q = 0; q < mc; q++) 
               ic(q+1,ind) = ic(q+1,ind+1);          %           ictrl[ind-1][q] = ictrl[ind][q]; 
           end 
       else                                          %       else  { 
           alfa = alfa/(ik(s+l+1) - k(i-d+l+1));     %         alfa /= (ik[s+l] - k[i-d+l]); 
           for q=0:mc-1                              %         for (q = 0; q < mc; q++) 
               tmp = (1-alfa)*ic(q+1,ind+1); 
               ic(q+1,ind) = alfa*ic(q+1,ind) + tmp; %           ictrl[ind-1][q] = alfa*ictrl[ind-1][q]+(1.0-alfa)*ictrl[ind][q]; 
           end 
       end                                           %       } 
   end                                               %     } 
   % 
   ik(s+1) = u(j+1);                                 %     ik[s] = u[j]; 
   s = s - 1;                                        %     --s; 
end                                                  %   } 
                                                     % 
                                                     %   freevec2mat(ctrl); 
                                                     %   freevec2mat(ictrl); 
                                                     % 
                                                     %   return ierr; 
                                                     % } 
 

