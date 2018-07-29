function kcoeff = kwiener_train(X,Y,s)
% FUNCTION kcoeff = kwiener_train(X,Y,param)
%   AUTHOR:    Makoto Yamada
%              (myamada@ism.ac.jp)
%   DATE:       12/25/07
% 
%  DESCRIPTION:
% 
%   This function compute the kernel Wiener filter (kernel Dependency
%   Estimation) using Canonical Correlation Analysis (CCA) 
%   and outputs it in the abstract object "kcoeff".
%   The "kcoeff" object can then be used for finding pre-images.
%
%  INPUTS:
% 
%            X:     "X" is a (n times N) dimensional input matrix,
%                   where "n" is the vector dimension and N is the number
%                    of samples.
%
%            Y:     "Y" is a (m times N) dimensional output matrix.
%                    where "m" is the vector dimension and N is the number
%                    of samples.
%
%            s:      "s" is a parameter for Gaussian kernel, 
%                    exp(-norm(x - y)^2/s).
% 
%  OUTPUTS:
% 
%    kcoeff   :     The Kernel Wiener Filter object.
% 
% 
%  Example: 
%              load usps; %loading USPS data
%              s = 256*0.7; %Gaussian Kernel Parameter
%              %Training Kernel Wiener Filter
%              kcoeff = kwiener_train(X,Y,s);
%    
%  Reference:  1. J. Weston et.al. ``Kernel Dependency Estimation,'' NIPS
%                 2003
%
%              2. M. Yamada and M. R. Azimi-Sadjadi, ``Kernel Wiener Filter
%                 using Canonical Correlation Analysis Framework,''
%                 IEEE SSP'05, Bordeaux, France, July 17-20, 2005. 
%
%              3. C. Cortes et.al. ``A General Regression Technique for
%                 Learning Transductions,'' ICML, Bonn, Germany, Aug 7-11.
%
%              4. M. Yamada and M. R. Azimi-Sadjadi, ``Kernel Wiener Filter
%                 with Distance Constraint,'' ICASSP,  Toulouse, France,
%                 May 14-19, 2006
%
%              5. Zhe Chen et.al, ``Correlative Learning: A Basis for Brain and Adaptive
%                 Systems,'' Wiley, Oct. 2007 (Section 4.6)
          
n = size(X,2); %Number of Training samples

%Kernel Computation (Gaussian Kernel)
disp('Computing the Gram Matrix of X');
Kx = kernelg(X,X,s);
disp('Computing the Gram Matrix of Y');
Ky = kernelg(Y,Y,s);

%Centering Matrix
J = eye(n) - 1/n*ones(n);
%Centering Kernel Gram Matrix
A = J*Kx*J;

%Computing the Kernel Wiener Filter (Kernel Dependency Estimation)
%Computing the first kernel Canonical Coordinate.
[F D] = eig(A);
Lambda = sqrt(abs(real(diag(D))));
[YY I]  = sort(-Lambda);

%Normalizing Eigenvectors.
for k = 1:n
    if Lambda(k) ~= 0
        F(:,k)=F(:,k)/Lambda(k);
    end
end

Lambda = -YY;
F      = F(:,I);
kcoeff.Df   = F;                 %First kernel Canonical mapping function.
kcoeff.lambda = Lambda;          %Eigenvalue of kernel CCA.

%Computing the second kernel Canonical Coordinate.
ry = rank(Ky);
[Uy Wy Vy] = svd(Ky);
invKy = Vy(:,1:ry)*inv(Wy(1:ry, 1:ry))*Uy(:,1:ry)';
kcoeff.Dg = invKy*Kx*J*kcoeff.Df; %Second kernel Canonical mapping function.

kcoeff.Kxt = kcoeff.Df'*Kx;

%Computing rank of kernel Wiener filter.
[temp1,temp2] = find(kcoeff.lambda > 0);

if sum(temp2) == size(kcoeff.Kxt,2)
    kcoeff.rnk = sum(temp2) -1;
else
    kcoeff.rnk = sum(temp2);
end

disp('Finished Kernel Wiener Estimation');
