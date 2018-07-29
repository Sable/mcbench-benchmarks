function [y,err]=golaycodec(x,enc,ext)
% GOLAYCODEC - encode/decode a binary array using the Golay code with error correction.
%
% golaycodec encodes or decodes a binary array using the Golay code.
% Words of length 12 are encoded as codewords of length 23 (or 24 for the
% extended Golay code).  The Golay code is tolerant of up to 3 errors,
% i.e. for any word of length 23 there is a unique codeword that differs
% in at most 3 positions.
%
% The Golay code can be constructed as a polynomial code using one of the 
% degree 11 factors of z^23+1 (mod 2).  Here we use
%   g = 1 + z^2 + z^4 + z^5 + z^6 + z^10 + z^11
% For more details see Wikipedia etc.
%
% Usage:
%   y = golaycodec(x)
%   [y,err] = golaycodec(x)
%   ... = golaycodec(x,enc)
%   ... = golaycodec(x,enc,ext)
%
% Inputs:
%   x can be an Mx12, Mx23 or Mx24 binary (logical) array or an Mx1 integer array.
%     If x is Mx1, the binary representation of each integer is used.
%   enc is a logical; if true x is to be encoded, otherwise x is to be decoded.
%     If not specified, enc is inferred from the size of x or set to true.
%   ext is a logical; if true use the extended Golay code (length 24),
%     otherwise use the non-extended Golay code (length 23).
%     If not specified, enc is inferred from the size of x or set to false.
%     NOTE: the algorithm has so far only been implemented for ext=false
%
% Outputs:
%   y is an array consisting of the coded or decoded rows of x
%     If x is Mx12 and ext=false then y is Mx23
%     If x is Mx12 and ext=true then y is Mx24
%     If x is Mx23 or Mx24 then y is Mx12
%     If x is Mx1 then y is Mx1
%   err (only available if decoding is done, e.g enc=false) is an array
%     with the errors that differ each word in x from its closest codeword)
%
% Example: encode some messages, add transmission errors and decode
%   n=10;
%   x=zeros(n,12);for i=1:n,x(i,ceil(12*rand(1,8)))=1;end; % random message
%   y=golaycodec(x);
%   err=zeros(n,23);for i=1:n,err(i,ceil(23*rand(1,3)))=1;end; % 3 random errors per message
%   y1=xor(y,err); % add transmission error
%   [x1,err1]=golaycodec(y1); % decode: should have x1==x and err1==err
%

% Author: Ben Petschel 18/3/2009
%
% Change history:
%  18/3/2009 - created
%  30/4/2009 - updated to implement extended Golay codes
%

encdef = true; % default value of "enc" if not specified for integer input
extdef = false; % default value of "ext" if not specified

% input checking: x
nx=size(x,2);
if any(~isfinite(x(:))) || any(~isreal(x(:)))
  error('golaycodec: input array must be finite real values');
end;
if nx==1
  if any(x~=round(x))
    error('golaycodec: column input must be integers');
  end;
  if any(x<0)
    % check later that integers are small enough
    error('golaycodec: column input must be non-negative integers');
  end;
  intout = true;

elseif nx>1
  if any((x(:)~=0)&(x(:)~=1))
    error('golaycodec: entries of row or matrix input must be 0 or 1');
  end;
  if ~any(nx==[12,23,24]),
    error('golaycodec: number of columns of input must be 1, 12, 23 or 24');
  end;
  intout = false; % binary output
  
else
  error('golaycodec: empty input');
end; % if nx==1 elseif ... else ... end;

% input checking: enc, ext must be booleans
if nargin>=2,
  if isnumeric(enc),
    enc = enc>0;
  end;
  if ~islogical(enc) || ~isscalar(enc)
    error('golaycodec: enc must be 1x1 logical value');
  end;
end;
if nargin>=3,
  if isnumeric(ext),
    ext = ext>0;
  end;
  if ~islogical(ext) || ~isscalar(ext)
    error('golaycodec: enc must be 1x1 logical value');
  end;
end;

% input checking: consistency of nx with enc and ext if specified
switch nx
  case 1
    if nargin == 1,
      enc = encdef; % set to default value (usually true)
    end;
    if nargin <= 2,
      ext = extdef; % set to default value (usually false)
    end;
  case 12
    if nargin == 1,
      enc = true; % encode 12-digit word
    elseif ~enc,
      error('golaycodec: cannot decode 12-digit words');
    end;
    if nargin <=2,
      ext = extdef; % set to default value (usually false)
    end;
  case 23
    if nargin == 1,
      enc = false; % decode 23-digit word
    elseif enc,
      error('golaycodec: cannot encode 23-digit words');
    end;
    if nargin <=2,
      ext = false; % not from the extended code
    elseif ext,
      error('golaycodec: 23 digit words are not in the extended code');
    end;
  case 24
    if nargin == 1,
      enc = false; % decode 24-digit word
    elseif enc,
      error('golaycodec: cannot encode 24-digit words');
    end;
    if nargin <=2,
      ext = true; % use the extended code
    elseif ~ext,
      error('golaycodec: 24-digit words are not in the non-extended code');
    end;
  otherwise
    error('golaycodec: input must have 1, 12, 23 or 24 columns');
end; % switch nx

% for integer inputs, check that the integers are not too large
if intout
  if enc
    if any(x(:)>=2^12),
      error('golaycodec: integers for coding must be less than 2^12');
    end;
  elseif any(x(:)>=2^23),
    error('golaycodec: integers for decoding must be less than 2^23');
  end;
end;

% output checking: nargout>1 only for decoding
if (nargout>2) || ((nargout>1) && enc)
  error('golaycodec: can only specify two outputs when decoding');
end;


if nx==1,
  % convert integers to the appropriate length
  if enc
    nx=12;
  elseif ext
    % decode extended code
    nx=24;
  else
    % decode non-extended code
    nx=23;
  end;
  x = dec2logi(x,nx);
end; % if nx==1


% retain generating polynomial, parity check and error parity table
persistent g h errtab

if isempty(g)
  % generating polynomial: g = 1+x^2+x^4+x^5+x^6+x^10+x^11
  g=zeros(1,12);g([0,2,4,5,6,10,11]+1)=1;
end;

if isempty(h)
  % parity check polynomial is the other factor of x^23-1 (mod 2)
  % h = (1+x)*(1+x+x^5+x^6+x^7+x^9+x^11)
  h=mod(deconv([1,zeros(1,22),1],g),2);
end;

if isempty(errtab),
  % set up the error table for decoding: determine all errors of up to 3 bits
  % the error will be determined by simple table lookup of the parity check
  % the table is a sparse array indexed by the integer representation of the parity bits
  errtab = geterrtab(h,3,23);
end;

% now encode or decode the array
if enc
  y = circprod(x,g,23);
  if ext
    % if using extended code, append a checksum bit (row sums mod 2)
    y = [y,mod(sum(y,2),2)]; 
  end;
else
  if ext
    % drop the checksum bit if using extended code
    c = x(:,24);
    x = x(:,1:23);
  end;
  % check parity
  p = circprod(x,h,23);
  % look up parity in error table
  err = dec2logi(errtab(logi2dec(p)+1),23);
  y = zeros(size(x,1),12);
  for i=1:size(x,1),
    y(i,:) = mod(deconv(x(i,:)-err(i,:),g),2);
  end;
  if ext
    % if using extended code, append the checksum bit error
    err = [err,mod(c-sum(y,2),2)];
  end;
end;

% convert back to integers, if necessary
if intout,
  y = logi2dec(y);
  if nargout == 2,
    err = logi2dec(err);
  end;
end;

end % main function golaycodec




function t=geterrtab(h,k,n)
% produces lookup table of parity checks of all errors with weight <=k on n digits
% y is a sparse matrix: index is 1 + (h*err converted to integer)
% and y(i) is (err) converted to binary
%
% h must be row vector of length <= n
% also 0 <= k <= n.

m=length(h);
if (2^n-1)>intmax,
  error('golaycodec:geterrtab: too many digits to convert to integer');
end;
if m>n,
  error('golaycodec:geterrtab: parity check polynomial is too long');
end;

t = sparse(1,1,0,2^n,1); % initialize with 0*h+1 -> 0

for i=1:k,
  ind = nchoosek(1:n,i); % all possible combinations of i error digits
  nck = size(ind,1);
  errbin = zeros(nck,n); % error in binary format
  errbin(sub2ind([nck,n],repmat((1:nck)',i,1),ind(:)))=1; % in row j place 1's in columns ind(j,:)
  errint = logi2dec(errbin); % error in integer format
  errh = circprod(errbin,h,n); % do parity check using h
  t(logi2dec(errh)+1)=errint;
end;

end % helper function geterrtab(...)

function z=circprod(x,h,n)
% does parity check of rows of x using polynomial h
m=size(x,1);

% do circular convolution by fourier transform (fft acts on columns)
% (could also use conv and wrap the tail elements, but conv isn't vectorized)
z = mod(round(ifft(fft(x',n).*repmat(fft(h',n),1,m))'),2);

end % helper function paritycheck


function y=logi2dec(x)
% converts each row of logical array from binary to a decimal number
n=size(x,2);
y=x*(2.^(n-1:-1:0))';

end % helper function logi2dec

function y=dec2logi(x,n)
% converts vector of integers to array of logicals (binary representation)
y=rem(floor(x(:)*2.^(1-n:0)),2); % see dec2bin.m (base matlab) for details

end % helper function dec2logi
