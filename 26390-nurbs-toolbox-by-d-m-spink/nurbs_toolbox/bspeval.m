function p = bspeval(d,c,k,u) 
%  
% Function Name: 
%  
%   bspeval - Evaluate a univariate B-Spline. 
%  
% Calling Sequence: 
%  
%   p = bspeval(d,c,k,u) 
%  
% Parameters: 
%  
%   d	: Degree of the B-Spline. 
%  
%   c	: Control Points, matrix of size (dim,nc). 
%  
%   k	: Knot sequence, row vector of size nk. 
%  
%   u	: Parametric evaluation points, row vector of size nu. 
%  
%   p	: Evaluated points, matrix of size (dim,nu) 
%  
% Description: 
%  
%   Evaluate a univariate B-Spline. This function provides an interface to 
%   a toolbox 'C' routine. 
nu = numel(u); 
[mc,nc] = size(c); 
                                                %   int bspeval(int d, double *c, int mc, int nc, double *k, int nk, double *u,int nu, double *p){ 
                                                %   int ierr = 0; 
                                                %   int i, s, tmp1, row, col; 
                                                %   double tmp2; 
                                                % 
                                                %   // Construct the control points 
                                                %   double **ctrl = vec2mat(c,mc,nc); 
                                                % 
                                                %   // Contruct the evaluated points 
p = zeros(mc,nu);                               %   double **pnt = vec2mat(p,mc,nu); 
                                                % 
                                                %   // space for the basis functions 
N = zeros(d+1,1);                               %   double *N = (double*) mxMalloc((d+1)*sizeof(double)); 
                                                % 
                                                %   // for each parametric point i 
for col=1:nu                                    %   for (col = 0; col < nu; col++) { 
                                                %     // find the span of u[col] 
    s = findspan(nc-1, d, u(col), k);           %     s = findspan(nc-1, d, u[col], k); 
    N = basisfun(s,u(col),d,k);                 %     basisfun(s, u[col], d, k, N); 
                                                % 
    tmp1 = s - d + 1;                           %     tmp1 = s - d; 
    for row=1:mc                                %     for (row = 0; row < mc; row++)  { 
        tmp2 = 0;                               %       tmp2 = 0.0; 
        for i=0:d                               %       for (i = 0; i <= d; i++) 
           tmp2 = tmp2 + N(i+1)*c(row,tmp1+i);  % 	tmp2 += N[i] * ctrl[tmp1+i][row]; 
        end                                     % 
        p(row,col) = tmp2;                      %       pnt[col][row] = tmp2; 
    end                                         %     } 
end                                             %   } 
                                                % 
                                                %   mxFree(N); 
                                                %   freevec2mat(pnt); 
                                                %   freevec2mat(ctrl); 
                                                % 
                                                %   return ierr; 
                                                %   } 
