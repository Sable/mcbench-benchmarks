function y = dct2(y,m,n)

%DCT2 2-D discrete cosine transform.
%   B = DCT2(A) returns the discrete cosine transform of A. The matrix B is
%   the same size as A and contains the discrete cosine transform
%   coefficients.
%
%   B = DCT2(A,[M N]) or B = DCT2(A,M,N) pads the matrix A with zeros to
%   size M-by-N before transforming. If M or N is smaller than the
%   corresponding dimension of A, DCT2 truncates A. 
%
%   This transform can be inverted using IDCT2.
%
%   IMPORTANT NOTE
%   --------------
%   This function replaces the original Matlab function. The Narasimha's
%   algorithm uses a N-point DFT and is thus about two times faster
%   compared to the conventional method which uses a 2N-point DFT.
%
%   Class Support
%   -------------
%   A can be numeric or logical. The returned matrix B is of class double.
%
%   Reference
%   ---------
%   Narasimha M. et al, On the computation of the discrete cosine
%   transform, IEEE Trans Comm, 26, 6, 1978, pp 934-936.
%
%   Example
%   -------
%       RGB = imread('autumn.tif');
%       I = rgb2gray(RGB);
%       J = dct2(I);
%       imshow(log(abs(J)),[]), colormap(jet), colorbar
%
%   The commands below set values less than magnitude 10 in the DCT matrix
%   to zero, then reconstruct the image using the inverse DCT function
%   IDCT2.
%
%       J(abs(J)<10) = 0;
%       K = idct2(J);
%       figure, imshow(I)
%       figure, imshow(K,[0 255])
%
%   See also DCTN, IDCT2, FFT2, DCTMTX.
%
%   -- Damien Garcia -- 2011/01, revised 2011/11
%   website: <a
%   href="matlab:web('http://www.biomecardio.com')">www.BiomeCardio.com</a>

error(nargchk(1,3,nargin))
assert(ndims(y)<3,'A must be of dimension <3. Use DCTN instead.')

y = double(y);
[l c] = size(y);

% --- Pad or truncate the matrix ---
if nargin>1
    if nargin==2, n = m(2); m = m(1); end
    if m>l, y = [y;zeros(m-l,c)]; else y = y(1:m,:); end
    if n>c, y = [y zeros(m,n-c)]; else y = y(:,1:n); end
else
    [m n] = size(y);
end

% --- Compute weights ---
w = cell(1,2);
w{1} = exp(1i*(0:m-1)'*pi/2/m)*sqrt(2)*sqrt(m);
w{1}(1) = w{1}(1)/sqrt(2);
w{2} = exp(1i*(0:n-1)*pi/2/n)*sqrt(2)*sqrt(n);
w{2}(1) = w{2}(1)/sqrt(2);


% --- DCT algorithm ---
if ~isreal(y)
    y = complex(dct2(real(y)),dct2(imag(y)));
else
    y = y([1:2:m 2*floor(m/2):-2:2],[1:2:n 2*floor(n/2):-2:2]);
    % DCT along the 1st dimension
    y = ifft(y,[],1);
    y = bsxfun(@times,y,w{1});
    y = real(y);
    % DCT along the 2nd dimension
    y = ifft(y,[],2);
    y = bsxfun(@times,y,w{2});
    y = real(y);
end
