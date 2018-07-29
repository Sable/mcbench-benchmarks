%MIRT_IDCTN N-D (multidimensional) inverse discrete cosine transform.
%   A = MIRT_IDCTN(B) returns the inverse discrete cosine transform of B.
%   The array A is the same size as B and contains the
%   original array if B was obtained using B=MIRT_DCTN(A).
%
%   This function works much faster than Matlab standard
%   idct (for 1D case) or idct2 (for 2D case), and also allows the N-D input.
%   The function takes advantage of 1) FFT 2) fast permutation through indicies
%   3) persitent precomputation (coefficients and indicies are precomputed during 
%   the first run).  
%
%   This transform is the inverse of MIRT_DCTN.
%   Author: Andriy Myronenko, see www.bme.ogi.edu/~myron
%   revised on May 06, 2010
%
%   See also MIRT_DCTN.

function a = mirt_idctn(a)


persistent siz ww ind isreala;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Check input 
if (nargin == 0) || isempty(a) ,
    error('Insufficient input');
end


isreala=isreal(a);
ndim=ndims(a);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Check for the row vector
transpose=0;
if (ndim==2) && (size(a,1)==1)
    transpose=1; a=a';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Check if the variable size has changed and we need to
%%% precompute weights and indicies

precompute=0;
if  ~exist('siz','var'),
    precompute=1;
elseif abs(numel(siz)-ndims(a))>0
    precompute=1;
elseif sum(abs(siz-size(a)),2)>0,
    precompute=1;
elseif isreala~=isreal(a),
    precompute=1;
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Precompute weights and indicies
if precompute,
    siz=size(a);
    ndim=ndims(a);
    
    for i=1:ndim,
        n=siz(i); clear tmp;
        
        ww{i} = 2*exp((-1i*pi/(2*n))*(0:n-1)')/sqrt(2*n);
        ww{i}(1) = ww{i}(1)/sqrt(2);
        
        tmp(1:2:n)=(1:ceil(n/2)); 
        tmp(2:2:n)=(n:-1:ceil(n/2)+1);
        ind{i}=bsxfun(@plus, tmp', 0:n:n*(prod(siz)/n-1));
        if (siz(i)==1), break; end;
    end
    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Actual multidimensional DCT. Handle 1D and 2D cases
%%% separately, because .' is much faster than shiftdim.

% check for 1D or 2D cases
if ndim==2
    if (min(siz)==1),
        a=idct(a,ww{1},ind{1});if transpose, a=a'; end;  % 1D case
    else a = idct(idct(a,ww{1},ind{1}).',ww{2},ind{2}).'; % 2D case
    end       
else
    % ND case (3D and higher)
    for i=1:ndim
        a=reshape(idct(reshape(a,siz(1),[]),ww{i},ind{i}), siz); % run dct along vectors (1st dimension)
        siz=[siz(2:end) siz(1)];                   % circular shift of size array by 1
        a=shiftdim(a,1);                           % circular shift dimensions by 1
    end
end


function a = idct(a,ww,ind)
%DCT  Inverse Discrete cosine transform 1D (operates along first dimension)

isreala=isreal(a);k=1;
if ~isreala, ia = imag(a); a = real(a); k=2; end;

% k=1 if a is real and 2 if a is complex
for i=1:k
    
    a = bsxfun(@times,  ww, a);  % multiply weights
    a = fft(a);                 % fft
    a=real(a(ind));              % reorder using idicies
    
    % check if the data is not real
    if ~isreala,
        if i==1, ra = a; a = ia; clear ia;  % proceed to imaginary part
        else a = complex(ra,a); end;        % finalize the output
    end
    
end


