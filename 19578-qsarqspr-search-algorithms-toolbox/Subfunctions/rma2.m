function [Res] = rma2(P, Vec, Mat, Pth)

% rma2 replaces all descriptors from Mat except the ones in the given descriptor vector in the given position Pth and returns
%      and returns the vector with lower S_err, using multiple linear regression analysis.
%      (The initial descriptor is changed even if it has the lower S_err).
%           
%	   Input: 
%             P             Property vector
%             Vec          Descriptor vector
%             Mat           Descriptor matrix
%             Pth           Path to follow
%
%     Returns:
%          
%             Res           Vector containing in the first place the
%                           S_err, and afterwards the corresponding descriptor vector
%           
%
%
% Andrew G. Mercader
% INIFTA, La Plata, Argentina
% Created: 30 Jan 2007


if (nargin < 4)
   error('the function requires at least 4 input variables. Type ''help rma2''.');
end

[k, n_m] = size(Mat);

Num=[1:n_m];
Num(Vec)=[];
 

[k,n_n]=size(Num);

Smin=10000;   % A very big number compared to a normal S necessary just to start the program
for j=1:n_n;
Vec(Pth)=Num(j);
Ser=rms(P,Vec,Mat);
    if (Ser<Smin)
         Smin=Ser;
        desc=Num(j);
    end
end
Vec(Pth)=desc;
Res=[Smin, Vec];
%End of rma2