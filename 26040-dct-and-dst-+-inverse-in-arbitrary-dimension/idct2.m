function y = idct2(y,m,n)

%IDCT2 2-D inverse discrete cosine transform.
%   B = IDCT2(A) returns the two-dimensional inverse discrete cosine
%   transform of A.
%
%   B = IDCT2(A,[M N]) or B = IDCT2(A,M,N) pads A with zeros (or truncates
%   A) to create a matrix of size M-by-N before transforming. 
%
%   For any A, IDCT2(DCT2(A)) equals A to within roundoff error.
%
%   The discrete cosine transform is often used for image compression
%   applications.
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
%       J = dctn(I);
%       imshow(log(abs(J)),[]), colormap(jet), colorbar
%
%   The commands below set values less than magnitude 10 in the DCT matrix
%   to zero, then reconstruct the image using the inverse DCT.
%
%       J(abs(J)<10) = 0;
%       K = idctn(J);
%       figure, imshow(I)
%       figure, imshow(K,[0 255])
%
%   See also IDCTN, DCT2, IFFT2, DCTMTX.
%
%   -- Damien Garcia -- 2011/01
%   website: <a
%   href="matlab:web('http://www.biomecardio.com')">www.BiomeCardio.com</a>

error(nargchk(1,3,nargin))
assert(ndims(y)<3,'A must be of dimension <3. Use IDCTN instead.')

y = double(y);
[l c] = size(y);
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

% --- IDCT algorithm ---
if ~isreal(y)
    y = complex(idct2(real(y)),idct2(imag(y)));
else
    % IDCT along the 1st dimension
    y = bsxfun(@times,y,w{1});
    y = ifft(y,[],1);
    y = real(y);
    % IDCT along the 2nd dimension
    y = bsxfun(@times,y,w{2});
    y = ifft(y,[],2);
    y = real(y);
    % reordering   
    I = (1:m)*0.5+0.5;
    I(2:2:end) = m-I(1:2:end-1)+1;
    J = (1:n)*0.5+0.5;
    J(2:2:end) = n-J(1:2:end-1)+1;
    y = y(I,J);
end
        




