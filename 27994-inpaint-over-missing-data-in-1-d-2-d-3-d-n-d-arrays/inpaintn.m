function y = inpaintn(x,n,y0)

% INPAINTN Inpaint over missing data in N-D array
%   Y = INPAINTN(X) replaces the missing data in X by extra/interpolating
%   the non-missing elements. The non finite values (NaN or Inf) in X are
%   considered as missing data. X can be any N-D array.
%
%   INPAINTN (no input/output argument) runs the following 3-D example.
%
%   Important note:
%   --------------
%   INPAINTN uses an iterative process that converges toward the solution.
%   Y = INPAINTN(X,N) uses N iterations. By default, N = 100. If you
%   estimate that INPAINTN did not totally converge, increase N:
%   Y = INPAINTN(X,1000);
%
%   Y = INPAINTN(X,N,Y0) uses Y0 as initial guess. This could be useful if
%   you want to run the process a second time or if you have a GOOD guess
%   of the final result. By default, INPAINTN makes a nearest neighbor
%   interpolation (by using BWDIST) to obtain a rough guess.
%
%   References
%   ---------- 
%   1) Garcia D, Robust smoothing of gridded data in one and higher dimensions
%   with missing values. Computational Statistics & Data Analysis, 2010. 
%   <a
%   href="matlab:web('http://www.biomecardio.com/pageshtm/publi/csda10.pdf')">PDF download</a>
%   2) Wang G, Garcia D et al. A three-dimensional gap filling method for
%   large geophysical datasets: Application to global satellite soil
%   moisture observations. Environ Modell Softw, 2012.
%   <a
%   href="matlab:web('http://www.biomecardio.com/pageshtm/publi/envirmodellsoftw12.pdf')">PDF download</a>
%
%   Examples
%   --------
%
%     %% ---- RGB image ---- %%
%     onion = imread('onion.png');
%     I = randperm(numel(onion));
%     onionNaN = double(onion); onionNaN(I(1:round(numel(I)*0.5))) = NaN;
%     subplot(211), imshow(uint8(onionNaN)), title('Corrupted image - 50%')
%     for k=1:3, onion(:,:,k) = inpaintn(onionNaN(:,:,k)); end
%     subplot(212), imshow(uint8(onion)), title('Inpainted image')
%
%     %% ---- 2-D data ---- %%
%     n = 256;
%     y0 = peaks(n);
%     y = y0;
%     I = randperm(n^2);
%     y(I(1:n^2*0.5)) = NaN; % lose 1/2 of data
%     y(40:90,140:190) = NaN; % create a hole
%     z = inpaintn(y,200); % inpaint data
%     subplot(2,2,1:2), imagesc(y), axis equal off
%     title('Corrupt data')
%     subplot(223), imagesc(z), axis equal off
%     title('Recovered data ...')
%     subplot(224), imagesc(y0), axis equal off
%     title('... compared with original data')
%
%     %% ---- 3-D data ---- %%
%     load wind
%     xmin = min(x(:)); xmax = max(x(:));
%     zmin = min(z(:)); ymax = max(y(:));
%     %-- wind velocity
%     vel0 = interp3(sqrt(u.^2+v.^2+w.^2),1,'cubic');
%     x = interp3(x,1); y = interp3(y,1); z = interp3(z,1);
%     %-- remove randomly 90% of the data
%     I = randperm(numel(vel0));
%     velNaN = vel0;
%     velNaN(I(1:round(numel(I)*.9))) = NaN;
%     %-- inpaint using INPAINTN
%     vel = inpaintn(velNaN);
%     %-- display the results
%     subplot(221), imagesc(velNaN(:,:,15)), axis equal off
%     title('Corrupt plane, z = 15')
%     subplot(222), imagesc(vel(:,:,15)), axis equal off
%     title('Reconstructed plane, z = 15')    
%     subplot(223)
%     hsurfaces = slice(x,y,z,vel0,[xmin,100,xmax],ymax,zmin);
%     set(hsurfaces,'FaceColor','interp','EdgeColor','none')
%     hcont = contourslice(x,y,z,vel0,[xmin,100,xmax],ymax,zmin);
%     set(hcont,'EdgeColor',[.7,.7,.7],'LineWidth',.5)
%     view(3), daspect([2,2,1]), axis tight
%     title('Original data compared with...')
%     subplot(224)
%     hsurfaces = slice(x,y,z,vel,[xmin,100,xmax],ymax,zmin);
%     set(hsurfaces,'FaceColor','interp','EdgeColor','none')
%     hcont = contourslice(x,y,z,vel,[xmin,100,xmax],ymax,zmin);
%     set(hcont,'EdgeColor',[.7,.7,.7],'LineWidth',.5)
%     view(3), daspect([2,2,1]), axis tight
%     title('... reconstructed data')
%
%     %% --- 4-D data --- %%
%     [x1,x2,x3,x4] = ndgrid(-2:0.2:2);
%     z0 = x2.*exp(-x1.^2-x2.^2-x3.^2-x4.^2);
%     I = randperm(numel(z0));
%     % remove 50% of the data
%     zNaN = z0; zNaN(I(1:round(numel(I)*.5))) = NaN;
%     % reconstruct the data using INPAINTN
%     z = inpaintn(zNaN);
%     % display the results (for x4 = 0)
%     subplot(211)
%     zNaN(isnan(zNaN)) = 0.5;
%     slice(x2(:,:,:,1),x1(:,:,:,1),x3(:,:,:,1),zNaN(:,:,:,11),...
%        [-1.2 0.8 2],2,[-2 0.2])
%     title('Corrupt data, x4 = 0')
%     subplot(212)
%     slice(x2(:,:,:,1),x1(:,:,:,1),x3(:,:,:,1),z(:,:,:,11),...
%        [-1.2 0.8 2],2,[-2 0.2])
%     title('Reconstructed data')
%
%   See also SMOOTHN, GRIDDATAN
%
%   -- Damien Garcia -- 2010/06, revised 2013/05
%   website: <a
%   href="matlab:web('http://www.biomecardio.com')">www.BiomeCardio.com</a>

if nargin==0&&nargout==0, RunTheExample, return, end

x = double(x);
if nargin==1, n = 100; end

sizx = size(x);
d = ndims(x);
Lambda = zeros(sizx);
for i = 1:d
    siz0 = ones(1,d);
    siz0(i) = sizx(i);
    Lambda = bsxfun(@plus,Lambda,...
        cos(pi*(reshape(1:sizx(i),siz0)-1)/sizx(i)));
end
Lambda = 2*(d-Lambda);

% Initial condition
W = isfinite(x);
if nargin==3
    y = y0;
    s0 = 3; % note: s = 10^s0
else
    if any(~W(:))
        [y,s0] = InitialGuess(x,isfinite(x));
    else
        y = x;
        return
    end
end
x(~W) = 0;

if isempty(n) || n<=0, n = 100; end

% Smoothness parameters: from high to negligible values
s = logspace(s0,-6,n); 

RF = 2; % relaxation factor

m = 2;
Lambda = Lambda.^m;

% h = waitbar(0,'Inpainting...');
for i = 1:n
        Gamma = 1./(1+s(i)*Lambda);
        y = RF*idctn(Gamma.*dctn(W.*(x-y)+y)) + (1-RF)*y;
        % waitbar(i/n,h)
end
% close(h)

y(W) = x(W);

end

%% Initial Guess
function [z,s0] = InitialGuess(y,I)

if license('test','image_toolbox')
    %-- nearest neighbor interpolation
    [~,L] = bwdist(I);
    z = y;
    z(~I) = y(L(~I));
    s0 = 3; % note: s = 10^s0
else
    warning('MATLAB:inpaintn:InitialGuess',...
        ['BWDIST (Image Processing Toolbox) does not exist. ',...
        'The initial guess may not be optimal; additional',...
        ' iterations can thus be required to ensure complete',...
        ' convergence. Increase N value if necessary.'])
    z = y;
    z(~I) = mean(y(I));
    s0 = 6; % note: s = 10^s0
end

end

%% Example (3-D)
function RunTheExample
      load wind
      xmin = min(x(:)); xmax = max(x(:));
      zmin = min(z(:)); ymax = max(y(:));
      %-- wind velocity
      vel0 = interp3(sqrt(u.^2+v.^2+w.^2),1,'cubic');
      x = interp3(x,1); y = interp3(y,1); z = interp3(z,1);
      %-- remove randomly 90% of the data
      I = randperm(numel(vel0));
      velNaN = vel0;
      velNaN(I(1:round(numel(I)*.9))) = NaN;
      %-- inpaint using INPAINTN
      vel = inpaintn(velNaN);
      %-- display the results
      subplot(221), imagesc(velNaN(:,:,15)), axis equal off
      title('Corrupt plane, z = 15')
      subplot(222), imagesc(vel(:,:,15)), axis equal off
      title('Reconstructed plane, z = 15')    
      subplot(223)
      hsurfaces = slice(x,y,z,vel0,[xmin,100,xmax],ymax,zmin);
      set(hsurfaces,'FaceColor','interp','EdgeColor','none')
      hcont = contourslice(x,y,z,vel0,[xmin,100,xmax],ymax,zmin);
      set(hcont,'EdgeColor',[.7,.7,.7],'LineWidth',.5)
      view(3), daspect([2,2,1]), axis tight
      title('Actual data compared with...')
      subplot(224)
      hsurfaces = slice(x,y,z,vel,[xmin,100,xmax],ymax,zmin);
      set(hsurfaces,'FaceColor','interp','EdgeColor','none')
      hcont = contourslice(x,y,z,vel,[xmin,100,xmax],ymax,zmin);
      set(hcont,'EdgeColor',[.7,.7,.7],'LineWidth',.5)
      view(3), daspect([2,2,1]), axis tight
      title('... reconstructed data')
end

%% DCTN
function y = dctn(y)

%DCTN N-D discrete cosine transform.
%   Y = DCTN(X) returns the discrete cosine transform of X. The array Y is
%   the same size as X and contains the discrete cosine transform
%   coefficients. This transform can be inverted using IDCTN.
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
%   -- Damien Garcia -- 2008/06, revised 2011/11
%   -- www.BiomeCardio.com --

y = double(y);
sizy = size(y);
y = squeeze(y);
dimy = ndims(y);

% Some modifications are required if Y is a vector
if isvector(y)
    dimy = 1;
    if size(y,1)==1, y = y.'; end
end

% Weighting vectors
w = cell(1,dimy);
for dim = 1:dimy
    n = (dimy==1)*numel(y) + (dimy>1)*sizy(dim);
    w{dim} = exp(1i*(0:n-1)'*pi/2/n);
end

% --- DCT algorithm ---
if ~isreal(y)
    y = complex(dctn(real(y)),dctn(imag(y)));
else
    for dim = 1:dimy
        siz = size(y);
        n = siz(1);
        y = y([1:2:n 2*floor(n/2):-2:2],:);
        y = reshape(y,n,[]);
        y = y*sqrt(2*n);
        y = ifft(y,[],1);
        y = bsxfun(@times,y,w{dim});
        y = real(y);
        y(1,:) = y(1,:)/sqrt(2);
        y = reshape(y,siz);
        y = shiftdim(y,1);
    end
end
        
y = reshape(y,sizy);

end

%% IDCTN
function y = idctn(y)

%IDCTN N-D inverse discrete cosine transform.
%   X = IDCTN(Y) inverts the N-D DCT transform, returning the original
%   array if Y was obtained using Y = DCTN(X).
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
%   See also DCTN, IDSTN, IDCT, IDCT2, IDCT3.
%
%   -- Damien Garcia -- 2009/04, revised 2011/11
%   -- www.BiomeCardio.com --

y = double(y);
sizy = size(y);
y = squeeze(y);
dimy = ndims(y);

% Some modifications are required if Y is a vector
if isvector(y)
    dimy = 1;
    if size(y,1)==1
        y = y.';
    end
end

% Weighing vectors
w = cell(1,dimy);
for dim = 1:dimy
    n = (dimy==1)*numel(y) + (dimy>1)*sizy(dim);
    w{dim} = exp(1i*(0:n-1)'*pi/2/n);
end

% --- IDCT algorithm ---
if ~isreal(y)
    y = complex(idctn(real(y)),idctn(imag(y)));
else
    for dim = 1:dimy
        siz = size(y);
        n = siz(1);
        y = reshape(y,n,[]);
        y = bsxfun(@times,y,w{dim});
        y(1,:) = y(1,:)/sqrt(2);
        y = ifft(y,[],1);
        y = real(y*sqrt(2*n));
        I = (1:n)*0.5+0.5;
        I(2:2:end) = n-I(1:2:end-1)+1;
        y = y(I,:);
        y = reshape(y,siz);
        y = shiftdim(y,1);            
    end
end
        
y = reshape(y,sizy);

end
