% Calculate the eigenvalues of massive 3x3 real symmetric matrices.
% Computation is based on matrix operation and GPU computation is 
% supported.
% Syntax:
% [eigenvalue1,eigenvalue2,eigenvalue3] = eigenvaluefield33( a11, a12, a13, a22, a23, a33)
% a11, a12, a13, a22, a23 and a33 specify the symmetric 3x3 real symmetric
% matrices as:
%   a11 a12 a13
% [ a12 a22 a13 ]
%   a13 a23 a33
% These six inputs must have the same size. They can be 2D, 3D or any
% dimension. The outputs eigenvalue1, eigenvalue2 and eigenvalue3 will
% follow the size and dimension of these inputs. Owing to the use of 
% trigonometric functions, the inputs must be double to maintain the 
% accuracy.
%
% eigenvalue1, eigenvalue2 and eigenvalue3 are the unordered resultant 
% eigenvalues. They are solved using the cubic equation solver, see
% http://en.wikipedia.org/wiki/Eigenvalue_algorithm
%
% The peak memory consumption of the method is about 1.5 times of the total 
% of all inputs, in addition to the original inputs. GPU computation is 
% used automatically if all inputs are matlab GPU arrays. 
%
% Author: Max W.K. Law
% Email:  max.w.k.law@gmail.com
% Page:   http://www.cse.ust.hk/~maxlawwk/
%
function [b,j,d] = eigenvaluefield33( a11, a12, a13, a22, a23, a33)
%    multiprocess;
%    b=a11*0;
%    j=a11*0;
%    d=a11*0;
%    parfor i=1:numel(a11)
%        [~,l]=eig([a11(i) a12(i) a13(i); a12(i) a22(i) a23(i); a13(i) a23(i) a33(i)]);
%        b(i)=l(1,1);
%        j(i)=l(2,2);
%        d(i)=l(3,3);
%    end
%    return;

    ep=1e-50;
    b=double(a11)+ep;
    d=double(a22)+ep;
    j=double(a33)+ep;

    c=-(double(a12).^2 + double(a13).^2 + double(a23).^2 - b.*d - d.*j - j.*b);
    d=-(b.*d.*j - double(a23).^2.*b - double(a12).^2.*j - double(a13).^2.*d + 2*double(a13).*double(a12).*double(a23));

    b=-double(a11) - double(a22) - double(a33) - ep - ep -ep;

    
    d = d + ((2*b.^3) - (9*b.*c))/27;

%     c=c-(b.^2)/3;
%     c=c.^3;
%     c=c/27;
%     c=(d.^2/4-(d.^2/4 + c));
    
    
%%%%    c=(d.^2/4-(d.^2/4 + ((3 * c - (b.^2))/3).^3/27));
    c=(b.^2)/3 - c;
    c=c.^3;
    c=c/27;
    c=max(c,0);
    c=realsqrt(c);
    
    
    j=c.^(1/3);
    c=c+(c==0);
    d=-d/2./c;
    d=min(d, 1);
    d=max(d, -1);
    
    d=real(acos(d)/3);    
%    d=real(acos(-(d/2./c))/3);
    c=j.*cos(d);
    d=j.*sqrt(3).*sin(d);
    b=-b/3;
    
    
    j = single(-c-d+b);
    d = single(-c+d+b);

    b = single(2*c+b);

end


% Old version
%     ep=1e-20;
%     b=double(a11)+ep;
%     d=double(a22)+ep;
%     j=double(a33)+ep;
% 
%     c=-double(double(a12).^2 + double(a13).^2 + double(a23).^2 - b.*d - d.*j - j.*b);
%     d=-(b.*d.*j - double(a23).^2.*b - double(a12).^2.*j - double(a13).^2.*d + 2*double(a13).*double(a12).*double(a23));
% 
%     b=-double(a11) - double(a22) - double(a33) - ep - ep -ep;
% 
%     
%     d = ((2*b.^3) - (9*b.*c) + (27*d))/27;
%     %clear d;
%     %x = (((3*c) - (b.^2))/3);
%     
%     %c = (d^2/4 + (((3*c) - (b.^2))/3).^3/27);
%     
%     %clear x;
%     c=(d.^2/4-(d.^2/4 + (((3*c) - (b.^2))/3).^3/27));
%     c(c<0)=0;
%     c=realsqrt(c);
%     %clear c;    
%     
%     
%     j=c.^(1/3);
%     d=real(acos(-(d/2./c))/3);
%     c=j.*cos(d);
%     d=j.*sqrt(3).*sin(d);
%     b=-b/3;
%     
%     
%     j = single(-c-d+b);
%     d = single(-c+d+b);
% 
%     b = single(2*c+b);