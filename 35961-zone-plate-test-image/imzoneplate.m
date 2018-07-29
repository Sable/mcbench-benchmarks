function I = imzoneplate(N)
%imzoneplate Zone plate test pattern
%
%   SYNTAX
%
%   I = imzoneplate
%   I = imzoneplate(N)
%
%   DESCRIPTION
%
%   I = imzoneplate creates a 501-by-501 zone plate test image. This is a
%   radially symmetric pattern with low frequencies in the middle and high
%   frequencies near the edge.
%
%   I = imzoneplate(N) creates an N-by-N zone plate test image.
%
%   EXAMPLES
%
%   Create a test image with the default size (501-by-501).
%
%       I = imzoneplate;
%       imshow(I)
%
%   Create a smaller test image and plot its cross-section.
%
%       I = imzoneplate(151);
%       plot(I(76,:))
%
%   REFERENCE
%
%   Practical Handbook on Image Processing for Scientific Applications, by
%   Bernd Jähne, CRC Press, 1997. See equation 10.63:
%
%   g({\bf x}) = g_0 \sin\left(\frac{k_m|{\bf x}|^2}{2r_m}\right) 
%   \left[\frac{1}{2} \tanh\left(\frac{r_m-|{\bf x}|}{w}\right) + 
%   \frac{1}{2}\right]
%
%   In this equation, g takes on values in the range [-1,1]. imzoneplate
%   returns I = (g+1)/2, which takes on values in the range [0,1].
%
%   See also http://blogs.mathworks.com/steve/2011/07/19/jahne-test-pattern-take-3/

%   Copyright 2012 The MathWorks, Inc.
%   Steven L. Eddins

if nargin < 1
    N = 501;
end

if rem(N,2) == 1
    x2 = (N-1)/2;
    x1 = -x2;
else
    x2 = N/2;
    x1 = -x2 + 1;
end

[x,y] = meshgrid(x1:x2);
r = hypot(x,y);
km = 0.7*pi;
rm = x2;
w = rm/10;
term1 = sin( (km * r.^2) / (2 * rm) );
term2 = 0.5*tanh((rm - r)/w) + 0.5;
g = term1 .* term2;

I = (g + 1)/2;
