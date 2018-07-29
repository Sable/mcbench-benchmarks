function pitchwatch(x,Ts)
% Plot the pitch keys.
% pitchwatch(x,[Ts])
% 
% :: Syntax
%    The array x is the input signal and Ts is the (optional) sampling period.
%    Example on use: [x,Fs] = wavread('Hum.wav');
%                    pitchwatch(x,1/Fs);
% 
% :: Information
%    Make your own wav-files with the Windows Sound Recorder. Choose the attributes
%    PCM 8000Hz, 16bit, Mono when saving the wav-file. For more information on pitch
%    keys, go to http://www.bookrags.com/wiki/Piano_key_frequencies.

% Set parameters.
if nargin < 2, Ts = 1/8000; end

% Set constants.
xlen = length(x);
wlen = 512;
wlag = 128;

% Zero-pad signal.
xpad = wlag-rem(xlen-wlen-1,wlag)-1;
x    = [x(:); zeros(xpad,1)];
L    = (xlen+xpad-wlen)/wlag+1;
L    = L-wlen/wlag/2;

% Calculate the AMDF and AMDF-fractional pitch periods.
for k1 = 1:L
   k2 = (k1-1)*wlag;
   for k3 = 1:wlen/2-1, c(k3) = sum(abs(x(k2+(1:wlen))-x(k2+k3+(1:wlen)))); end
   
   n = findpeaks(-c);
   if ~isempty(n), n(find(c(n) > mean(c(n))-sqrt(var(c(n))))) = []; end
   if ~isempty(n), t0 = n(1);
   else,           t0 = []; end
   
   if ~isempty(t0)
      u1    = x(k2+t0+(1:wlen))-x(k2+(1:wlen));
      u2    = x(k2+t0+(1:wlen))-x(k2+t0+1+(1:wlen));
      t1    = sum(u1.*u2)/sum(u2.*u2);
      y(k1) = 1/Ts/(t0+t1);
   else
      y(k1) = NaN;
   end
end

% Plot pitch keys.
keys = {'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
key0 = 12*log2(y/440)+57;
u1   = max(0,min(floor(key0)));
u2   = min(96,max(ceil(key0)));
key1 = mod([u1:u2],12)+1;
key2 = floor([u1:u2]/12);
for k = [1:u2-u1+1], tick(k) = strcat(keys(key1(k)),num2str(key2(k))); end
figure, plot((0.5+[0:L-1])*wlag*Ts,key0,'b.');
set(gca,'FontSize',8,'XLim',[0,L*wlag]*Ts,'YLim',[u1,u2],'YTick',[u1:u2],'YTickLabel',tick);
xlabel('Time'); ylabel('Key');

% FUNCTIONS

function n = findpeaks(x)

n    = find(diff(diff(x) > 0) < 0);
u    = find(x(n+1) > x(n));
n(u) = n(u)+1;
