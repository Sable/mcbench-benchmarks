function varargout = vkf(y,fs,f,p,bw,multiorder)
%VKF 2nd Generation Vold-Kalman Order Filtering.
%   x = VKF(y,fs,f) extracts the order with frequency vector f from signal 
%   y with samplerate fs, using a 2-pole filter with a -3dB bandwidth of 
%   1 percent of the sample rate. The output is a single waveform x.
%
%   [...] = VKF(y,fs,f,p) uses a p-order filter (typically between 1 or 4).
%   Every order increases the roll-off by -40dB per decade. By specifying
%   additional lower-order coefficients, zero boundary conditions are 
%   added. For instance: p = [2 0 1] applies 2nd order filtering and
%   forces the envelope amplitude and its first derivative to zero at t_1 
%   and t_N.
%
%   [...] = VKF(y,fs,f,p,bw) uses a bandwidth in Hertz specified by bw. If 
%   bw is a scalar, a constant bandwidth is used; if bw is a vector with 
%   the same length as y, a time-varying instantaneous bandwidth is 
%   realised.
%
%   X = VKF(y,fs,F,...) with [N,K] = size(F), performs simultaneous 
%   extraction of K orders with frequency vectors [f_1,...,f_K] in array 
%   F. In case of crossing orders, this method tries to reveal the correct
%   order amplitudes. The output is an array of K waveforms [x_1,...,x_K].
%
%   X = VKF(y,fs,F,p,bw,0) switches to a single-order algorithm. K orders
%   are still extracted, but the single-order algorithm is computationally
%   less demanding. This is suggested for high sample rates and/or long
%   timeseries.
%
%   [a,c] = VKF(...) returns the complex envelope(s) a and phasor(s) c, 
%   such that the order waveform(s) can be reconstructed by x = real(a.*c).
%
%   [a,c,r] = VKF(...) ouputs an additional selectivity vector r used 
%   to realise the bandwidth given by bw.
%
%   Note: Filter orders > 4 usually result in ill conditioning and should 
%   be avoided. The filter bandwidth determination was implemented for 
%   arbitrary order but was not verified for orders higher than 3.
%
%   Demo:
%   Calling VKF without arguments shows a small demonstration of multi-
%   order filtering with two crossing orders in the presence of white 
%   noise. Note that the demo uses the spectrogram function from the Signal
%   Processing Toolbox.
%
%   Example:
%       fs = 4000;
%       T = 5;
%       dt = 1/fs;
%       t = (0:dt:(T-dt))';
%       N = numel(t);
% 
%       % Instationary component
%       A1 = [linspace(0.5,1,floor(N/2)) linspace(1,0.5,ceil(N/2))]';
%       f1 = 0.2*fs - 0.1*fs*cos(pi*t/T);
%       phi1 = 2*pi*cumsum(f1)*dt;
%       y1 = A1.*cos(phi1);
% 
%       % Stationary component
%       A2 = ones(N,1);
%       f2 = 0.2*fs*ones(N,1);
%       phi2 = 2*pi*cumsum(f2)*dt;
%       y2 = A2.*sin(phi2);
% 
%       % White noise
%       e = 2*rand(size(y1));
% 
%       % Mixed signal
%       y = y1 + y2 + e;
% 
%       % Perform VKF on periodic components
%       p = 2;
%       bw = 1;
%       [a,c] = vkf(y,fs,[f1 f2],p,bw);
%       x = real(a.*c);
% 
%       % Reveal white noise
%       w = y-sum(x,2);
% 
%       % Plot
%       figure('color','white')
%       subplot(2,1,1)
%       spectrogram(y,round(fs/16),[],[],fs)
%       subplot(2,1,2), hold on
%       plot(t,[A1 A2],'--')
%       plot(t,abs(a))
%       xlabel('Time (s)')
%       ylabel('Amplitude')
% 
%       % Playback
%       soundsc(y,fs) % Original signal
%       soundsc(x,fs) % Periodic components (2 channels)
%       soundsc(w,fs) % Remaining white noise
%
%   Written by: Maarten van der Seijs, 2010.
%   Version 1.4, 3 May 2013.
%
%   References: 
%   [1] Vold, H. and Leuridan, J. (1993), High resolution order tracking
%       at extreme slew rates, using Kalman tracking filters. Technical 
%       Report 931288, Society of Automotive Engineers.
%
%   [2] Tuma, J. (2005), Setting the passband width in the Vold-Kalman
%       order tracking filter. Proceedings of the International Congress 
%       on Sound and Vibration (ICSV12), Lisbon, Portugal.


%% Input processing

if (nargin == 0) && (nargout == 0), vkfdemo(), return, end
if nargin < 3, error(generatemsgid('ArgChk'),'Wrong number of input arguments. Use: vkf(y,fs,f).'); end
if nargin < 4, p = 2; end               % Default filter order
if nargin < 5, bw = fs/100; end         % Default bandwidth: 0.01*fs
if nargin < 6, multiorder = true; end   % Default single-order algorithm

if size(y,2) > size(y,1), y = transpose(y); end
if size(bw,2) > size(bw,1), bw = transpose(bw); end

% Signal
n_t = length(y);

% Frequency vector(s)
[n_f, n_ord] = size(f);
if n_f == 1
    f = ones(n_t,1)*f;
elseif n_f ~= n_t
    error(generatemsgid('ArgChk'),'The vectors in f should have 1 or %d elements.',n_t)
end

% Turn frequency vectors into phasor vectors
c = exp(2i*pi*cumsum(f,1)/fs);

% Bandwidth vector
n_bw = numel(bw);
if n_bw == 1
    bw = ones(n_t,1)*bw;
elseif n_bw ~= n_t
    error(generatemsgid('ArgChk'),'Vector bw should have 1 or %d elements.',n_t)
end

% Relative bandwidth in radians
phi = pi/fs.*bw;

% Filter order
p_tmp = p;
p = max(p);
p_lo = setdiff(p_tmp,p);


%% Construct filter matrix and bandwidth vector

% Coefficients of p-order difference equation
P_lu = pascal(p+1,1);
coeffs = P_lu(end,:);

% Linear system of difference equations
A = spdiags(ones(n_t-p,1)*coeffs,0:p,n_t-p,n_t);

% Introduce lower order equations to set boundary conditions to zero
pp = numel(p_lo);
A_pre = sparse(pp,n_t);
A_pre(:,1:p) = P_lu(p_lo+1,1:p);
A = [A_pre; A; A_pre(end:-1:1,end:-1:1)];

% Determination of filter r-value
s = 0:p;
sgn = (-1).^s;

% Allocate p+1 linear system
Q = zeros(p+1,p+1);
b = zeros(p+1,1);

% Sum of coefficients
Q(1,:) = ones(p+1,1);
b(1) = 2^(2*p-1);

% System of p diff. equations
for i = 1:p
    Q(i+1,:) = s.^(2*(i-1)) .* sgn;
end

% Solve for q
q = round(Q\b).' .* sgn;

% Calculate r
num = sqrt(2)-1;
den = zeros(size(bw));
for qi = 1:numel(q)
    den = den + 2*q(qi)*cos((qi-1)*phi);
end
r = sqrt(num./den);

% Check potential conditioning of B-matrix
if any(den <= 0) || any(r > sqrt(1/(2*q(1)*eps)))
    error(generatemsgid('IllConditioned'),'Ill-conditioned B-matrix; selectivity bandwidth is too small.')
end

% Generate single-order B matrix
R = spdiags(r,0,n_t,n_t);
B = (A*R)'*(A*R) + speye(n_t);

% Free memory
clear A A_pre R bw phi num den f

%% Construct multi-order matrices

if multiorder
    % Construct sparse diagonal part
    nn = n_t*n_ord;
    diags = -p:p;
    diags_B = spdiags(B,diags);
    BB_D = spdiags(repmat(diags_B,n_ord,1),diags,nn,nn);

    % Prepare sparse upper-diagonal part
    bl_U = (n_ord^2 - n_ord)/2;
    ii_U = zeros(n_t,bl_U);
    jj_U = zeros(n_t,bl_U);
    cc_U = complex(zeros(n_t,bl_U),0);
    m = 0;
    
    % Upper-diagonal part
    for ki = 1:n_ord
        for kj = (ki+1):n_ord
            m = m + 1;
            ii_U(:,m) = (ki-1)*n_t + (1:n_t);
            jj_U(:,m) = (kj-1)*n_t + (1:n_t);
            cc_U(:,m) = conj(c(:,ki)).*c(:,kj);
        end
    end
    
    % Construct sparse upper-diagonal part
    BB_U = sparse(ii_U,jj_U,cc_U,nn,nn);
    
    % Assemble sparse matrix
    BB = BB_D + BB_U + BB_U';
    
    % Construct right-hand side
    cy = conj(reshape(c,nn,1)).*repmat(y,n_ord,1);

    % Free memory
    clear diags_B B BB_D BB_U ii_U jj_U cc_U
end



%% Solve

if multiorder
    xx = BB\cy;
    x = 2 * reshape(xx,[n_t,n_ord]);
else
    x = complex(zeros(n_t,n_ord),0);
    for ki = 1:n_ord
        cy_k = conj(c(:,ki)).*y;
        x(:,ki) = 2 * (B\cy_k);
    end
end

switch nargout
    case 1 % Output real-valued order waveforms
        varargout{1} = real(x.*c);
    case 2 % Output complex-valued envelopes and phasors
        varargout{1} = x;
        varargout{2} = c;
    case 3 % Output additional r-vectors
        varargout{1} = x;
        varargout{2} = c;
        varargout{3} = r;
end
end

function vkfdemo()
fs = 4000;
T = 5;
dt = 1/fs;
t = (0:dt:(T-dt))';
N = numel(t);

% Instationary component
A1 = [linspace(0.5,1,floor(N/2)) linspace(1,0.5,ceil(N/2))]';
f1 = 0.2*fs - 0.1*fs*cos(pi*t/T);
phi1 = 2*pi*cumsum(f1)*dt;
y1 = A1.*cos(phi1);

% Stationary component
A2 = ones(N,1);
f2 = 0.2*fs*ones(N,1);
phi2 = 2*pi*cumsum(f2)*dt;
y2 = A2.*sin(phi2);

% White noise
e = 2*rand(size(y1));

% Mixed signal
y = y1 + y2 + e;

% Perform VKF on periodic components
p = 2;
bw = 1;
[a,c] = vkf(y,fs,[f1 f2],p,bw);
x = real(a.*c);

% Reveal white noise
w = y-sum(x,2);

% Plot
figure('color','white')
subplot(2,1,1)
spectrogram(y,round(fs/16),[],[],fs)
subplot(2,1,2), hold on
plot(t,[A1 A2],'--')
plot(t,abs(a))
xlabel('Time (s)')
ylabel('Amplitude')

% Playback
soundsc(y,fs) % Original signal
soundsc(x,fs) % Periodic components (2 channels)
soundsc(w,fs) % Remaining white noise
end