function varargout = goertzel(x,fs,ft,N,varargin)
% GOERTZEL   Goertzel Algorithm.
%
%  [RE,IM] = GOERTZEL(X,FS,FT,N) calculates the goertzel algorithm
%  for X, considering a sampling frequency FS, the target
%  frequency FT and using a block of size N.
%
%  [MAG,PHASE] = GOERTZEL(...,'mag') returns the magnitude and
%  phase information of the transform.
%
%  [...] = GOERTZEL(...,'overlap',OL) will perform the calculation
%  on blocks that overlap. The amount of overlapping is defined by
%  OL, and can be set from 0 to 1.
%

[mag,OL] = parse_inputs(varargin{:});

if size(x,1)~=1 & size(x,2)~=1
    error('X must be a vector.')
end

flag_rot = 0;
if size(x,2) == 1
    flag_rot = 1;
    x = x';
end

n = length(x);
k = 1*(0.5+N*ft/fs);
w = 2*pi*k/N;
c = cos(w);
s = sin(w);
coef = 2*c;
ADV = max(round((1-OL)*N),1);

re = zeros(1,floor(n/ADV));
im = re;

for j = 1 : floor((n-N)/ADV)
    q1 = 0;
    q2 = 0;
    for i = 1 : N
        q0 = coef*q1 - q2 + x(i+(j-1)*ADV);
        q2 = q1;
        q1 = q0;
    end
    re(j) = q1 - q2*c;
    im(j) = q2*s;
end

if mag == 0
    varargout{1} = re;
    varargout{2} = im;
else
    ma = sqrt(re.^2 + im.^2);
    ph = angle(re+i*im);
    
    varargout{1} = ma;
    varargout{2} = ph;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mag,OL] = parse_inputs(varargin)

mag = 0;
OL = 0;
flag_par = 0;

for i = 1 : nargin
    if flag_par == 1
        flag_par = 0;
        continue
    elseif strcmp(varargin{i},'mag')
        mag = 1;
    elseif strcmp(varargin{i},'overlap')
        if nargin == i 
            error('OL not defined.')
        end
        flag_par = 1;
        OL = varargin{i+1};
    else
        error('Unknown parameter.')
    end
end

if OL>1 | OL<0
    error('OL should be set inside the interval [0,1].')
end

