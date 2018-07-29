function spectgray(x,Ts,wn,N)
% Plot the grayscale spectrogram.
% spectgray(x,[Ts,wn,N])

% Set parameters.
if nargin < 2, Ts = 1; end
if nargin < 3, wn = struct('type','hanning','len',128,'lag',8); end
if nargin < 4, N  = 2*wn.len; end

% Set constants.
xlen = length(x);
wlen = wn.len;
wlag = wn.lag;
w    = feval(wn.type,wlen);

% Zero-pad signal.
xpad = wlag-rem(xlen-wlen-1,wlag)-1;
x    = [x(:); zeros(xpad,1)];
L    = (xlen+xpad-wlen)/wlag+1;
c1   = (L-1)*Ts*wlag;
c2   = (N+2)/(N+1)/Ts/2;

% Compute FFT coefficients.
u1 = transpose(1:wlen);
u2 = wlag*(0:L-1);
y  = x(u1(:,ones(1,L))+u2(ones(1,wlen),:));
y  = fft(w(:,ones(1,L)).*y,N);
%% for k = 1:L, y(:,k) = fft(w.*x((k-1)*wlag+(1:wlen)),N); end
y  = y(1:N/2+1,:);

figure, imagesc([0 c1],[0 c2],log(abs(y)));
set(gca,'FontSize',8,'YDir','normal'); xlabel('Time'), ylabel('Frequency'), colormap gray
