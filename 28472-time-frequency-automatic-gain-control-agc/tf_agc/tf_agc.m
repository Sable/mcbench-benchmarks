function [y,D,E] = tf_agc(d,sr,t_scale,f_scale,type)
% [y,D,E] = tf_agc(d,sr,t_scale,f_scale,type)
%    Perform frequency-dependent automatic gain control on an auditory
%    frequency axis.  
%    d is the input waveform (at sampling rate sr); 
%    y is the output waveform with approximately constant
%    energy in each time-frequency patch.
%    t_scale is the "scale" for smoothing in time (default 0.5 sec).
%    f_scale is the frequency "scale" (default 1.0 "mel").
%    type == 0 selects traditional infinite-attack, exponential release.
%    type == 1 selects symmetric, non-causal Gaussian-window smoothing.
%    D returns actual STFT used in analysis.  E returns the
%    smoothed amplitude envelope divided out of D to get gain control.
% 2010-08-12 Dan Ellis dpwe@ee.columbia.edu
% $Header: /Users/dpwe/projects/sfx/RCS/tf_agc.m,v 1.1 2010/08/13 15:41:18 dpwe Exp $

if nargin < 3;  t_scale = 0.5;  end
if nargin < 4;  f_scale = 1.0;  end
if nargin < 5;  type = 0;       end

% Make STFT on ~32 ms grid
ftlen = 2^round(log(0.032*sr)/log(2));
winlen = ftlen;
hoplen = winlen/2;
D = stft(d,ftlen,winlen,hoplen);
ftsr = sr/hoplen;
ndcols = size(D,2);

% Smooth in frequency on ~ mel resolution
% Width of mel filters depends on how many you ask for, 
% so ask for fewer for larger f_scales
nbands = max(10,20/f_scale); % 10 bands, or more for very fine f_scale
mwidth = f_scale*nbands/10; % will be 2.0 for small f_scale
f2a = fft2melmx(ftlen, sr, nbands, mwidth);
f2a = f2a(:,1:(ftlen/2+1));
audgram = f2a * abs(D);

if type == 1

  % noncausal, time-symmetric smoothing
  % Smooth in time with tapered window of duration ~ t_scale
  tsd = round(t_scale*ftsr)/2;
  htlen = 6*tsd; % Go out to 6 sigma
  twin = exp(-0.5*((([-htlen:htlen])/tsd).^2))';

  % reflect ends to get smooth stuff
  AD = audgram;
  fbg = filter(twin,1,...
               [AD(:,htlen:-1:1),...
                AD,...
                AD(:,end:-1:(end-htlen+1)),...
                zeros(size(AD,1),htlen)]',...
               [],1)';
  % strip "warm up" points
  fbg = fbg(:,length(twin)+[1:ndcols]);

else

  % traditional attack/decay smoothing
  fbg = zeros(size(audgram,1),size(audgram,2));
  state = zeros(size(audgram,1),1);
  alpha = exp(-(1/ftsr)/t_scale);
  for i = 1:size(audgram,2)
    state = max([alpha*state,audgram(:,i)],[],2);
    fbg(:,i) = state;
  end

end
  
% map back to FFT grid, flatten bark loop gain
sf2a = sum(f2a);
E = diag(1./(sf2a+(sf2a==0))) * f2a' * fbg;
% Remove any zeros in E (shouldn't be any, but who knows?)
E(E(:)<=0) = min(E(E(:)>0));

% invert back to waveform
y = istft(D./E);
