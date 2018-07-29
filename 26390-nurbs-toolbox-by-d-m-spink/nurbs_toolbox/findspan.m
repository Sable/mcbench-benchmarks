function s = findspan(n,p,u,U)                 
% FINDSPAN  Find the span of a B-Spline knot vector at a parametric point 
% ------------------------------------------------------------------------- 
% ADAPTATION of FINDSPAN from C 
% ------------------------------------------------------------------------- 
% 
% Calling Sequence: 
%  
%   s = findspan(n,p,u,U) 
%  
%  INPUT: 
%  
%    n - number of control points - 1 
%    p - spline degree 
%    u - parametric point 
%    U - knot sequence 
%  
%  RETURN: 
%  
%    s - knot span 
%  
%  Algorithm A2.1 from 'The NURBS BOOK' pg68 
                                                 
                                                % int findspan(int n, int p, double u, double *U) { 
                                                 
                                                %   int low, high, mid;                                                 
                                                %   // special case 
if (u==U(n+2)), s=n; return,  end               %   if (u == U[n+1]) return(n); 
                                                % 
                                                %   // do binary search 
low = p;                                        %   low = p; 
high = n + 1;                                   %   high = n + 1; 
mid = floor((low + high) / 2);                  %   mid = (low + high) / 2; 
while (u < U(mid+1) || u >= U(mid+2))           %   while (u < U[mid] || u >= U[mid+1])  { 
    if (u < U(mid+1))                           %     if (u < U[mid]) 
        high = mid;                             %       high = mid; 
    else                                        %     else 
        low = mid;                              %       low = mid;                   
    end  
    mid = floor((low + high) / 2);              %     mid = (low + high) / 2; 
end                                             %   } 
                                                % 
s = mid;                                        %   return(mid); 
                                                %   } 
