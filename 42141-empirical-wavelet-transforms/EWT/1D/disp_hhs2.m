%DISP_HHS2  display Hilbert-Huang spectrum
%
% DISP_HHS2(im,t,inf,sub,color)
% displays in a new figure the spectrum contained in matrix "im"
% (amplitudes in dB).
%
% inputs:  - im: image matrix (e.g., output of "toimage")
%          - t (optional): time instants (e.g., output of "toimage") 
%          - inf (optional): -dynamic range in dB (wrt max)
%            default: inf = -20
%          - fs: sampling frequency
%          - sub: subset ratio
%          - color: 0 = grayscale ; 1 = color (default)
%
% use:  disp_hhs(im) ; disp_hhs(im,t) ; disp_hhs(im,inf)
%       disp_hhs(im,t,inf) ; disp_hhs(im,inf,fs) ; disp_hhs(im,[],fs)
%       disp_hhs(im,t,[],fs) ; disp_hhs(im,t,inf,fs)
%
%
% See also
%  emd, hhspectrum, toimage
%
% Modification of G. Rilling code
% gabriel.rilling@ens-lyon.fr

function disp_hhs2(varargin)

error(nargchk(1,6,nargin));
fs = 0;
inf = -20;
im = varargin{1};
t = 1:size(im,2);
sub = 1;
color = 1;
switch nargin
  case 1
    %raf
  case 2
    if isscalar(varargin{2})
      inf = varargin{2};
    else
      t = varargin{2};
    end
  case 3
    if isvector(varargin{2})
      t = varargin{2};
      inf = varargin{3};
    else
      inf = varargin{2};
      fs = varargin{3};
    end
  case 4
    t = varargin{2};
    inf = varargin{3};
    fs = varargin{4};
  case 5
    if isscalar(varargin{5})
      t = varargin{2};
      inf = varargin{3};
      fs = varargin{4};
      sub = varargin{5};
    end
  case 6
    if isscalar(varargin{6})
      t = varargin{2};
      inf = varargin{3};
      fs = varargin{4};
      sub = varargin{5};
      color = varargin{6};
    end
end

if isempty(inf)
  inf = -20;
end

if inf > 0
  inf = -inf;
elseif inf == 0
  error('inf must be nonzero')
end

if color~=0
    color = 1;
end

M=max(max(im));

warning off
im = 10*log10(im/M);
warning on

figure
subplot(6,1,[2:6]);   %AJOUT
if fs == 0
  imagesc(t,[0,pi/sub],im(1:floor(end/sub),:),[inf,0]);
  ylabel('frequency (rad/s)')
else
  imagesc(t,[0,0.5*fs],im,[inf,0]);
  ylabel('frequency')
end
if color == 0
    colormap(1.-gray);
end
set(gca,'YDir','normal')
xlabel('time')
