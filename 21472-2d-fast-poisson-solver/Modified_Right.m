%
% Written by M. Harper Langston - 5/10/00
% harper@cims.nyu.edu
%
% Right-hand vector is modified according to whether you're using
% the 5,9, or 9-point modified scheme.  This is called bt Form_Right.m
% which is called by poisson.m  If you are using the 5 or 9-point scheme,
% the result is straightforward, merely throwing away the boundary values
% in f.
% If you are using the modified nine-point scheme (corresponding to N=10),
% then the right hand side has a five-point stencil applied to it as per 
% Iserles, page 127.
function [v] = Modified_Right(f,m,N)
% Form the blocks, S, T and Z
if N==5 | N==9
   f = f(2:m+1,2:m+1);
   v = f(:);
   % The modified 9-point scheme can be computed quickly using the Gamma
   % matrix found from before and then using fast sine transforms.
elseif N==10 % Modified step for right side.  See Iserles, page 127
   % Compute Gamma for the modified scheme.  I let N = 101 here.  
   % Here,S = [1/12 2/3 1/12], T = [1/12] in a five-point manner.  See Form_Gamma.m
   % for more info.
   [Gam] = Form_Gamma(m,101);
   % Remove boundaries of f since we will apply a five-point stencil to it
   fbot = f(1,1:end); fleft = f(1:end,1); ftop = f(end,1:end); fright = f(1:end,end);
   % After removing boundaries, make f one long vector
   f = f(2:m+1,2:m+1);   f = f(:);   len = length(f);
   % As in 5-point stencil, make a new vector of the boundary points
   fnew = fleft(2:length(fleft)-1);
	fnew(len-m+1:len) = fright(2:length(fright)-1);
	for k = 1:m
  		fnew((k-1)*m + 1) = fnew((k-1)*m + 1) + fbot(k+1);
     	fnew(m*k) = fnew(m*k) + ftop(k+1);
   end
c = Transform(m,f)';
% Having formed c, rearrange rows into columns, so have to convert c to
% matrix format.  Only takes O(m) time which is negligible
for j = 1:m
   cnew(1:m,j) = c((j-1)*m + 1:(j-1)*m + m);
end
c = cnew';   c = c(:);
% Gam is tridiagonal and stored as sparse, so Gam*c is cheap.
t = Gam*c;
% The resulting vector t must be rearranged back so columns are rows: O(m)
for j = 1:m
   tnew(1:m,j) = t((j-1)*m + 1:(j-1)*m + m);
end
t = tnew';   t = t(:);
% Call the DF sine Transform routine for speed to get the final result,u:
v = Transform(m,t)';
v = v + (1/12).*fnew;
else
   error('Must use 9 or 5 point scheme (N = 5 ot N=9 in poisson.m)')
end
%
% Written by M. Harper Langston - 5/10/00
% harper@cims.nyu.edu
%