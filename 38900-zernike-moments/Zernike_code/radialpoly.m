function rad = radialpoly(r,n,m)
% -------------------------------------------------------------------------
% Copyright C 2012 Amir Tahmasbi
% The University of Texas at Dallas
% a.tahmasbi@utdallas.edu
% http://www.utdallas.edu/~a.tahmasbi/research.html
%
% License Agreement: You are free to use this code in your scientific
%                    research but you should cite the following papers:
%
% [1] - A. Tahmasbi, F. Saki, S. B. Shokouhi, 
%      	Classification of Benign and Malignant Masses Based on Zernike Moments, 
% 	J. Computers in Biology and Medicine, vol. 41, no. 8, pp. 726-735, 2011.
%
% [2] - A. Tahmasbi, F. Saki, H. Aghapanah, S. B. Shokouhi,
%	A Novel Breast Mass Diagnosis System based on Zernike Moments as Shape and Density Descriptors,
%	in Proc. IEEE, 18th Iranian Conf. on Biomedical Engineering (ICBME'2011), 
%	Tehran, Iran, 2011, pp. 100-104.
%
% -------------------------------------------------------------------------
% Function to compute Zernike Polynomials:
%
% f = radialpoly(r,n,m)
% where
%   r = radius
%   n = the order of Zernike polynomial
%   m = the repetition of Zernike moment

rad = zeros(size(r));                     % Initilization
for s = 0:(n-abs(m))/2
  c = (-1)^s*factorial(n-s)/(factorial(s)*factorial((n+abs(m))/2-s)*factorial((n-abs(m))/2-s));
  rad = rad + c*r.^(n-2*s);
end
