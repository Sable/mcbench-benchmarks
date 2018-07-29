function [Res] = rmsr_inv(P, VecI, Mat, Pth)

% rmsr_inv replaces all descriptors from Mat (except the ones in the given descriptor vector) in the given position Pth and returns
%      the vector with higher S_err, using multiple linear regression analysis.
%
%           
%	   Input: 
%             P             Property vector
%             VecI          Descriptor vector
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
   error('rmsr_inv requires at least 4 input variables. Type ''help rmsr_inv''.');
end

[k, n_m] = size(Mat);

Num=[1:n_m];
Vec2=VecI;
Vec2(Pth)=[];
Num(Vec2)=[];
 

[k,n_n]=size(Num);

Smax=0.00000000000000000000000000000000001;   % A very big number compared to a normal S necessary just to start the program
for j=1:n_n;
VecI(Pth)=Num(j);
Ser=rms_inv(P,VecI,Mat);
    if (Ser>Smax)
         Smax=Ser;
        desc=Num(j);
    end
end
VecI(Pth)=desc;
Res=[Smax, VecI];
%End of rmsr_inv