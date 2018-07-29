function [Sxx_m,freq,time]=p_gram(varargin)
%
% Type: [Sxx_m,freq,time]=p_gram(x1,nfft,fs,nwin,novlap,dflag);
% Type: [Sxx_m,freq,time]=p_gram(x1,nfft,fs,nwin,novlap);
% Type: [Sxx_m,freq,time]=p_gram(x1,nfft,fs,nwin);
% Type: [Sxx_m,freq,time]=p_gram(x1,nfft,fs);
%
% Compute Power Spectral Density (PSD) Spectrogram by Short Time Fourier Transform (SFFT) method
%
% Inputs:
%
%         x1        := (real numbers) data vector (nt x 1)
%         nfft      := number of samples to use in FFT for each data window
%         fs        := sampling frequency [Hz]
%         nwin      := number of samples to use in each hanning window of data
%                      if not specified or empty, nwin = nfft
%                      if nfft < nwin, each hanning window of data is zero padded up to nfft samples
%         novlap    := number of samples to overlap each hanning window of data
%                      if not specified or empty novlap = 0;
%         dflag     := detrand flag string
%                    = 'none' no detrend (default)
%                    = 'mean' constand detrend
%                    = 'linear' linear detrend
%
% Outputs:
%
%         Sxx_m       := Matrix whose Columns are PSD's of input data x1 
%                      [(nfft + 1)/2] x floor((nt-novlap)/(nwin-novlap)) if length(nfft) is odd
%                      [nfft/2 + 1] x floor((nt-novlap)/(nwin-novlap)) if length(nfft) is even
%         freq      := frequency vector corresponding to Sxx_m
%         time      := time vector corresponding to Sxx_m
%

% Scot McNeill, University of Houston, Fall 2007.
%
msg=nargchk(3,6,nargin);
if ~isempty(msg)
   error(msg)
end
%
x1=varargin{1};
nfft=varargin{2};
fs=varargin{3};
%
if (length(varargin) >= 4 & ~isempty(varargin{4}))
   nwin=varargin{4};
else
   nwin=nfft;
end
%
if (length(varargin) >=5 & ~isempty(varargin{5}))
   novlap=varargin{5};
else
   novlap=0;
end
%
if (length(varargin) ==6 & ~isempty(varargin{6}))
   dflag=varargin{6};
   if ~any([strcmp(dflag,'none'),strcmp(dflag,'mean'),strcmp(dflag,'linear')])
      error('dflag must be one of the following: ''mean'' ''linear'' ''none''')
   end
else
   dflag='none';
end
%
[nr,nc]=size(x1);
if (nr ~= 1 & nc ~= 1)
   error('x1 must be a vector')
end
%
if length(x1) < nwin
   error('window size must not be greater than length of data vectors x1')
end
%
h_win=hann_p(nwin); % periodic hanning window
%
x1=x1(:);
[nt,nch]=size(x1);
blk_sz=nwin-novlap;
n_blk=floor((nt-novlap)/blk_sz); % number of blocks to average
if rem(nfft,2) % nfft odd
    i_half=(1:(nfft+1)/2)';
else
    i_half=(1:(nfft/2+1))';
end
%
x_m=zeros(nwin,n_blk); % initialize matrix of time history columns multiplied by hanning window
time=zeros(n_blk,1); % initialize time output
for k=1:n_blk
    index=blk_sz*(k-1)+1:blk_sz*(k-1)+nwin;
    time(k,1)=(blk_sz*(k-1)+nwin/2)/fs; % time at middle of block
    if strcmp(dflag,'none')
       x_m(:,k)=h_win.*x1(index);
    elseif strcmp(dflag,'linear')
       x_m(:,k)=h_win.*detrend(x1(index),'linear');
    elseif strcmp(dflag,'mean')
       x_m(:,k)=h_win.*detrend(x1(index),'constant');
    end
end
%
freq=[];Sxx_m=[]; % initialize output
Sxx_m=abs(fft(x_m,nfft));
Sxx_m=Sxx_m(i_half,:).^2;
%
nrm=2/(fs*sum(h_win.^2)); % normalize
Sxx_m=Sxx_m*nrm;
freq=((i_half)-1).*(fs/nfft);

