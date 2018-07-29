function [xhat,e,k,theta0,P,b] = celp16k(x,N,L,M,c,cb,Pidx)
%  celp --> 16000 bps CELP analyzer and synthesizer.
%
%    [xhat,e,k,theta0,P,b] = celp16k(x,N,L,M,c,cb,Pidx)
%
%    The function implements a 16000 bps CELP analyzer and synthesizer,
%    if the speech signal is sampled at 8 kHz, the frame size N is 20 ms
%    (160 samples), and the block duration L for the excitation sequence
%    selection is 5 ms (40 samples). Furthermore, assume that the
%    codebook has 1024 sequences which require 10 bit to send the index k,
%    and that the lag of the pitch filter, P, is searched in the range 16
%    to 160 which require 8 bit to represent exactly. Thus, the quantization
%    procedure only affects the M = 12 LPC parameters (inverse sine) coded
%    by 12 bits, the gain Theta0 coded by 13 bit, and the pitch filter coeff.
%    b coded by 13 bit.

Nx = length(x);                         % Signal length.
F  = fix(Nx/N);                         % No. of frames.
J  = N/L;                               % No. blocks per frame.

% Initialize output signals.
xhat   = zeros(Nx,1);                   % Synthesized signal.
e      = zeros(Nx,1);                   % Excitation signal.
k      = zeros(J,F);                    % Columns are excitation
theta0 = zeros(J,F);                    % parameters per frame.
P      = zeros(J,F);
b      = zeros(J,F);

ebuf  = zeros(Pidx(2),1);               % Vectors with previous excitation
ebuf2 = ebuf; bbuf = 0;                 % samples.
Zf = []; Zw = []; Zi = [];              % Memory hangover in filters.

for (f=1:F)
  %fprintf(1,'... Frame no. %g out of %g.\n',f,F);
  n = (f-1)*N+1:f*N;                    % Time index of current speech frame.

  [kappa,kf,theta0f,Pf,bf,ebuf,Zf,Zw] = celpana(x(n),L,M,c,cb,Pidx,bbuf,...
                                                                ebuf,Zf,Zw);

  sigma  = 2/pi*asin(kappa);
  sigma  = udecode(uencode(sigma,12),12);
  kappa  = sin(pi/2*sigma);
  theta0 = udecode(uencode(theta0,13,0.2),13,0.2);
  b      = udecode(uencode(b,13,1.4),13,1.4);

  [xhat(n),ebuf2,Zi] = celpsyn(cb,kappa,kf,theta0f,Pf,bf,ebuf2,Zi);

  % Output excitation signal and parameters for current frame.
  e(n)        = ebuf(Pidx(2)-N+1:Pidx(2));
  k(:,f)      = kf;
  theta0(:,f) = theta0f;
  P(:,f)      = Pf;
  b(:,f)      = bf; bbuf = bf(J);       % Last estimated b used in next frame.
end
