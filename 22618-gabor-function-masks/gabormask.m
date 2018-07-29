function [cmask, smask] = gabormask(Size, sigma, period, orient)
%GABORMASK Create Gabor-function masks according to the formulae
%                                     2         2
%       cmask(y+hy, x+hx) = N * exp(-r /(2*sigma )) * cos(x' * omega)
%                                     2         2
%       smask(y+hy, x+hx) = N * exp(-r /(2*sigma )) * sin(x' * omega)
%   where
%        2     2    2
%       r  =  x  + y
%       x' =  x * cos(orient) + y * sin(orient)
%       omega = 2*pi / period
%
%       N is a real normalisation constant such that if the mask is
%       convolved with a sine grating of unity amplitude and the period
%       and orientation of the mask, the output will have unity
%       amplitude.
%
%       hy and hx are the mask centre coordinates, i.e. for a
%       SIZEY-by-SIZEX mask they are (SIZEY-1)/2+1 and (SIZEX-1)/2+1.
%
%   [C,S] = GABORMASK creates a 27x27 arrays containing the masks with
%   sigma=5, period=10*sqrt(2) and orient=0.
%
%   [C,S] = GABORMASK(SIZE) is like the last case except that SIZE is a
%   1-by-2 vector giving the number of rows and columns in C and S. SIZE
%   can also be a scalar in which case the mask is SIZE-by-SIZE.
%
%   [C,S] = GABORMASK(SIZE, SIGMA) creates masks with the given size and
%   sigma. If SIZE is specified as [] then 2*round(2.575*SIGMA)+1 is
%   used for both rows and columns. The period is SIGMA*2*sqrt(2) and
%   orient=0.
%
%   [C,S] = GABORMASK(SIZE, SIGMA, PERIOD) is like the last case except
%   that both sigma and period are specified. Either may be given as []
%   in which case the ratio period/sigma is set to 2*sqrt(2).
%
%   [C,S] = GABORMASK(SIZE, SIGMA, PERIOD, ORIENT) is as the previous
%   cases except that the orientation of the masks is specified.

% David Young, Department of Informatics, University of Sussex, January 2002
% revised January 2009

% Sort out arguments and their defaults
if nargin < 4; orient = 0; end;
if nargin < 3; period = []; end;
if nargin < 2; sigma = []; end;
if nargin < 1; Size = []; end;

if isempty(period) && isempty(sigma); sigma = 5; end;
if isempty(period); period = sigma*2*sqrt(2); end;
if isempty(sigma); sigma = period/(2*sqrt(2)); end;
if isempty(Size); Size = 2*round(2.575*sigma) + 1; end; % small error

if length(Size) == 1
    sx = Size-1; sy = sx;
elseif all(size(Size) == [1 2])
    sy = Size(1)-1; sx = Size(2)-1;
else
    error('Size must be scalar or 1-by-2 vector');
end;

% Basic grid
hy = sy/2; hx = sx/2;
[x, y] = meshgrid(-hx:sx-hx, -hy:sy-hy);

% Parameters
omega = 2*pi/period;
cs = omega * cos(orient);
sn = omega * sin(orient);
k = -1/(2*sigma*sigma);

% Main computations
g = exp(k * (x.*x + y.*y));     % Gaussian mask
xp = x * cs + y * sn;           % Rotated x coords, phase
cx = cos(xp);                   % cos grating
cmask = g .* cx;                % modulated cos grating
sx = sin(xp);                   % sin grating
smask = g .* sx;                % modulated sin grating

% Normalise so that convolution of mask with a harmonic curve of the
% matching frequency gives unity peaks
cnorm = sum(sum(cmask.*cx));
cmask = cmask/cnorm;
snorm = sum(sum(smask.*sx));
smask = smask/snorm;
