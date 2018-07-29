function [I, x] = filtered_noise(roi_size, n, stack_size, E, px, nps_in, f_in)

% [I, x] = filtered_noise(px, roi_size, n, stack_size, nps_in)
% [I, x] = filtered_noise(px, roi_size, n, stack_size, nps_in, f_in)
%
% Returns random noise that has been obtained by white-noise filtering in
% the Fourier domain using a supplied noise-power spectrum (NPS). Size and
% dimension of the symmetric arrays can be specified as well as the number
% of realizations.
%
% roi_size and n specify, respectively, the side length and dimension of
% the returned symmetric array (I). stack_size is the number of
% realizations, which are concatenated along the last dimension of I. E is
% the expectation value of I, and px is the pixel size of the array. A
% vector x is returned that gives the spatial coordinates of I.
%
% nps_in can be a function handle that returns the n-dimensional
% Cartesian NPS for Cartesian input frequencies as returned by meshgrid,
% NPS(f1, f2,..., fn). Input frequencies range from -Nyq to +Nyq, where Nyq
% is the Nyquist frequency as determined by the pixel size. See
% power_law_noise.m and cross_talk_noise.m for examples. nps_in may also be
% an array, for instance obtained by a measurement, in which case frequency
% vector f_in needs to be supplied.
%
% Erik Fredenberg, Royal Institute of Technology (KTH) (2010).
% Please reference this package if you find it useful.
% Feedback is welcome: fberg@kth.se.

% input checking
if nargin<5, error('Power spectrum needs to be supplied.'); end
if isempty(stack_size), stack_size = 1; end
if isempty(n), n = 2; end
if isempty(roi_size), roi_size = 256; end
if isempty(px), px = 1; end

% frequency vector
f = linspace(-0.5, 0.5, roi_size)/px;
f = repmat(f', [1 ones(1, n-1)*roi_size]);
f_c = cell(1,n); for p = 1:n, f_c{p} = shiftdim(f, p-1); end

if isnumeric(nps_in) % NPS is array
    if nargin<6, error('A frequency vector must be supplied.'); end
    
    if f_in(1)>=0 % assume symmetry around 0
        f_in = [-f_in(end:-1:1) f_in];
        nps_in = [-nps_in(end:-1:1) nps_in];
    end
    
    if f_in(1) > f(1) || f_in(end) < f(end), error('Frequencies out of range.'); end
    
    if isvector(f_in)
        f_in = repmat(f_in', [1 ones(1, n-1)*roi_size]);
    end
    f_c_in = cell(1, n); for p = 1:n, f_c_in{p} = shiftdim(f_in, p-1); end
    
    % interpolating to desired frequencies
    for p = 1:n, NPS = interpn(f_c_in{:}, shiftdim(nps_in,p-1), f_c{:}); end
    NPS = shiftdim(NPS, -n+1);
    
elseif isa(nps_in, 'function_handle') % NPS is a function handle
    NPS = nps_in(f_c{:});
else
    error('Power spectrum needs to be an array or a function handle.');
end

% absolute value of Fourier transform
abs_F = sqrt(NPS * (roi_size/px)^n);

I=[];
for k = 1:stack_size
    % Fourier transform with random phase shifts
    v = rand(ones(1, n) * roi_size);
    F = abs_F.*(cos(2*pi*v) + 1i*sin(2*pi*v));
    
    % remove any DC values
    F(f(:)==0)=0;
    
    % inverse Fourier transform yields image
    I = cat(n+1, I, real(ifftn(fftshift(F)))+imag(ifftn(fftshift(F))));
end

% add DC value
I = I + E;

% position vector
x = linspace(-0.5, 0.5, roi_size)*px*roi_size;